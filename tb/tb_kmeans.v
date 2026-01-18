`timescale 1ns / 1ps

module tb_kmeans;

    reg clk;
    reg rst;
    reg [15:0] tb_x, tb_y;
    reg tb_valid;
    wire [1:0] tb_cluster;
    wire tb_out_valid;

    // Instantiate the Unit Under Test (UUT)
    kmeans_top uut (
        .clk(clk),
        .rst(rst),
        .data_x(tb_x),
        .data_y(tb_y),
        .data_valid(tb_valid),
        .cluster_result(tb_cluster),
        .output_valid(tb_out_valid)
    );

    // Clock Generation
    always #5 clk = ~clk; // 10ns clock period

    initial begin
        // Initialize
        clk = 0; rst = 1; tb_valid = 0;
        
        // Setup GTKWave dumping
        $dumpfile("kmeans.vcd");
        $dumpvars(0, tb_kmeans);

        #20 rst = 0; // Release reset

        // Test Case 1: Point (2.1, 2.1) -> Close to C1 (2.0, 2.0)
        // 2.1 in Q8.8 is approx 0x0219
        #10 tb_x = 16'h0219; tb_y = 16'h0219; tb_valid = 1;
        #10; // Wait one clock cycle

        // Test Case 2: Point (6.5, 6.0) -> Close to C2 (6.0, 6.0)
        // 6.5 in Q8.8 is 0x0680
        #10 tb_x = 16'h0680; tb_y = 16'h0600; tb_valid = 1;
        #10;

        // Test Case 3: Point (1.0, 8.0) -> Close to C3 (1.5, 8.0)
        // 1.0 = 0x0100, 8.0 = 0x0800
        #10 tb_x = 16'h0100; tb_y = 16'h0800; tb_valid = 1;
        #10;

        tb_valid = 0;
        #50 $finish;
    end
    
    // Monitor results in console
    always @(posedge clk) begin
        if (tb_out_valid)
            $display("Time: %t | Result Cluster: %d", $time, tb_cluster);
    end

endmodule