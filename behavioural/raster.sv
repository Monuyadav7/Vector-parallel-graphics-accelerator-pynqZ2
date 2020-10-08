module raster (	input logic CLOCK_50, 
	input logic  pixel,
    	output logic [7:0] VGA_R,VGA_G,VGA_B, 
	output logic [9:0] pixel_x,
	output logic [8:0] pixel_y ,
    	output logic VGA_HS,VGA_VS, VGA_CLK, VGA_BLANK_N);
