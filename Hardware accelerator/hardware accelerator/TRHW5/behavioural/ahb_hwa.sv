 // Example code for an M0 AHBLite System
//  Iain McNally
//  ECS, University of Soutampton
//
// This module is an AHB-Lite Slave containing six write registers and one read registers 
//
// Number of addressable locations : 9
// Size of each addressable location : 32 bits
// Supported transfer sizes :  Word
// Alignment of base address : Word aligned
//
// Address map :
//   Base addess + 0 : 
//     Write x1 register
//
//   Base addess + 4 : 
//     Write y1 register 
//
//   Base addess + 8 : 
//     Write x2 register 
//
//   Base addess + 12 : 
//     Write y2 register 
//
//   Base addess + 16 : 
//     Write x3 register 
//
//   Base addess + 20 : 
//     Write y3 register
//
//   Base addess + 24 : 
//     Write x register
//
//   Base addess + 28 : 
//     Write y register
//
//   Base addess + 32 : 
//     Read pixel_value register
//
// Bits within status register : ( Currently not in use )
//   Bit 1   NextDataValid
//   Bit 0   DataValid



module ahb_hwa(

  // AHB Global Signals
  input HCLK,
  input HRESETn,

  // AHB Signals from Master to Slave
  input [31:0] HADDR, // With this interface only HADDR[5:2] is used (other bits are ignored)
  input [31:0] HWDATA,
  input [2:0] HSIZE,
  input [1:0] HTRANS, 
  input HWRITE,
  input HREADY,
  input HSEL,
  // AHB Signals from Slave to Master
  output logic [31:0] HRDATA,
  output HREADYOUT

);

timeunit 1ns;
timeprecision 100ps;

  // AHB transfer codes needed in this module
  localparam No_Transfer = 2'b0;

  //control signals are stored in registers
  logic write_enable, read_enable;
  logic [3:0] word_address  ;
  
  // raster registers
  logic signed [31:0] x,y ;
  logic signed [31:0] x1, x2, y1, y2, x3, y3 ;
  logic signed [31:0] L1_detT ;
  logic signed [31:0] L2_detT ; 
  logic signed [31:0] detT ;
  logic L1_positive ;
  logic L2_positive ; 
  logic L3_positive ;
  logic inside_triangle ;
  
  // reading pixel_value HRDATA using inside_triangle now 
  
  // Unused registers 
  logic NextDataValid;
  logic [15:0] Status;
  
  // States were added to make the code look similar to the simulated 
  // raster hardware and make the rasterisation 
  // happens only after all the coordinate values had been inputed

  //Generate the control signals in the address phase
  always_ff @(posedge HCLK, negedge HRESETn)
    if ( ! HRESETn )
      begin
        write_enable <= '0;
        read_enable <= '0;
        word_address <= '0;
      end
    else if ( HREADY && HSEL && (HTRANS != No_Transfer) )
      begin
        write_enable <= HWRITE;
        read_enable <= ! HWRITE;
        word_address <= HADDR[5:2];

     end
    else
      begin
        write_enable <= '0;
        read_enable <= '0;
        word_address <= '0;
     end

  // Act on control signals in the data phase
  // Write pixel_value coordinates 
  always_ff @(posedge HCLK, negedge HRESETn)
    if ( ! HRESETn )
      begin
        x1 <= '0;
    	x2 <= '0;
        x3 <= '0;
    	y1 <= '0;
    	y2 <= '0;
        y3 <= '0;
		x  <= '0;
		y  <= '0;

      end
    // x1 write     
    else if ( write_enable && (word_address==0))
      x1 <= HWDATA;

    // y1 write     
    else if ( write_enable && (word_address==1))
      y1 <= HWDATA;

    // x2 write     
    else if ( write_enable && (word_address==2))
      x2 <= HWDATA;

    // y2 write     
    else if ( write_enable && (word_address==3))
      y2 <= HWDATA;

    // x3 write     
    else if ( write_enable && (word_address==4))
      x3 <= HWDATA;

    // y3 write     
    else if ( write_enable && (word_address==5))
      y3 <= HWDATA;
  
	// x 	
    else if ( write_enable && (word_address==6))
      x <= HWDATA;

    // y   
    else if ( write_enable && (word_address==7))
      y <= HWDATA;


	
// raster always_comb was changed to always_ff because the synthesis tool did not register the following as pure combinational logic 

 always_ff @ (posedge HCLK, negedge HRESETn)
    if ( ! HRESETn )
	begin 
		L1_positive <= '0 ;
		L2_positive <= '0 ;
		L3_positive <= '0 ;
		inside_triangle <= '0;
	end
	else
	begin 
	  L1_detT   <=   ((y2-y3) *  (x-x3)) + ((x3-x2) *  (y-y3)) ;
	  L2_detT   <=   ((y3-y1) *  (x-x3)) + ((x1-x3) *  (y-y3)) ;
	  detT      <=   ((y2-y3) * (x1-x3)) + ((x3-x2) * (y1-y3)) ;
	  
	  if ((L1_detT >= 0) == (detT >= 0)) 
		L1_positive <= '1 ;
	  else
		L1_positive <= '0 ;



	  if ((L2_detT >= 0) == (detT >= 0)) 
	  	L2_positive <= '1 ;
	  else 
		L2_positive <= '0 ;
		
	
      if (((L1_detT + L2_detT) <= detT) == (detT >= 0)) 
	  	L3_positive <= '1 ;
	  else 
		L3_positive <= '0 ;
		
		
	  if((L1_positive == '1) && (L2_positive == '1) && (L3_positive == '1 ))
        inside_triangle <= '1 ;
	  else
	    inside_triangle <= '0 ;
	
	end 
	


//read
  always_comb
    if ( ! read_enable )
      // (output of zero when not enabled for read is not necessary
      //  but may help with debugging)
      HRDATA = '0;
    else 
		case (word_address)
			8: HRDATA = inside_triangle ;
		// unused address - returns zero
      default : HRDATA = '0;
      endcase



//Transfer Response
  assign HREADYOUT = '1; //Single Cycle Wait State for Write


endmodule

