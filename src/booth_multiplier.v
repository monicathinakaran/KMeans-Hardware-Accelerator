`timescale 1ns / 1ps


module booth_multiplier (
    input clk,
    input rst,
    input start,                    // Pulse high to start multiplication
    input signed [15:0] A,          // Multiplicand
    input signed [15:0] B,          // Multiplier
    output reg signed [31:0] P,     // Product
    output reg done                 // High when calculation is finished
);

    reg [15:0] M, Q;
    reg Q_1;
    reg [4:0] count;
    reg [31:0] P_temp;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            P <= 0;
            done <= 0;
            count <= 0;
            P_temp <= 0;
            M <= 0;
            Q <= 0;
            Q_1 <= 0;
        end else begin
            if (start) begin
                M <= A;
                Q <= B;
                Q_1 <= 0;
                count <= 16;   // 16 iterations for 16-bit numbers
                P_temp <= 0;
                done <= 0;
            end else if (count > 0) begin
                case ({Q[0], Q_1})
                    2'b01: P_temp[31:16] = P_temp[31:16] + M; // Add M
                    2'b10: P_temp[31:16] = P_temp[31:16] - M; // Subtract M
                    default: ; // Do nothing (00 or 11)
                endcase
                
                // Arithmetic Right Shift
                Q_1 = Q[0];
                Q = {P_temp[0], Q[15:1]};
                P_temp = {P_temp[31], P_temp[31:1]}; // Sign extension
                
                count <= count - 1;
            end else begin
                if (!done) begin // Latch result once
                    P <= {P_temp[31:16], Q};
                    done <= 1;
                end
            end
        end
    end
endmodule