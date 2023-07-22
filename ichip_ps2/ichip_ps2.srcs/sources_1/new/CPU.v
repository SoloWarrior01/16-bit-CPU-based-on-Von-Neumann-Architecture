`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2023 23:07:45
// Design Name: 
// Module Name: CPU
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


module CPU(
    input wire clk, reset,
    input wire [15:0]memory_in,
    output reg [9:0]memory_address, reg [15:0] memory_out,
    output reg read_write, reg return,
    output reg [9:0]PC, reg [15:0]IR, reg [15:0]AC
    );
    
    reg [15:0] x, y; 
    reg zx, nx, zy, ny, f, no;
    wire [15:0] o; 
    wire zr, ng;
    ALU Calculator(.x(x), .y(y), .zx(zx), .nx(nx), .zy(zy), .ny(ny), .f(f), .no(no), .o(o), .zr(zr), .ng(ng));
    
    reg [1:0]state;
    reg mode; 
    reg [4:0] opcode;
    reg [9:0] address;
    reg enable_out;
    
    always @ (posedge clk or negedge clk) begin
        if(clk == 1'b1 && state == 2'b00 && return == 1'b1) begin
                read_write = 1'b0;
                memory_address = PC;
                state = 2'b01;
            end
        else if(clk == 1'b1 && state == 2'b01) begin
                IR = memory_in;
                mode = memory_in[15]; opcode = memory_in[14:10]; address = memory_in[9:0];
                read_write = 1'b0;
                memory_address = memory_in[9:0];
                state = 2'b10;
            end
        else if(clk == 1'b1 && state == 2'b10) begin
                 if(mode == 1'b1) begin
                    address = memory_in[9:0];
                    read_write = 1'b0;
                    memory_address = memory_in[9:0];
                 end
                 state = 2'b11;
            end
        else if(clk == 1'b1 && state == 2'b11) begin
                case(opcode)
                    5'd00 : begin x=AC; y=memory_in; zx=1; nx=0; zy=1; ny=0; f=1; no=0; end
                    5'd01 : begin x=AC; y=memory_in; zx=1; nx=1; zy=1; ny=1; f=1; no=1; end
                    5'd02 : begin x=AC; y=memory_in; zx=1; nx=1; zy=1; ny=0; f=1; no=0; end
                    5'd03 : begin x=AC; y=memory_in; zx=0; nx=0; zy=1; ny=1; f=0; no=0; end
                    5'd04 : begin x=AC; y=memory_in; zx=1; nx=1; zy=0; ny=0; f=0; no=0; end
                    5'd05 : begin x=AC; y=memory_in; zx=0; nx=0; zy=1; ny=1; f=0; no=1; end
                    5'd06 : begin x=AC; y=memory_in; zx=1; nx=1; zy=0; ny=0; f=0; no=1; end
                    5'd07 : begin x=AC; y=memory_in; zx=0; nx=0; zy=1; ny=1; f=1; no=1; end
                    5'd08 : begin x=AC; y=memory_in; zx=1; nx=1; zy=0; ny=0; f=1; no=1; end
                    5'd09 : begin x=AC; y=memory_in; zx=0; nx=1; zy=1; ny=1; f=1; no=1; end
                    5'd10 : begin x=AC; y=memory_in; zx=1; nx=1; zy=0; ny=1; f=1; no=1; end
                    5'd11 : begin x=AC; y=memory_in; zx=0; nx=0; zy=1; ny=1; f=1; no=0; end
                    5'd12 : begin x=AC; y=memory_in; zx=1; nx=1; zy=0; ny=0; f=1; no=0; end
                    5'd13 : begin x=AC; y=memory_in; zx=0; nx=0; zy=0; ny=0; f=1; no=0; end
                    5'd14 : begin x=AC; y=memory_in; zx=0; nx=1; zy=0; ny=0; f=1; no=1; end
                    5'd15 : begin x=AC; y=memory_in; zx=0; nx=0; zy=0; ny=1; f=1; no=1; end
                    5'd16 : begin x=AC; y=memory_in; zx=0; nx=0; zy=0; ny=0; f=0; no=0; end
                    5'd17 : begin x=AC; y=memory_in; zx=0; nx=1; zy=0; ny=1; f=0; no=1; end
                    5'd18 : begin x=AC; y=memory_in; zx=1; nx=1; zy=0; ny=0; f=0; no=0; end
                    5'd19 : begin x=AC; y=memory_in; zx=0; nx=0; zy=1; ny=1; f=0; no=0; read_write=1'b1; memory_out=AC; end
                    5'd20 : begin x=AC; y=memory_in; zx=0; nx=0; zy=1; ny=1; f=0; no=0; PC=address-10'd1; end
                    5'd21 : begin x=AC; y=memory_in; zx=0; nx=0; zy=1; ny=1; f=0; no=0; if(AC==16'b0) PC=address-10'd1; end
                    5'd22 : begin x=AC; y=memory_in; zx=0; nx=0; zy=1; ny=1; f=0; no=0; if(AC[15]==1'b1) PC=address-10'd1; end
                    5'd23 : begin return=1'b0; end
                endcase
                state = 2'b0; enable_out = 1'b1;
            end
        else if(clk==1'b0 && enable_out==1'b1) begin
                AC = o;
                PC = PC + 10'd1;
                enable_out = 1'b0;
            end
        end
            
        always @(posedge reset) begin
            PC = 10'd0; 
            IR = 16'b0; 
            AC = 16'b0;
            return = 1'b1; 
            state = 2'b00;
            enable_out = 1'b0;
        end
endmodule
