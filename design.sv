//Gates library with delay
module INV(O,I1);
  input I1;
  output O;
  not #1 (O,I1);
endmodule


module NAND(O,I1,I2);
  input I1,I2;
  output O;
  nand #5 (O,I1,I2);
endmodule

module NOR(O,I1,I2);
  input I1,I2;
  output O;
  nor #5 (O,I1,I2);
endmodule

module AND(O,I1,I2);  //AND GATE MODULE FOR 2 INPUTS
  input I1,I2;
  output O;
  and #6 (O,I1,I2);
endmodule

module AND3(O,I1,I2,I3);  //AND GATE MODULE FOR 3 INPUTS
  input I1,I2,I3;
  output O;
  and #6 (O,I1,I2,I3);
endmodule

module AND4(O,I1,I2,I3,I4);  //AND GATE MODULE FOR 4 INPUTS
  input I1,I2,I3,I4;
  output O;
  and #6 (O,I1,I2,I3,I4);
endmodule

module AND5(O,I1,I2,I3,I4,I5);  //AND GATE MODULE FOR 5 INPUTS
  input I1,I2,I3,I4,I5;
  output O;
  and #6 (O,I1,I2,I3,I4,I5);
endmodule

module AND6(O,I1,I2,I3,I4,I5,I6);  //AND GATE MODULE FOR 6 INPUTS
  input I1,I2,I3,I4,I5,I6;
  output O;
  and #6 (O,I1,I2,I3,I4,I5,I6);
endmodule

module OR(O,I1,I2);  //OR GATE MODULE FOR 2 INPUTS
  input I1,I2;
  output O;
  or #6 (O,I1,I2);
endmodule

module OR6(O,I1,I2,I3,I4,I5,I6);  //OR GATE MODULE FOR 6 INPUTS
  input I1,I2,I3,I4,I5,I6;
  output O;
  or #6 (O,I1,I2,I3,I4,I5,I6);
endmodule

module XNOR(O,I1,I2);
  input I1,I2;
  output O;
  xnor #8 (O,I1,I2);
endmodule

/*
module XOR(O,I1,I2);
  input I1,I2;
  output O;
  xor #9 (O,I1,I2);
endmodule
*/

module mux21(O,I1,I2,SEL);  //2-1 Multiplexer using the gates from the library
  input I1,I2,SEL;
  output O;
  wire w0,w1,w2;
  //IF S=0 -> O=I1
  //IF S=1 -> O=I2
  //O= I1&(~SEL) + I2&(SEL)
  INV not8(w0,SEL); //Now w0=~SEL
  AND and2_9(w1,w0,I1); //Now w1= I1&(~SEL)
  AND and2_10(w2,I2,SEL); // w2=I2&(SEL)
  OR or2_1(O,w1,w2);
endmodule

//Structural Description for the comparator
module structuralComparator(A, B, S, Equal, Greater, Smaller); //6 Bit Unsigned or Signed (2's Complement Representation) Comparator
  //Inputs and Outputs
  input [5:0] A, B;  //A ,B 6 Bits numbers to be compared
  input S;  //Selection Line. S=1 -> Signed / S=0 -> Unsigned
  output reg Equal, Greater, Smaller;  //Results for the comparison
  
  wire e5,e4,e3,e2,e1,e0;  //WIRES USED FOR "EQUAL OUTPUT"
  
  wire g5,g4,g3,g2,g1,g0;  //WIRES USED FOR "GREATER THAN OUTPUT"
  wire gt4,gt3,gt2,gt1,gt0;  //USED DURING "GREATER THAN"
  wire gt_unsigned;
  wire [5:0]invertedB;  //Used to invert B input
  
  wire gs; //Used for "SIGNED GREATER THAN"
  wire invA5;  //Inverted MSB in A
  wire gt_signed;
  
  //always @(A,B) begin
   // $display ("in real comp A=%b B=%b",A[5:0],B[5:0]);
 // end
  
  //Equal Output
  //The Equal Output is calculated the same way for unsigned and signed numbers
  
  //Use XNOR for each bit, to see if they are equal
  XNOR xnor1(e5,A[5],B[5]);
  XNOR xnor2(e4,A[4],B[4]);
  XNOR xnor3(e3,A[3],B[3]);
  XNOR xnor4(e2,A[2],B[2]);
  XNOR xnor5(e1,A[1],B[1]);
  XNOR xnor6(e0,A[0],B[0]);
  
  //Check if all bits are set to 1, using AND, output goes to E, if E=1 then A and B are equal
  AND6 and6_1(Equal,e5,e4,e3,e2,e1,e0);
  // E=E5&E4&E3&E2&E1&E0
  
  
  //Greater Than Output
  //The Greater than output is calculated in different ways for unsigned and signed numbers
  //So calculate both ways, then use the 2-1Mux to direct one to output based on S

  //Invert B
  INV not1(invertedB[0],B[0]);
  INV not2(invertedB[1],B[1]);
  INV not3(invertedB[2],B[2]);
  INV not4(invertedB[3],B[3]);
  INV not5(invertedB[4],B[4]);
  INV not6(invertedB[5],B[5]);
  
  
  //Unsigned Greater Than Output
  
  //wires g
  AND and2_1(g5,A[5],invertedB[5]);
  AND and2_2(g4,A[4],invertedB[4]);
  AND and2_3(g3,A[3],invertedB[3]);
  AND and2_4(g2,A[2],invertedB[2]);
  AND and2_5(g1,A[1],invertedB[1]);
  AND and2_6(g0,A[0],invertedB[0]);
  
  //wires gt
  AND and2_7(gt4,e5,g4);
  AND3 and3_1(gt3,e5,e4,g3);
  AND4 and4_1(gt2,e5,e4,e3,g2);
  AND5 and5_1(gt1,e5,e4,e3,e2,g1);
  AND6 and6_2(gt0,e5,e4,e3,e2,e1,g0);
  
  //CALCULATE G unsigned
  OR6 or6_1(gt_unsigned,g5,gt4,gt3,gt2,gt1,gt0);  //gt_unsigned has the "GREATER THAN OUTPUT" for unsigned comparison.
  
  
  //Signed Greater Than Output
  
  //To get the "GREATER THAN OUTPUT" in this case, we first look at the sign bits "MSB"
  //If they are different then we can tell that One is positive "Greater"
  //If they A[5] is not 0 while B[5] is 1, then compare like the unsigned way for the other 5 bits
  
  //gs = ~A[5] "MOST SIGNIFICANT BIT" & B[5] "MOST SIGNIFICANT BIT" , A is AUTOMATICALLY greater if A[5]=0, B[5]=1, Else it is not greater
  //So if else, there can be two possibilites, Equal or Smaller, then
  //Compare the other 5 bits as if they were unsigned
  
  INV not7(invA5,A[5]);
  AND and2_8(gs,invA5,B[5]);
  
  //gt_signed=  gs | gt4 | gt3 | gt2 | gt1 | gt0
  //Here if A[5] is 1 and B[5] is 0, B is greater, we get the output because in (gt4,3,2,1,0) E5 will be 0, thus Greater=0,Equal=0, and we will be able to tell that "Smaller=1 when deriving it"
  OR6 or6_2(gt_signed,gs,gt4,gt3,gt2,gt1,gt0);
  
  //USING THE MUX MODULE DIRECT THE SUITABLE gt_unsigned or gt_signed to G based on S
  mux21 mux21_1(Greater,gt_unsigned,gt_signed,S);
  //NOW G has the correct "GREATER THAN OUTPUT"

  //Smaller Than Output
  //We can derive the "smaller than" output using the "equal" output, and the "greater than" output
  //Smaller = (Greater+Equal)'
  
  NOR nor2_1(Smaller,Greater,Equal); //This would be the last to settle, after the #5 delay after both Greater and Equal settles.
