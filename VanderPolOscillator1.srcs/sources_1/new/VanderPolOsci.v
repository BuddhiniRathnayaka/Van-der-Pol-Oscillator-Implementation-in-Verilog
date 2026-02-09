`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2026 04:29:23 PM
// Design Name: 
// Module Name: VanderPolOsci
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module VanDerPol (
    input  wire clk,
    input  wire reset,
    output reg  signed [31:0] y_out
);

    // Fixed-point parameters
    localparam signed [31:0] ONE = 32'sd65536;   // 1.0
    localparam signed [31:0] MU  = 32'sd65536;   // ? = 1.0
    localparam signed [31:0] DT  = 32'sd655;     // dt = 0.01

    // State variables (Q16.16)
    reg signed [31:0] y, u;
    reg signed [31:0] t;
    localparam integer T_MAX = 2000; // 2000 * 0.01 = 20 s

    // Intermediate registers (must be initialized)
    reg signed [63:0] y2;
    reg signed [63:0] term;
    reg signed [63:0] du;

    // FSM states
    reg [1:0] state;
    localparam S1 = 2'd0,
               S2 = 2'd1,
               S3 = 2'd2,
               DONE = 2'd3;

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initial conditions
            y <= ONE;      
            u <= 32'sd0;     
            t <= 32'sd0;

            // Initialize intermediates
            y2   <= 64'sd0;
            term <= 64'sd0;
            du   <= 64'sd0;

            state <= S1;
        end else begin
            case (state)


                S1: begin
                    y2 <= y * y;          
                    state <= S2;
                end


                S2: begin
                    term <= ((ONE - (y2 >>> 16)) * u) >>> 16;
                    du   <= (term - y) * DT;   
                    state <= S3;
                end


                S3: begin
                    u <= u + (du >>> 16);
                    y <= y + ((u * DT) >>> 16);
                    t <= t + 1;

                    if (t < T_MAX)
                        state <= S1;
                    else
                        state <= DONE;
                end


                DONE: begin
                    y_out <= y;
                end

            endcase
        end
    end

endmodule

