module comparator_test;  //Code for verification, to test all inputs "Exhaustive Testing", and print output if error occurs.
  //Test Inputs and Outputs
  reg [5:0]Ain,Bin;  //Values to be passed to the Comparator and Test Generator 
  reg Sin;
  reg clk;  //clk to control to control execution
  wire  Equal,Greater,Smaller;  //Values from structural comparator
  wire  e,g,s; //Expected Values from test generator
  
  testGenerator testgen1(Ain,Bin,Sin,clk,e,g,s);
  syncComparator syncComp1(Ain,Bin,Sin,clk,Equal,Greater,Smaller);
  resultAnalyzer resAn1(Equal,Greater,Smaller,e,g,s,clk);
  
  initial begin
    clk=1;
    forever 
      #19 clk = ~clk; //Invert clock evey 19 time units (CLOCK PERIOD = 38. Delay in comparator =37, at clk-posedge output would be ready)
  end
  
  initial begin
   // Initialize values
    Ain=6'b000000;
   // Loop through all values of A, B, S
    for (int A = 0; A < 64; A = A + 1) begin
          Bin=6'b000000;
      for (int B = 0; B < 64; B = B + 1) begin
            Sin=1'b0;
        for (int S = 0; S <= 1; S = S + 1) begin
            // Generate A,B, S Values
            // Wait for the next positive edge of the clock before moving to next input
          #38;
          Sin=Sin+1'b1;
        end
         Bin=Bin+6'b000001;
      end
      Ain=Ain+6'b000001;
   end
    
    // If all values are tested without fail then test finished, print pass message
    #38 //Delay to make sure all cases are analyzed
   $display ("==============================");
   $display ("============= PASS ===========");
   $display ("==============================");
   $finish;
  end
endmodule
  