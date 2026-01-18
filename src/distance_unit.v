`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.01.2026 15:05:37
// Design Name: 
// Module Name: distance_unit
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


module distance_unit (
    input signed [15:0] x_point, y_point,      // Data Point
    input signed [15:0] x_centroid, y_centroid,// Centroid
    output [31:0] distance_sq                  // Squared Distance (32-bit to avoid overflow)
);

    wire signed [15:0] diff_x, diff_y;
    wire signed [31:0] sq_x, sq_y;

    // 1. Subtraction
    assign diff_x = x_point - x_centroid;
    assign diff_y = y_point - y_centroid;

    // 2. Multiplication (Squaring)
    // In a real ASIC, you might use a Booth Multiplier instance here.
    // For synthesis tools, the '*' operator usually infers a DSP block efficiently.
    assign sq_x = diff_x * diff_x;
    assign sq_y = diff_y * diff_y;

    // 3. Addition
    assign distance_sq = sq_x + sq_y;

endmodule
