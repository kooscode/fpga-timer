/*
Common Cathode 7Segment Display Counter for a single digit.

Copyright © 2020 <Koos du Preez - kdupreez@hotmail.com>

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org>
*/

module seg7_counter(
		// Clock in, increments on every cycle
		input clk_in,
		// 7 Segment pins
		output reg [6:0] seg7_out,
		// Out carry bit used for clk on next segment
		output reg carry_bit
    );

// 4Bit Max counter value.. 
// Examples:
//	9 = Decimal counter
//	6 = Most Signigicant digit for hours or minutes = 
//  15 = Hex counter
parameter MAX_BCD = 4'd9;
reg	[4:0] bcd_cnt = 0;

initial carry_bit = 0;

always @(posedge clk_in)
begin	

	// BCD to 7 Segment Decoder
	// Segment decoder key is inverted because of common cathode design..
	case(bcd_cnt)
		4'd0:seg7_out <= 7'b100_0000;
		4'd1:seg7_out <= 7'b111_1001;
		4'd2:seg7_out <= 7'b010_0100;
		4'd3:seg7_out <= 7'b011_0000;
		4'd4:seg7_out <= 7'b001_1001;
		4'd5:seg7_out <= 7'b001_0010;
		4'd6:seg7_out <= 7'b000_0010;
		4'd7:seg7_out <= 7'b111_1000;
		4'd8:seg7_out <= 7'b000_0000;
		4'd9:seg7_out <= 7'b001_0000;
		4'ha:seg7_out <= 7'b000_1000;
		4'hb:seg7_out <= 7'b000_0011;
		4'hc:seg7_out <= 7'b100_0110;
		4'hd:seg7_out <= 7'b010_0001;
		4'he:seg7_out <= 7'b000_0110;
		4'hf:seg7_out <= 7'b000_1110;
		default:seg7_out <= 7'b111_1111;
	endcase

	// Counter keeps track of digit, resets at Max
	if (bcd_cnt == MAX_BCD)
	begin
		carry_bit <= 1;
		bcd_cnt <= 0;
	end		
	else
	begin
		carry_bit <= 0;
		bcd_cnt <= bcd_cnt + 1;
	end		
	
end

endmodule
