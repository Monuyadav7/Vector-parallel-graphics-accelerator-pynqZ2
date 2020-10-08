#define __MAIN_C__

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include<math.h>

// Define the raw base address values for the i/o devices

#define AHB_SW_BASE                             0x40000000
#define AHB_PIX_BASE                            0x50000000

// Define pointers with correct type for access to 32-bit i/o devices
volatile uint32_t* SW_REGS = (volatile uint32_t*) AHB_SW_BASE;
volatile uint32_t* PIX_REGS = (volatile uint32_t*) AHB_PIX_BASE;

#include <stdint.h>

/////////////////////////////////////////////////////////////////
// Functions provided to access i/o devices
////////////////////////////////////////////////////////////////

void write_pix( int p_x, int p_y, int colour) {
  int pix_address ;
  pix_address = p_x + 640*p_y ;
  PIX_REGS[pix_address] = colour;
  }

bool PointinTriangle(int x1, int y1, int x2, int y2, int x3, int y3, int x, int y){
  
  int L1_detT   =   ((y2-y3)*(x-x3))+((x3-x2)*(y-y3)) ;
  int L2_detT   =   ((y3-y1)*(x-x3))+((x1-x3)*(y-y3)) ;
  int detT =   ((y2-y3)*(x1-x3))+((x3-x2)*(y1-y3)) ;

if((L1_detT + L2_detT) > detT)
  return true ;
else 
  return false ;  

}

uint32_t read_switches(int addr) {

  return SW_REGS[addr];

}

bool check_switches(int addr) {

  int status, switches_ready;
  
  status = SW_REGS[2];
  
  // use the addr value to select one bit of the status register
  switches_ready = (status >> addr) & 1;
  
  return (switches_ready == 1);

}

void wait_for_any_switch_data(void) {

  // this is a 'busy wait'

  //  ( it should only be used if there is nothing
  //   else for the embedded system to do )

  while ( SW_REGS[2] == 0 );
  
  return;

}


//////////////////////////////////////////////////////////////////
// Main Function
//////////////////////////////////////////////////////////////////
int main(void) {

  
  
while(1) {
  int x1 = 10;
  int y1 = 30;
  
 
  int x2 = 20;
  int y2 = 40;
  
  int x3 = 20;
  int y3 = 30;
  
  
  int L1_detT ;
  int L2_detT ;
  int detT ;
  
  int L1_positive, L2_positive, L3_positive ;


for (int x = 0 ; x < 640 ; x++){
    for (int y = 0 ; y < 480 ; y++) {
    
	   L1_detT   =   ((y2-y3) *  (x-x3)) + ((x3-x2) *  (y-y3)) ;
           L2_detT   =   ((y3-y1) *  (x-x3)) + ((x1-x3) *  (y-y3)) ;
           detT  =   	 ((y2-y3) * (x1-x3)) + ((x3-x2) * (y1-y3)) ;
	   
          L1_positive = ((L1_detT >= 0) == (detT >= 0)) ;
	  L2_positive = ((L2_detT >= 0) == (detT >= 0)) ;
	  L3_positive = (((L1_detT + L2_detT) <= detT) == (detT >= 0)) ;
	  
	  
	   if(L1_positive && L2_positive && L3_positive)
            	write_pix(x,y,1);

    } 
  }
 }
}        
