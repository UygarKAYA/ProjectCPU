# _ProjectCPU_

***16-bit Instruction Word (IW) of ProjectCPU:***

![ıset](https://user-images.githubusercontent.com/73105132/120937578-e7607b80-c716-11eb-9240-653243b29168.png)

***(Every memory location and W are 16 bits)***

***Instruction Set of ProjectCPU:***

*ADD   -> unsigned Add* <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*opcode = 0* <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;_W = W + (*A)_ <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*write(readFromAddress(A) +W) to W* <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;_*A = value (content of) address A = mem[A] (mem means memory)_ <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*= means write (assign)* <br/>

*NAND  -> bitwise NAND* <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; *opcode = 1* <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; _W = ~(W & (*A))_ <br/>

*SRRL  -> Shift Rotate Right or Left* <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; *opcode = 2* <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; _if((*A) is less than 16) W = W >> (*A)_ <br/>
		 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; _else if((*A) is between 16 and 31) W = W << lower4bits(*A)_ <br/>
		 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; W = RotateRight W by lower4bits(*A)_ <br/>
		 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; _else W = RotateLeft W by lower4bits(*A)_ <br/>

_GE   -> Unsigned Greater Equal_ <br/>
        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*opcode = 3* <br/>
        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;_W = W >= (*A)_ <br/>

*SZ    -> Skip on Zero* <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; *opcode = 4* <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; _PC = ((*A) == 0) ? (PC+2) : (PC+1)_ <br/>
		 
*CP2W  -> Copy to W* <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; *opcode = 5* <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; _W = *A_ <br/>

*CPfW  -> Copy from W* <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*opcode = 6* <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;_*A = W_ <br/>

*JMP   -> Jump* <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; *opcode = 7* <br/>
         &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; _PC = lower13bits(*A)_ <br/>
		 
***INDIRECT ADRESSING***

*There are no special instructions for indirect addressing* <br/>
*Instead, every instruction can operate in indirect addressing mode*

_That is, if A==0, replace *A above with **2_

***Every program starts like this:***

*0: JMP 1* <br/>
*1: 3* <br/>
*2: // indirection register* <br/>
*3: // program actually starts here* <br/>