endmodule

//Maximum Comparator Latency is for the SIGNED "Smaller Output", it is 37 time units, so delay 38 to get the settled output




//After bulding the comparator unit, we can make it synchronous, by adding register to the output, and clk input.
module outputR(Q,D,clk);  //Module for output register
  input [2:0] D; // {Equal,Greater,Smaller}
  input clk;
  output reg [2:0] Q;
  always @(posedge clk) begin
  	Q=D;
  end
endmodule

module syncComparator(A, B, S, clk, Equal, Greater, Smaller); //Adding a Register for output and clk for synchronous
  input [5:0]A,B;  //Inputs
  input S,clk;  //Inputs
  output reg Equal, Greater, Smaller;  //Outputs
  //Wires between registers and comparator  
  wire wE, wG, wSM; 
  //always @(A,B) begin
   // $display ("in sync comp A=%b B=%b",A[5:0],B[5:0]);
  //end
  structuralComparator sc1(A, B, S, wE, wG, wSM);
  outputR reg2( {Equal,Greater,Smaller} , {wE,wG,wSM} , clk);
endmodule

module testGenerator(A,B,S,clk,expectedE,expectedG,expectedS);  //Module to generate expected values for testing, Behavioural Comparator
  input [5:0] A,B;
  input S;
  input clk;
  output reg expectedE, expectedG, expectedS;
  always @(posedge clk) begin
  //$display ("in testgen A=%b B=%b",A[5:0],B[5:0]);
    #37;  //Delay of the structural comparator, to produce the output to the analyzer at the same time
            // Generate the behavioural output
            if (S == 0) begin
               // Unsigned Comparison
              expectedE = (A == B);  //The expectedE,G,S here will have the result of the comparisons as its values (1:True / 0:False)
              expectedG = (A > B);
               expectedS = (A < B);
            end else begin
               // Signed Comparison
              expectedE = ($signed(A) == $signed(B));  //$signed used to convert to signed values for comparison
               expectedG = ($signed(A) > $signed(B));
               expectedS = ($signed(A) < $signed(B));
            end
  end
endmodule
    
module resultAnalyzer(Equal,Greater,Smaller,expectedE,expectedG,expectedS,clk); //Compare the results of structural comprartor and behavioural one
  input Equal,Greater,Smaller,expectedE,expectedG,expectedS,clk;
  always @(posedge clk)  //Whenever posedge of clk occurs, the output is stored at the register, and we can do the check
    begin
    #18;  //Delay to settle input
      //$display("Real: E: %b |G: %b |S:%b",Equal,Greater,Smaller);
      //$display("Expected: E: %b |G: %b |S:%b",expectedE,expectedG,expectedS);
      if ({Equal,Greater,Smaller}!={expectedE,expectedG,expectedS})begin  //Check if the values from the structural comparator, are the same from the behavioural one, if not print FAIL and finish
          $display ("==============================");
          $display ("============= FAIL ===========");
          $display ("==============================");
          $finish;
        end
    end
endmodule