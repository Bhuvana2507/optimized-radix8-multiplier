module tb_radix8_booth_multiplier_with_cla(); 
reg [15:0] multiplicand, multiplier; 
wire [31:0] product; 
radix8_booth_multiplier_with_cla uut ( 
.multiplicand(multiplicand), 
.multiplier(multiplier), 
.product(product) 
); 
initial begin 
$display("Time(ns)\tMultiplicand\tMultiplier\tProduct"); 
$display("-------------------------------------------------"); 
// Test Case 1 
multiplicand = 16'd3; multiplier = 16'd2; #10; 
$display("%0dns\t%0d\t\t%0d\t\t%0d", $time, multiplicand, multiplier, 
product); 
// Test Case 2 
multiplicand = 16'd4660; multiplier = 16'd0; #10; 
$display("%0dns\t%0d\t\t%0d\t\t%0d", $time, multiplicand, multiplier, 
product) 
$stop; 
end 
endmodule
