module radix8_booth_multiplier ( 
input signed [15:0] multiplicand,  // 16-bit multiplicand 
input signed [15:0] multiplier,    // 16-bit multiplier 
output signed [31:0] product       // 32-bit product 
); 
reg signed [31:0] partial_products [0:5];  // Partial products 
reg signed [31:0] partial_sum, partial_carry; // For CSA 
reg signed [18:0] extended _multiplier; // Extended multiplier for Radix-8 
integer i; 
// Extend multiplier for Radix-8 operation 
always @(*) begin 
extended _multiplier = {multiplier, 3'b0}; // Append 3 zeros to multiplier 
partial _sum = 32'b0; 
partial_carry = 32'b0; 
// Generate partial products based on Radix-8 Booth encoding 
for (i = 0; i < 6; I = i + 1) begin 
case (extended _multiplier[3 * i +: 3])  // 3-bit group 
3'b000, 3'b111: partial _products[i] = 32'b0; // No operation 
3'b001, 3'b010: partial_products[i] = multiplicand << (i); // +M 
3'b011:         partial_products[i] = (multiplicand << (3 * i)) + (multiplicand << 
(3 * i + 1)); // +2M 
3'b100:         partial_products[i] = -((multiplicand << (3 * i)) + (multiplicand << 
(3 * i + 1))); // -2M 
3'b101, 3'b110: partial_products[i] = -(multiplicand << (3 * i)); // -M 
default:        partial_products[i] = 32'b0; // Safety case 
endcase 
end 
// Accumulate partial products using CSA 
for (i = 0; i < 6; i = i + 1) begin 
{partial_carry, partial_sum} = carry_save_adder(partial_sum, partial_products[i], 
partial_carry); 
end 
end 
// Compute final product 
assign product = partial_sum + partial_carry; 
// Carry Save Adder (CSA)  
function [63:0] carry_save_adder( 
input signed [31:0] a, 
input signed [31:0] b, 
input signed [31:0] c 
); 
reg signed [31:0] sum, carry; 
begin 
sum = a ^ b ^ c;   
                     //
 Sum 
carry = (a & b) | (b & c) | (c & a);   // Carry 
carry_save_adder = {carry << 1, sum}; // Return carry (shifted) and sum 
end 
endfunction 
endmodule 
