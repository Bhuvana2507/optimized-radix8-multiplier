module radix8_booth_multiplier ( 
input signed [15:0] multiplicand, // 16-bit multiplicand 
input signed [15:0] multiplier,   // 16-bit multiplier 
output signed [31:0] product       // 32-bit product 
); 
reg signed [31:0] partial_products [0:5];  // Partial products 
reg signed [31:0] sum; // For accumulating the final product 
reg signed [18:0] extended_multiplier; // Extended multiplier for Radix-8 
integer i; 
// Extend multiplier for Radix-8 operation 
always @(*) begin 
extended_multiplier = {multiplier, 3'b0}; // Append 3 zeros to multiplier 
sum = 32'b0; 
// Generate partial products based on Radix-8 Booth encoding 
for (i = 0; i < 6; i = i + 1) begin 
case (extended_multiplier[3 * i +: 3])  // 3-bit group 
3'b000, 3'b111: partial_products[i] = 32'b0; // No operation 
3'b001, 3'b010: partial_products[i] = multiplicand << (i); // +M 
3'b011:         partial_products[i] = (multiplicand << (3 * i)) + (multiplicand 
<< (3 * i + 1)); // +2M 
3'b100:         partial_products[i] = -((multiplicand << (3 * i)) + (multiplicand 
<< (3 * i + 1))); // -2M 
3'b101, 3'b110: partial_products[i] = -(multiplicand << (i)); // -M 
default:        partial_products[i] = 32'b0; // Safety case 
endcase 
end 
// Accumulate partial products directly 
for (i = 0; i < 6; i = i + 1) begin 
sum = sum + partial_products[i]; // Directly sum the partial products 
end 
end 
// Compute final product 
assign product = sum; 
endmodule
