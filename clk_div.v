/*
Basic verilog clock Divider

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

module clock_div
	 #(	//External clock frequency
			parameter CLK_IN_HZ = 50000000, 
			// 100us = 10hz clock
			parameter CLK_OUT_HZ = 10) 
		
		(	input clk_in,
			output reg clk_out);

// divider
parameter clk_div = CLK_IN_HZ / CLK_OUT_HZ - 1;

reg [31:0] clk_counter;
initial clk_counter = 0;

// process clock division..
always @(posedge clk_in)
begin

	if (clk_counter == clk_div)
	begin
		clk_out <= ~clk_out;
		clk_counter <= 32'b0;
	end
	else
	begin
		clk_counter <= clk_counter + 1;
	end
	
end

endmodule
