// Example code for an M0 AHBLite System
//  Iain McNally
//  ECS, University of Soutampton
//
// This module is an AHB-Lite Slave containing a RAM
// Since this loads a program it is for FPGA use only
//
// Number of addressable locations : 307200
// Size of each addressable location : bits_per_pixel bits
// Supported transfer sizes : Word
// Alignment of base address : Word aligned
//

// Memory is synchronous which should suit block memory types
//   Read takes 1 cycle
//   Write takes 2 cycles (single wait state)
//
// Note this is not the most efficient design but works with
//  Xilinx and Altera(Intel) FPGAs
//


module ahb_pixel_memory (

  //AHBLITE INTERFACE

    //Slave Select Signal
    input HSEL,
    //Global Signals
    input HCLK,
    input HRESETn,
    //Address, Control & Write Data
    input HREADY,
    input [31:0] HADDR,
    input [1:0] HTRANS,
    input HWRITE,
    input [2:0] HSIZE,
    input [31:0] HWDATA,
    
    // non ahb input 
    input [9:0] pixel_x ,
    input [8:0] pixel_y ,
    // Transfer Response & Read Data
    output HREADYOUT,
    output logic [31:0] HRDATA,
    
    //Non-AHB Signals
    output logic pixel 


);

timeunit 1ns;
timeprecision 100ps;

localparam No_Transfer = 2'b0;

//memory
  logic [7:0] memory [0:307199] ;

// other declarations
  logic write_enable, read_enable;
  logic [18:0] word_address;
  logic [18:0] pixel_address ;


//Generate the control signals here:
always_ff @(posedge HCLK, negedge HRESETn)
    if (! HRESETn )
      begin
        write_enable <= '0;
        read_enable <= '0;
        word_address <= '0;
      end
    else if ( HREADY && HSEL && (HTRANS != No_Transfer) )
      begin
        write_enable <= HWRITE;
        read_enable <= ! HWRITE;
        word_address <= HADDR[20:2];
     end
    else
      begin
        write_enable <= '0;
        read_enable <= '0;
        word_address <= '0;
     end



  //memory 
  always_ff @(posedge HCLK)
    begin 
      if( write_enable )
        memory[word_address] <= HWDATA ; 
    end 
  
  always_comb 
    pixel_address = (pixel_y * 640) + pixel_x  ;
    
   
      
   assign pixel = memory[pixel_address] ;
   
   assign HRDATA = read_enable ? memory[word_address] : '0 ;   
   
   /*
   assign bv1 = memory[0] ;
   assign bv2 = memory[1] ;
   assign bv3 = memory[2] ;
   assign tv1 = memory[3] ;
   assign tv2 = memory[4] ;
   assign tv3 = memory[5] ;
   assign BCO = memory[6] ;
   assign TCO = memory[7] ;
   */
    
 
//Transfer Response
  assign HREADYOUT = '1; //Single Cycle Wait State for Write


endmodule

