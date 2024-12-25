\TLV calc()
   
   // ==========
   // User Logic
   // ==========
   
   |calc
      @0
         $reset = *reset;
         
         // Board's switch inputs
         $op[1:0] = *ui_in[5:4];
         $val2[7:0] = {4'b0, *ui_in[3:0]};
         $equals_in = *ui_in[7];
         
      @1
         // Calculator result value ($out) becomes first operand ($val1).
         $val1[7:0] = >>1$out;
         
         // Perform a valid computation when "=" button is pressed.
         $valid = $reset ? 1'b0 :
                           $equals_in && ! >>1$equals_in;
         
         // Calculate (all possible operations).
         $sum[7:0] = $val1 + $val2;
         $diff[7:0] = $val1 - $val2;
         $prod[7:0] = $val1 * $val2;
         $quot[7:0] = $val1 / $val2;
         
         // Select the result value, resetting to 0, and retaining if no calculation.
         $out[7:0] = $reset ? 8'b0 :
                     ! $valid ? >>1$out :
                     ($op[1:0] == 2'b00) ? $sum  :
                     ($op[1:0] == 2'b01) ? $diff :
                     ($op[1:0] == 2'b10) ? $prod :
                                           $quot;
         
         
         // Display lower hex digit on 7-segment display.
         $digit[3:0] = $out[3:0];
         *uo_out =
            $digit == 4'h0 ? 8'b00111111 :
            $digit == 4'h1 ? 8'b00000110 :
            $digit == 4'h2 ? 8'b01011011 :
            $digit == 4'h3 ? 8'b01001111 :
            $digit == 4'h4 ? 8'b01100110 :
            $digit == 4'h5 ? 8'b01101101 :
            $digit == 4'h6 ? 8'b01111101 :
            $digit == 4'h7 ? 8'b00000111 :
            $digit == 4'h8 ? 8'b01111111 :
            $digit == 4'h9 ? 8'b01101111 :
            $digit == 4'hA ? 8'b01110111 :
            $digit == 4'hB ? 8'b01111100 :
            $digit == 4'hC ? 8'b00111001 :
            $digit == 4'hD ? 8'b01011110 :
            $digit == 4'hE ? 8'b01111001 :
                             8'b01110001;
         
         
   m5+cal_viz(@1, m5_if(m5_in_fpga, /fpga, /top))
   
   // Connect Tiny Tapeout outputs. Note that uio_ outputs are not available in the Tiny-Tapeout-3-based FPGA boards.
   //*uo_out = 8'b0;
   *uio_out = 8'b0;
   *uio_oe = 8'b0;
