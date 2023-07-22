`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2023 18:41:02
// Design Name: 
// Module Name: CPU_tb
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


module CPU_tb();
    reg clk, reset;
    reg [15:0]memory_in;
    wire read_write; wire return;
    wire [9:0]memory_address; wire [15:0]memory_out; wire [9:0]PC; wire [15:0] IR; wire [15:0] AC;
    
    CPU cpu(.clk(clk), .reset(reset), .memory_in(memory_in), .read_write(read_write), .memory_address(memory_address), .memory_out(memory_out), .PC(PC), .IR(IR), .AC(AC), .return(return));

    reg [15:0] memory[0:1023];
    
    always @(posedge clk or negedge clk) begin
        if(read_write == 1'b0 && clk == 1'b0) memory_in = memory[memory_address];
        else if(read_write == 1'b1 && clk == 1'b1) memory[memory_address] = memory_out;
    end
    
    always begin #0.5; clk = ~clk; end
    
    initial begin
    clk = 1'b0;
    $readmemh("D:\\Verilog\\ichip_ps2\\Program.txt", memory, 0, 400);
    $readmemh("D:\\Verilog\\ichip_ps2\\Data.txt", memory, 401, 1023);
    reset = 1'b0; reset = 1'b1;
    end
    
    integer count = 0;
    always @(posedge clk) begin
        count = count + 1;
        if(return==1'b0) begin
            $display("count=%d", count);
            $writememh("D:\\Verilog\\ichip_ps2\\Output.txt", memory, 401, 1023);
            $finish;
        end
    end

endmodule
