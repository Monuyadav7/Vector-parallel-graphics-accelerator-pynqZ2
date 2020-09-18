module Triangle (
 input logic clk,
 input logic nReset,
 input logic [27:0]bv1, bv2, bv3,
 input logic [27:0]tv1, tv2, tv3,
 input logic [3:0] BCO, TCO,
 output logic [10:0] x, y,
 output logic [3:0] TRIcolour,
 output logic request);

logic [10:0] ycurrent, xcurrent, bi, ti, j;
logic [10:0] bx1, by1, bx2, by2, bx3, by3, btx2, bmax, top;
logic [10:0] tx1, ty1, tx2, ty2, tx3, ty3, ttx2, tmax, bot;
logic bm, bn, tm, tn;
logic [31:0] bslope12, bslope13, tslope13, tslope23, b12, b13, t13, t23,d;
logic [3:0] bco, tco;
assign bx1 = bv1%640;
assign by1 = bv1/640;
assign bx2 = bv2%640;
assign by2 = bv2/640;
assign bx3 = bv3%640;
assign by3 = bv3/640;
assign tx1 = tv1%640;
assign ty1 = tv1/640;
assign tx2 = tv2%640;
assign ty2 = tv2/640;
assign tx3 = tv3%640;
assign ty3 = tv3/640;
//get value of slopes
always_comb
begin
  if(bx2>bx1)
    begin
    bslope12 = ((bx2-bx1)*10000)/(by2-by1);
    bm = 1;
    end
  else
    begin
    bslope12 = ((bx1-bx2)*10000)/(by2-by1);
    bm = 0;
    end
 if(bx3>bx1)
    begin
    bslope13 = ((bx3-bx1)*10000)/(by3-by1);
    bn = 1;
    end
 else
    begin
    bslope13 = ((bx1-bx3)*10000)/(by3-by1);
    bn = 0;
    end
 if(tx3>tx1)
    begin
    tslope13 = ((tx3-tx1)*10000)/(ty3-ty1);
    tm = 1;
    end
 else
    begin
    tslope13 = ((tx1-tx3)*10000)/(ty3-ty1);
    tm = 0;
    end
 if(tx3>tx2)
    begin
    tslope23 = ((tx3-tx2)*10000)/(ty3-ty2);
    tn = 1;
    end
 else
    begin
    tslope23 = ((tx2-tx3)*10000)/(ty3-ty2);
    tn = 0;
    end
end

enum{idle, bprep, bdrawy, bdrawx, tprep, tdrawy, tdrawx}state;

always_ff @(posedge clk, negedge nReset)
 if ( ! nReset)
  begin
  ycurrent <= 0;
  xcurrent <= 0;
  bi <= 0;
  ti <= 0;
  j <= 0;
  d <= 0;
  btx2 <= 0;
  ttx2 <= 0;
  request <= 0;
  bco <= 0;
  bmax <= 0;
  state <= 0;
  b12 <= 0;
  b13 <= 0;
  top <= 0;
  ti <= 0;
  tco <= 0;
  tmax <= 0;
  state <= 0;
  t13 <= 0;
  t23 <= 0;
  bot <= 0;
  TRIcolour <= 0;
 end
 else
  begin : DRAW_BOTTOM_FLAT_TRIANGLE
  case(state)
     idle:begin
          request <= 0;
	  if(by3 != 0)
	    state <= bprep;
	  else if (ty3 != 0) 
	    state <= tprep;
	  end
     bprep:begin
	   d <= 0;
	   bi <= by1;
	   bco <= BCO;
	   bmax <= by2;
	   state <= bdrawy;
	   b12 <= bslope12;
	   b13 <= bslope13;
	   top <= bx1;
	   end
     bdrawy:begin
	    request <= 0;
	    ycurrent <= bi;
	
	   if(bm)
	     j <= top + (d*b12)/10000;
	   else 
             j <= top - (d*b12)/10000;
	
	   if(bn)
	     btx2 <= top + (d*b13)/10000;
           else 
	     btx2 <= top - (d*b13)/10000;
	
	   state <= bdrawx;
	    end
	    
     bdrawx:begin
	    xcurrent <= j;
	    TRIcolour <= bco;
	    request <= 1;
	    j = j+1;
	    if( j > btx2)
	      begin
	      bi <= bi+1;
	       if(bi< bmax) 
	       
		 begin
		 d = d+1;
		 state <= bdrawy;
		 end
		 
	       else if (ty3 != 0) 
		 state <= tprep;
		   
	       else 
		 state <= idle;
	      end
	      
	    end
	    
     tprep:begin
	   request <= 0;
	   d <= 0;
	   ti <= ty3;
	   tco <= TCO;
	   tmax <= ty1;
	   state <= tdrawy;
	   t13 <= tslope13;
	   t23 <= tslope23;
	   bot <= tx3;
	   end
	   
   tdrawy:begin
	  request <= 0;
	  ycurrent <= ti;
	 if(tm)
	 	j <= bot - (d*t13)/10000;
	 else 
	 	j <= bot + (d*t13)/10000;
		
		
	 if(tn)
	 	ttx2 <= bot - (d*t23)/10000;
	 else 
	 	ttx2 <= bot + (d*t23)/10000;
		
	 state <= tdrawx;
   	 end
  tdrawx:begin
	 xcurrent <= j;
	 TRIcolour <= tco;
	 request <= 1;
	 j = j+1;
	 if( j > ttx2)
	   begin
	    ti <= ti-1;
	    if(ti> tmax) 
	      begin
	       d = d+1;
	      state <= tdrawy;
	      end
	      
	    else 
	       begin 
	       state <= idle; 
	       end
	   end
         end
      endcase
   end : DRAW_BOTTOM_FLAT_TRIANGLE
 
assign x = xcurrent;
assign y = ycurrent;

endmodule
