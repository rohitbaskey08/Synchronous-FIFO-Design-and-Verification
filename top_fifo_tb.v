`timescale 1ns/1ps

module top_fifo_tb;

    // Testbench signals
    logic clk;
    logic rst;
    logic [7:0] data_top;

    logic [7:0] data_out_top;

    //Instantiation
    top_fifo uut (
        .clk(clk),
        .rst(rst),
        .data_top(data_top),
        .data_out_top(data_out_top)
    );

    // Clock Generation
    always #5 clk = ~clk;

    // Task to apply data
    task send_data(input logic [7:0] din);
    begin
        @(posedge clk);
        data_top = din;

        $display("Time = %0t | Data Written = %h",
                 $time, din);
    end
    endtask

    // Test Sequence
    initial begin

        // Initialization
        clk = 0;
        rst = 1;
        data_top = 8'h00;

        // Apply Reset
        #20;
        rst = 0;

        $display("Time = %0t | Reset Released",
                  $time);

        // Send test data
        send_data(8'h11);   
        send_data(8'h22);   
        send_data(8'h33);   
        send_data(8'h44);   

        // Wait for FIFO operations
        #100;

        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor(
            "Time=%0t | rst=%b | data_in=%h | data_out=%h",
            $time,
            rst,
            data_top,
            data_out_top
        );
    end

endmodule