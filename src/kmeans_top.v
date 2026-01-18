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



module kmeans_top (
    input clk,
    input rst,
    input [15:0] data_x, data_y,    // Stream of data points
    input data_valid,               // High when input data is valid
    output reg [1:0] cluster_result,// Which cluster does the point belong to?
    output reg output_valid
);

    // --- Internal Signals ---
    // Centroid positions (Hardcoded for demo, normally stored in registers)
    // Using Q8.8 format: 
    // C1 at (2.0, 2.0) -> 0x0200
    // C2 at (6.0, 6.0) -> 0x0600
    // C3 at (1.5, 8.0) -> X=0x0180, Y=0x0800
    
    reg [15:0] c1_x = 16'h0200; reg [15:0] c1_y = 16'h0200;
    reg [15:0] c2_x = 16'h0600; reg [15:0] c2_y = 16'h0600;
    reg [15:0] c3_x = 16'h0180; reg [15:0] c3_y = 16'h0800;

    wire [31:0] dist1, dist2, dist3;
    wire [1:0] closest_id;

    // --- Instantiate Distance Units (PARALLEL HARDWARE!) ---
    // This is where we beat the CPU. We calculate all 3 at once.
    distance_unit u1 (.x_point(data_x), .y_point(data_y), .x_centroid(c1_x), .y_centroid(c1_y), .distance_sq(dist1));
    distance_unit u2 (.x_point(data_x), .y_point(data_y), .x_centroid(c2_x), .y_centroid(c2_y), .distance_sq(dist2));
    distance_unit u3 (.x_point(data_x), .y_point(data_y), .x_centroid(c3_x), .y_centroid(c3_y), .distance_sq(dist3));

    // --- Instantiate Minimum Finder ---
    min_finder u_min (.d1(dist1), .d2(dist2), .d3(dist3), .cluster_id(closest_id));

    // --- Output Logic ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cluster_result <= 0;
            output_valid <= 0;
        end else begin
            if (data_valid) begin
                cluster_result <= closest_id;
                output_valid <= 1; // Result is ready on the next cycle
            end else begin
                output_valid <= 0;
            end
        end
    end

endmodule

