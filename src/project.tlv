\m5_TLV_version 1d: tl-x.org
\m5
   
   // =================================================
   // Welcome!  New to Makerchip? Try the "Learn" menu.
   // =================================================
   
   //use(m5-1.0)   /// uncomment to use M5 macro library.
\SV
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m5_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
   |calc
      @1
         $reset = *reset;
         $val1[7:0] = (reset) ? 8'b0 : >>1$out;
         $val2[7:0] = {3'b0, $rand2[4:0]};
         $sum[7:0] = $val1[7:0] + $val2[7:0];
         $diff[7:0] = $val1[7:0] - $val2[7:0];
         $prod[7:0] = $val1[7:0] * $val2[7:0];
         $quot[7:0] = $val1[7:0] / $val2[7:0];
         $out[7:0] = $op[1:0] == 2'd0 ? $sum : $op[1:0] == 2'd1 ? $diff : $op[1:0] == 2'd2 ? $prod : $quot;
   
   //...
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
