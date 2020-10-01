#define __MAIN_C__

#include <stdint.h>
#include <stdbool.h>

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
void write_pix(int x, int y, int colour) {
  int pix_address ;
  pix_address = x + 640*y ;
  PIX_REGS[pix_address] = colour;
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


for (int x = 0 ; x < 99 ; x++){
    for (int y = 0 ; y <99 ; y++) {
       write_pix (x,y,1) ;}}
       }
}       
