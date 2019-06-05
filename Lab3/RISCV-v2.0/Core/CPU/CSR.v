`ifndef PARAM
    `include "../Parametros.v"
`endif

module CSRRegisters(
   input wire iCLK, iRST, iREGWrite,
	input wire  [6:0] 	iNumReg,
	input wire  [31:0] 	iWriteData, iPC,
	input wire  [31:0]   iUcause,
	output  reg [31:0]  oUTVEC,
	output  reg [31:0]  oCSRInstOut
);

reg [69:0] registers;


reg [6:0] i;

initial 
  begin
	for (i = 0; i<= 69;i= i + 1'b1) 
			registers[i] = 32'b0;
  end
 
 
 assign oCSRInstOut = registers[iNumReg];
 assign oUTVEC   = registers[7'b000101]; // manda o reg(5) utvec como saida 
 
always @(posedge iCLK or posedge iRST)
begin
	if(iRST)
	 begin
	   for (i = 0; i<= 69;i= i + 1'b1) // reseta o banco de registradores
			registers[i] = 32'b0;
	 end
    else
    begin
       if(iREGWrite)
		 begin 
		      registers[iNumReg] <= iWriteData;
				registers[7'b1000010] <= iUcause; // grava a causa da exercao no reg(66) ucause
			   registers[7'b1000001] <= iPC;    // grava PC no reg(65) uepc	
		 end		
	 end	 
end  
endmodule  