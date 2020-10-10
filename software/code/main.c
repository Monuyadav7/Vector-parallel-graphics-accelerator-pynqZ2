#define __MAIN_C__

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include <math.h>

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
    
    struct Screen screen;
    screen.width = 640;
    screen.height = 480;
    
    
    Mole moles[9];
    
    
    time_t seconds; 
   
    
    int moleRadius = 50;
    int spacing = 5;
    int maxHeight = 90;
    for (int i = 0; i< 9; i++){
        int row = i/3;
        int column = i%3;
        
        struct Mole m;
        m.centerX  = (screen.width/2 - moleRadius*1.5) + row*(moleRadius+spacing);
        m.centerY = (screen.height/2 - moleRadius*1.5) + row*(moleRadius+spacing);
        m.radius = moleRadius;
        
        
        moles[i] = m;
    }
    
    
    while(1){
        
        time(&seconds); 
        for (int i = 0; i< 9; i++){
            struct Mole m = moles[9];
            physics(m, maxHeight, seconds)
        }
        
        
    }
    
    
}
    
    
  


void drawTriangle(int pos1, int pos2, int pos3){
    
    
    
    
}








////////////////////////////
///////// STRUCTURES ///////
////////////////////////////

struct Screen{
    int width;
    int hright;
}



struct Mole{
    int centerX;
    int centerY;
    int radius = 30;
    int height = 0;
    int oldTime = 0;
    m.state = random;
}




void drawCircle(int centerX, int centerY, int radius, int thicknessMax, float angleMax, int color){
    for (int thickness = 0; thickness < thicknessMax; thickness++){
      for (float angle = 0; angle < angleMax; angle++){
             float posX = centerX + ((radius+thickness) *  cos(angle*PI/180.0));
             float posY = centerY + ((radius+thickness) * sin(angle*PI/180));
             write_px((int) posX, (int) posY, color);
        }
    }
}

void render(struct Mole mole, int color){
    
    drawCircle(mole.centerX, mole.centerY, mole.radius, 5, 360, 1);
    
    
    int newR = mole.radius-5;
    
    for (int i = mole.height; i>=0; i--){
        write_px((int) mole.centerX+newR, i + centerY, color)
        write_px((int) mole.centerX-newR, i + centerY, color)   
    }
    
    drawCircle(mole.centerX, mole.centerY + mole.height, newR, 1, 180, 1);

    
}



void physics(struct Mole m, int maxHeight, int time){
    if (time-m.oldTime < 200)
        return;
    
    if(m.height < maxHeight && m.state == 0){
        m.height = m.height+1;
    }else{
        m.state = 1;
    }
    
    if (m.height > 0 && m.state == 1){
        m.height--;
    }else{
        m.state = 0;
    }
    
    
}








