/******************************************************************************
*
* Copyright (c) 2021, Florent Werbrouck
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this
*    list of conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice,
*    this list of conditions and the following disclaimer in the documentation
*    and/or other materials provided with the distribution.
* 
* 3. Neither the name of the copyright holder nor the names of its
*    contributors may be used to endorse or promote products derived from
*    this software without specific prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
******************************************************************************/





#include <stdio.h>
#include "xil_printf.h"
#include "xparameters.h"
#include "sleep.h"
#include "video_out_pynq.h"
#include "triangles_data.h"

// AXI Rasterizer Base Address
#define RASTERIZER_BASE XPAR_RASTERIZER20_1_BASEADDR

// Register Offsets for 60 coordinates (x1 to x60, y1 to y60)
#define REG_STATUS 0xF0  // Assume status register at offset 0xF0

XGpio XGpioInst;
XVtc VtcInst;

// Initialize peripherals
int system_init(XVtc* VtcInstPtr, XGpio* XGpioInstPtr) {
    int Status = XST_SUCCESS;

    XVtc_Config *VtcConfig = XVtc_LookupConfig(0);
    Status = XVtc_CfgInitialize(VtcInstPtr, VtcConfig, VtcConfig->BaseAddress);
    if (Status != XST_SUCCESS) {
        xil_printf("VTC configuration failed\n");
        return XST_FAILURE;
    }

    Status = XGpio_Initialize(XGpioInstPtr, 0);
    if (Status != XST_SUCCESS) {
        xil_printf("GPIO Initialization Failed\n");
        return XST_FAILURE;
    }

    return Status;
}

// Configure VTC timing for the resolution
void configure_vtc_gen(XVtc *InstancePtr, const XVidC_VideoStream *Strm) {
    XVtc_Reset(InstancePtr);
    XVtc_DisableGenerator(InstancePtr);
    XVtc_Disable(InstancePtr);

    XVtc_Timing t;
    t.HActiveVideo  = Strm->Timing.HActive;
    t.HBackPorch    = Strm->Timing.HBackPorch;
    t.HFrontPorch   = Strm->Timing.HFrontPorch;
    t.HSyncPolarity = Strm->Timing.HSyncPolarity;
    t.HSyncWidth    = Strm->Timing.HSyncWidth;
    t.Interlaced    = Strm->IsInterlaced;
    t.V0BackPorch   = Strm->Timing.F0PVBackPorch;
    t.V0FrontPorch  = Strm->Timing.F0PVFrontPorch;
    t.V0SyncWidth   = Strm->Timing.F0PVSyncWidth;
    t.V1BackPorch   = Strm->Timing.F1VBackPorch;
    t.V1FrontPorch  = Strm->Timing.F1VFrontPorch;
    t.V1SyncWidth   = Strm->Timing.F1VSyncWidth;
    t.VActiveVideo  = Strm->Timing.VActive;
    t.VSyncPolarity = Strm->Timing.VSyncPolarity;

    XVtc_SetGeneratorTiming(InstancePtr, &t);
    XVtc_RegUpdate(InstancePtr);
    XVtc_Enable(InstancePtr);
    XVtc_EnableGenerator(InstancePtr);
}

// Write all 20 triangles (60 coordinates) to rasterizer
void write_triangles_from_array() {
    //xil_printf("\nWriting 20 triangles from triangle_coords[]...\r\n");

    for (int i = 0; i < NUM_TRIANGLES * 6; i++) {
        Xil_Out32(RASTERIZER_BASE + i * 4, triangle_coords[i]);
    }

    // Wait until rasterizer finishes
    while ((Xil_In32(RASTERIZER_BASE + REG_STATUS) & 0x2) != 0) {
        xil_printf("Rasterizer busy... Status: 0x%08X\n", Xil_In32(RASTERIZER_BASE + REG_STATUS));
        usleep(100000);
    }

    xil_printf("Rasterization complete!\r\n");
}

// Main
int main() {
    xil_printf("EMBEDDED SYSTEM DESIGN EE712 Project\r\n");
    xil_printf("Starting Rasterizer Computation on PYNQ-Z2...\r\n\n");
    usleep(1000000);

    const XVidC_VideoTimingMode* VmPtr;
    XVidC_VideoStream VidStream;
    int resId = 0, resId_prev = 0;

    if (system_init(&VtcInst, &XGpioInst) != XST_SUCCESS) {
        xil_printf("System Initialization Failed!\n");
        return XST_FAILURE;
    }

    write_triangles_from_array();

    XVtc_EnableGenerator(&VtcInst);

    while (1) {
        resId_prev = resId;
        resId = main_menu();

        if (resId != resId_prev) {
            ClkWiz_Set_Output_Clock(XPAR_XCLK_WIZ_0_BASEADDR, resId);
            XGpio_DiscreteWrite(&XGpioInst, GPIO_RESET_CHANNEL, GPIO_RESET_ON);
            usleep(200);
            XGpio_DiscreteWrite(&XGpioInst, GPIO_RESET_CHANNEL, GPIO_RESET_OFF);
            usleep(200);

            VmPtr = XVidC_GetVideoModeData(get_video_mode_id(resId));
            XVidC_SetVideoStream(&VidStream, get_video_mode_id(resId), XVIDC_CSF_RGB, XVIDC_BPC_8, XVIDC_PPC_1);
            configure_vtc_gen(&VtcInst, &VidStream);

            xil_printf("Check HDMI Output for Rasterization Result\r\n");
        }
    }

    return 0;
}
