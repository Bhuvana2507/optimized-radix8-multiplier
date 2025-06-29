`timescale 1ns / 1ps 
module tb_radix8_booth_multiplier; 
// Inputs 
reg signed [15:0] multiplicand; 
reg signed [15:0] multiplier; 
// Outputs 
wire signed [31:0] product; 
// Instantiate the Radix-8 Booth Multiplier 
radix8_booth_multiplier uut ( 
.multiplicand(multiplicand), 
.multiplier(multiplier), 
.product(product) 
); 
initial begin 
$display("Time\tMultiplicand\tMultiplier\tProduct"); 
// Test Case 1 
multiplicand = 16'd3; multiplier = 16'd2; #10; 
$display("%0dns\t%0d\t\t%0d\t\t%0d", $time, multiplicand, multiplier, product); 
// Test Case 5 
multiplicand = 16'd4660; multiplier = 16'd0; #10; 
$display("%0dns\t%0d\t\t%0d\t\t%0d", $time, multiplicand, multiplier, product); 
$stop; 
end 
endmodule 
