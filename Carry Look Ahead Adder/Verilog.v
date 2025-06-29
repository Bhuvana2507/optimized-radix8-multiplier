module radix8_booth_multiplier_with_cla( 
input [15:0] multiplicand, 
input [15:0] multiplier, 
output [31:0] product 
); 
reg [31:0] partial_products [0:5]; 
reg [31:0] multiplicand_ext; 
reg [18:0] multiplier_ext; 
wire [31:0] sum1, sum2, sum3; 
wire carry_out1, carry_out2, carry_out3; 
integer i; 
initial begin 
for (i = 0; i < 6; i = i + 1) 
partial_products[i] = 0; 
end 
// Generate partial products 
always @(*) begin 
multiplicand_ext = { {16{multiplicand[15]}}, multiplicand }; // Sign extend 
multiplier_ext = { multiplier, 2'b0 }; // Extend multiplier 
for (i = 0; i < 6; i = i + 1) begin 
case (multiplier_ext[2 + (i * 3) -: 3]) 
3'b001, 3'b010: partial _products[i] = multiplicand_ext << (i * 2); 
3'b011:         partial_products[i] = (multiplicand_ext << (i * 2)); 
3'b100:         partial_products[i] = ~(multiplicand_ext << (i * 2)) + 1; 
3'b101, 3'b110: partial_products[i] = ~(multiplicand_ext << (i * 2)) + 1; 
default:        partial_products[i] = 0; 
endcase 
end 
end 
// Add partial products using CLA 
cla_32bit cla1 (partial_products[0], partial_products[1], 1'b0, sum1, carry_out1); 
cla_32bit cla2 (sum1, partial_products[2], 1'b0, sum2, carry_out2); 
cla_32bit cla3 (sum2, partial_products[3], 1'b0, sum3, carry_out3); 
cla_32bit cla4 (sum3, partial_products[4], 1'b0, product, ); 
endmodule 
// 32-bit Carry Lookahead Adder (CLA) 
module cla_32bit( 
input [31:0] a, 
input [31:0] b, 
input cin, 
output [31:0] sum, 
output cout 
); 
wire [31:0] p, g; // Propagate and generate 
wire [31:0] c;    // Carry 
assign p = a ^ b;  // Propagate 
assign g = a & b;  // Generate 
assign c[0] = cin; 
assign c[1] = g[0] | (p[0] & c[0]); 
genvar i; 
generate 
for (i = 2; i < 32; i = i + 1) begin 
assign c[i] = g[i-1] | (p[i-1] & c[i-1]); 
end 
endgenerate 
assign cout = g[31] | (p[31] & c[31]); 
assign sum = p ^ c; 
endmodule
