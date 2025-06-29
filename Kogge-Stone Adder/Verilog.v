module radix8_booth_multiplier ( 
input signed [15:0] multiplicand,  // 16-bit multiplicand 
input signed [15:0] multiplier,    // 16-bit multiplier 
output signed [31:0] product       // 32-bit product 
); 
reg signed [31:0] partial_products [0:5];  // 6 partial products for Radix-8 
reg signed [18:0] extended_multiplier;     // Extended multiplier for Radix-8 
integer i; 
always @(*) begin 
extended_multiplier = {multiplier, 3'b0}; // Extend multiplier by 3 bits 
// Generate partial products based on Radix-8 Booth encoding 
for (i = 0; i < 6; i = i + 1) begin 
case (extended_multiplier[3 * i +: 3])  // 3-bit group 
3'b000, 3'b111: partial_products[i] = 32'b0;  // No multiplication 
3'b001, 3'b010: partial_products[i] = multiplicand << ( i); // +M 
3'b011:  partial_products[i] = (multiplicand << (2 * i)) + (multiplicand << (2 
* i + 1)); // +2M 
3'b100:         partial_products[i] = -((multiplicand << (3 * i)) + (multiplicand 
<< (3 * i + 1))); // -2M 
3'b101, 3'b110: partial_products[i] = -(multiplicand << (3 * i));  // -M 
default:        partial_products[i] = 32'b0; // Default case 
endcase 
end 
end 
// Connect the partial products to the Kogge-Stone Adder 
kogge_stone_adder KSA ( 
.a(partial_products[0]), 
.b(partial_products[1]), 
.c(partial_products[2]), 
.d(partial_products[3]), 
.e(partial_products[4]), 
.f(partial_products[5]), 
.sum(product) 
); 
endmodule 
