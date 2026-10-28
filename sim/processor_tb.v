
`timescale 1ns / 1ps

module processor_tb;

    reg clk;
    reg rst;
    wire [31:0] result;

    // Instantiate the processor
    top uut (
        .clk(clk),
        .rst(rst),
        .result(result)
    );

    // 100 MHz clock: 10 ns period
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 1'b0;
        rst = 1'b1;

        $dumpfile("processor_tb.vcd");
        $dumpvars(0, processor_tb);

        $display("========================================");
        $display(" RISC-V Processor Testbench");
        $display("========================================");

        // Apply reset
        #20;
        rst = 1'b0;

        // Observe processor execution
        repeat (20) begin
            @(posedge clk);
            #1;
            $display(
                "Time=%0t | PC=%h | Instruction=%h | ALU Result=%h",
                $time,
                uut.PC_top,
                uut.instruction_top,
                result
            );
        end

        $display("========================================");
        $display(" Simulation completed");
        $display("========================================");

        $finish;
    end

endmodule
