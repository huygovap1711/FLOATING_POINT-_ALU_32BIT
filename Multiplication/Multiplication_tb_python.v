///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//File Name: Multiplication_tb_python.v
//Created By: Sheetal Swaroop Burada
//Date: 30-04-2019
//Project Name: Design of 32 Bit Floating Point ALU Based on Standard IEEE-754 in Verilog and its implementation on FPGA.
//University: Dayalbagh Educational Institute
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`define N_TESTS 100000

module multiplication_tb;

	reg clk = 0;
	reg [31:0] a_operand;
	reg [31:0] b_operand;
	
	wire Exception,Overflow,Underflow;
	wire [31:0] result;

	reg [31:0] Expected_result;

	reg [95:0] testVector [`N_TESTS-1:0];

	reg test_stop_enable;

	integer mcd;
	integer test_n = 0;
	integer pass   = 0;
	integer error  = 0;

	Multiplication DUT(a_operand,b_operand,Exception,Overflow,Underflow,result);

	always #5 clk = ~clk;

	initial  
	begin 
		$readmemh("TestVectorMultiply", testVector);
		mcd = $fopen("Results_Ver2.txt");
	end 

	always @(posedge clk) 
	begin
			{a_operand,b_operand,Expected_result} = testVector[test_n];
			test_n = test_n + 1'b1;

			#2;
			if (result == Expected_result)
				begin
					$fdisplay (mcd,"TestPassed Test Number -> %d",test_n);
					pass = pass + 1'b1;
				end

			if (result != Expected_result)
				begin
					$fdisplay (mcd,"Test Failed Expected Result = %h, Obtained result = %h, Test Number -> %d",Expected_result,result,test_n);
					error = error + 1'b1;
				end
			
			if (test_n >= `N_TESTS) 
			begin
				$fdisplay(mcd,"Completed %d tests, %d passes and %d fails.", test_n, pass, error);
				test_stop_enable = 1'b1;
			end
	end

always @(posedge test_stop_enable)
begin
$fclose(mcd);
$finish;
end

endmodule
