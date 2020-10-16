#define __MAIN_C__

#include <stdint.h>
#include <stdbool.h>


// Define the raw base address values for the i/o devices

#define AHB_SW_BASE                             0x40000000
#define AHB_PIX_BASE                            0x50000000

// Define pointers with correct type for access to 32-bit i/o devices
volatile uint16_t* SW_REGS = (volatile uint16_t*) AHB_SW_BASE;
volatile uint16_t* PIX_REGS = (volatile uint16_t*) AHB_PIX_BASE;


/////////////////////////////////////////////////////////////////
// Functions provided to access i/o devices
////////////////////////////////////////////////////////////////

void write_pix( int p_x, int p_y, int colour) {
  int pix_address ;
  pix_address = p_x + 640*p_y ;
  PIX_REGS[pix_address] = colour;
  }

// Read out (void) removed from the code because
// functionality does not exist in main() 

/////////////////////////////////////////////////////////////////
// Functions to interface with switches and buttons
/////////////////////////////////////////////////////////////////

uint16_t read_switches(int addr) {

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
  int x1 ;
  int y1 ;
  
 
  int x2 = 50;
  int y2 = 300;
  
  int x3 = 500;
  int y3 = 70;
  
  
  int L1_detT ;
  int L2_detT ;
  int detT ;
  
  int L1_positive, L2_positive, L3_positive ;
  
   wait_for_any_switch_data();
    
    if ( check_switches(0) ) {
      x1 =  read_switches(0) ;
    }

    if ( check_switches(1) ) {
      y1  = read_switches(1);
    }  

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

  } }

 }
}        
