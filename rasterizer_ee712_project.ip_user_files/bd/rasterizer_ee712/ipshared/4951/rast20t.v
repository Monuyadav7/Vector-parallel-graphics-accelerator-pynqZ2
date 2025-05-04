module rasterizer20 #(
    parameter SCREEN_WIDTH = 640,
    parameter SCREEN_HEIGHT = 480,
    parameter TRIANGLE_COUNT = 20
)(
    input wire S_AXI_ACLK,
    input wire S_AXI_ARESETN,

    // AXI4-Lite Interface
    input wire [7:0] S_AXI_AWADDR,
    input wire S_AXI_AWVALID,
    output reg S_AXI_AWREADY,
    input wire [31:0] S_AXI_WDATA,
    input wire S_AXI_WVALID,
    output reg S_AXI_WREADY,
    output reg [1:0] S_AXI_BRESP,
    output reg S_AXI_BVALID,
    input wire S_AXI_BREADY,

    input wire [7:0] S_AXI_ARADDR,
    input wire S_AXI_ARVALID,
    output reg S_AXI_ARREADY,
    output reg [31:0] S_AXI_RDATA,
    output reg [1:0] S_AXI_RRESP,
    output reg S_AXI_RVALID,
    input wire S_AXI_RREADY,

    // AXI4-Stream Video Output
    output reg [23:0] m_axis_tdata,
    output reg m_axis_tvalid,
    input wire m_axis_tready,
    output reg m_axis_tlast,
    output reg m_axis_tuser
);

    // Triangle memory
    reg signed [31:0] triangle_mem [0:TRIANGLE_COUNT*6-1];
    reg [7:0] write_index;

    // Scan position
    reg [9:0] x;
    reg [8:0] y;

    // State
    reg [2:0] status; // Bit 0: Error, 1: Busy, 2: Done

    // Rendering control
    reg render_start;
    reg rendering;

    // Triangle intersection
    integer i;
    reg signed [31:0] x1, y1, x2, y2, x3, y3;
    reg signed [31:0] detT, L1_detT, L2_detT;
    reg inside_any;

    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            // Reset all signals
            S_AXI_AWREADY <= 1;
            S_AXI_WREADY <= 1;
            S_AXI_BVALID <= 0;
            S_AXI_BRESP <= 2'b00;
            S_AXI_ARREADY <= 1;
            S_AXI_RVALID <= 0;
            S_AXI_RDATA <= 0;
            S_AXI_RRESP <= 2'b00;

            m_axis_tdata  <= 0;
            m_axis_tvalid <= 0;
            m_axis_tlast  <= 0;
            m_axis_tuser  <= 0;

            x <= 0;
            y <= 0;
            write_index <= 0;
            render_start <= 0;
            rendering <= 0;
            status <= 3'b000; // idle
        end else begin
            // ---------------------------
            // AXI Write Channel (AW + W)
            // ---------------------------
            if (S_AXI_AWVALID && S_AXI_WVALID && S_AXI_AWREADY && S_AXI_WREADY) begin
                if (write_index < TRIANGLE_COUNT * 6) begin
                    triangle_mem[write_index] <= S_AXI_WDATA;
                    write_index <= write_index + 1;
                    if (write_index == TRIANGLE_COUNT * 6 - 1) begin
                        render_start <= 1;
                    end
                end else begin
                    status[0] <= 1'b1; // Error bit
                end
                S_AXI_BVALID <= 1;
                S_AXI_BRESP <= 2'b00;
            end

            if (S_AXI_BVALID && S_AXI_BREADY)
                S_AXI_BVALID <= 0;

            // ---------------------------
            // AXI Read Channel (AR)
            // ---------------------------
            if (S_AXI_ARVALID && S_AXI_ARREADY) begin
                S_AXI_RDATA <= {29'b0, status}; // bits: [2]=done, [1]=busy, [0]=error
                S_AXI_RVALID <= 1;
                S_AXI_RRESP <= 2'b00;
            end
            if (S_AXI_RVALID && S_AXI_RREADY)
                S_AXI_RVALID <= 0;

            // ---------------------------
            // Start rendering
            // ---------------------------
            //if (render_start) begin
                //render_start <= 0;
                //rendering <= 1;
                //x <= 0;
                //y <= 0;
            //end

            // ---------------------------
            // Rasterization logic
            // ---------------------------
            if (render_start && m_axis_tready) begin
                if (x < SCREEN_WIDTH && y < SCREEN_HEIGHT) begin
                    status <= 3'b010; // busy
                    inside_any = 0;
                    for (i = 0; i < TRIANGLE_COUNT; i = i + 1) begin
                        x1 = triangle_mem[i*6 + 0];
                        y1 = triangle_mem[i*6 + 1];
                        x2 = triangle_mem[i*6 + 2];
                        y2 = triangle_mem[i*6 + 3];
                        x3 = triangle_mem[i*6 + 4];
                        y3 = triangle_mem[i*6 + 5];

                        detT    = (y2 - y3)*(x1 - x3) + (x3 - x2)*(y1 - y3);
                        L1_detT = (y2 - y3)*(x  - x3) + (x3 - x2)*(y  - y3);
                        L2_detT = (y3 - y1)*(x  - x3) + (x1 - x3)*(y  - y3);

                        if ((detT > 0 && L1_detT >= 0 && L2_detT >= 0 && (L1_detT + L2_detT) <= detT) ||
							(detT < 0 && L1_detT <= 0 && L2_detT <= 0 && (L1_detT + L2_detT) >= -detT)) begin
							inside_any = 1;
						end

                    end

                    // Output current pixel
                    m_axis_tdata  <= (inside_any) ? 24'hFFFFFF : 24'h000000;
                    m_axis_tuser  <= (x == 0 && y == 0);
                    m_axis_tlast  <= (x == SCREEN_WIDTH - 1);
                    m_axis_tvalid <= 1;

                    // Advance to next pixel only if tready = 1
                    if (x == SCREEN_WIDTH - 1) begin
                        x <= 0;
                        if (y == SCREEN_HEIGHT - 1) begin
                            y <= 0;
                            //rendering <= 0;
                            status <= 3'b100; // done
                            //write_index <= 0; // ready for new triangle data
                        end else begin
                            y <= y + 1;
                        end
                    end else begin
                        x <= x + 1;
                    end
                end
            end
        end
    end
endmodule
