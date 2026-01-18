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



module min_finder (
    input [31:0] d1, d2, d3, // Distances from Centroid 1, 2, and 3
    output reg [1:0] cluster_id // 00=C1, 01=C2, 10=C3
);

    always @(*) begin
        if (d1 <= d2 && d1 <= d3)
            cluster_id = 2'b00;
        else if (d2 <= d1 && d2 <= d3)
            cluster_id = 2'b01;
        else
            cluster_id = 2'b10;
    end
endmodule

