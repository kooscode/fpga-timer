/*
6 Digit 7Segment Display Timer.

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

module top(
			input clk,
			output reg [5:0] seg_sel,
			output reg [7:0] seg_data
			);

initial
begin
	seg_data = 8'hff;
	seg_sel = 6'b11_1111;
end

// 6 Digit refresh rate
// Clock divider 50mHz => 400kHz
wire clk_scan;
clock_div	#(.CLK_IN_HZ(50000000), .CLK_OUT_HZ(400000))
				clk_div_scan(.clk_in(clk), .clk_out(clk_scan));

// Least significant digit clock, every following digit
// will use the previous digit's carry bit as a clock
// clock divider 50mHz => 200kHz
wire seg_clk0;
clock_div	#(.CLK_IN_HZ(50000000), .CLK_OUT_HZ(200000))
				clk_div_200k(.clk_in(clk), .clk_out(seg_clk0));

// digit 0, runs at 10uS (triggers on positive edge of 200khz)
wire seg_clk1;
wire [6:0] digit0;
seg7_counter cnt0 (.clk_in(seg_clk0), .seg7_out(digit0), .carry_bit(seg_clk1));

// digit 1, runs at 100us (triggers on negative edge of previous digit carry)
wire seg_clk2;
wire [6:0] digit1;
seg7_counter cnt1 (.clk_in(~seg_clk1), .seg7_out(digit1), .carry_bit(seg_clk2));

// digit 2, runs at 1ms (triggers on negativeedge of previous digit carry)
wire seg_clk3;
wire [6:0] digit2;
seg7_counter cnt2 (.clk_in(~seg_clk2), .seg7_out(digit2), .carry_bit(seg_clk3));

// digit 3, runs at 10ms (triggers on negative edge of previous digit carry)
wire seg_clk4;
wire [6:0] digit3;
seg7_counter cnt3 (.clk_in(~seg_clk3), .seg7_out(digit3), .carry_bit(seg_clk4));

// digit 4, runs at 100ms (triggers on negative edge of previous digit carry)
wire seg_clk5;
wire [6:0] digit4;
seg7_counter cnt4 (.clk_in(~seg_clk4), .seg7_out(digit4), .carry_bit(seg_clk5));

// digit 5, runs at 1s (triggers on negative edge of previous digit carry)
wire seg_clk_nc;
wire [6:0] digit5;
seg7_counter cnt5 (.clk_in(~seg_clk5), .seg7_out(digit5), .carry_bit(seg_clk_nc));

// refresh 6 dgits of 7 segment Display on each clock cycle
// note1 - address is inverted because of common cathode design.
// note2 - technically its an 8 segment due to decimal point..
reg [3:0] seg_idx ;
always @(posedge clk_scan)
begin

	case(seg_idx)
		4'd0: 
		begin
			// Digit 1 address
			seg_sel <= 6'b11_1110;
			// Data
			seg_data[6:0] <= digit5;
			// Decimal point !enable
			seg_data[7] <= 0;
		end
		4'd1:
		begin
			// Digit 2 address
			seg_sel <= 6'b11_1101;
			// Data
			seg_data[6:0] <= digit4;
			// Decimal point !enable
			seg_data[7] <= 1;
		end
		4'd2:
		begin
			// Digit 3 address
			seg_sel <= 6'b11_1011;
			// Data
			seg_data[6:0] <= digit3;
			// Decimal point !enable
			seg_data[7] <= 1;
		end
		4'd3:
		begin
			// Digit 4 address
			seg_sel <= 6'b11_0111;
			// Data
			seg_data[6:0] <= digit2;
			// Decimal point !enable
			seg_data[7] <= 1;
		end
		4'd4:
		begin
			// Digit 5 address
			seg_sel <= 6'b10_1111;
			// Data
			seg_data[6:0] <= digit1;
			// Decimal point !enable
			seg_data[7] <= 1;
		end
		4'd5:
		begin
			// Digit 6 address
			seg_sel <= 6'b01_1111;
			// Data
			seg_data[6:0] <= digit0;
			// Decimal point !enable
			seg_data[7] <= 1;
		end
		default:
		begin
			//Blank - none selected/enabled
			seg_sel <= 6'b11_1111;
			seg_data <= 8'hff;
		end
	endcase
	
	// move to next digit
	if (seg_idx == 4'd5)
		seg_idx <= 0;
	else
		seg_idx <= seg_idx + 1;
		
end

endmodule
