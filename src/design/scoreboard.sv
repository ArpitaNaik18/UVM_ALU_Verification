class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

 
  uvm_tlm_analysis_fifo #(trans) inp_mon_fifo;
  uvm_tlm_analysis_fifo #(trans) out_mon_fifo;

 
  trans inp_mon_xn;
  trans out_mon_xn;

  
  trans exp_pkt;

  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);

    inp_mon_fifo = new("inp_mon_fifo", this);
    out_mon_fifo = new("out_mon_fifo", this);
  endfunction

  task run_phase(uvm_phase phase);

    forever begin

    
      inp_mon_fifo.get(inp_mon_xn);
      out_mon_fifo.get(out_mon_xn);

  
      exp_pkt = trans::type_id::create("exp_pkt");

      exp_pkt.copy(inp_mon_xn);

     
      ref_model(exp_pkt);

      `uvm_info("REFERENCE_MODEL",
                $sformatf("\nExpected Packet\n%s",
                exp_pkt.sprint()),
                UVM_LOW)

      validate_output();

    end

  endtask

  virtual task validate_output();

    if(exp_pkt.compare(out_mon_xn)) begin

      `uvm_info(get_type_name(),
                "DATA MATCH SUCCESSFUL",
                UVM_LOW);

    end
    else begin

      `uvm_error(get_type_name(),
                 "DATA MISMATCH")

      `uvm_info(get_type_name(),
                $sformatf("\nEXPECTED PACKET\n%s",
                exp_pkt.sprint()),
                UVM_LOW)

      `uvm_info(get_type_name(),
                $sformatf("\nDUT PACKET\n%s",
                out_mon_xn.sprint()),
                UVM_LOW)

      check_Data(out_mon_xn);

    end

  endtask

task check_Data(trans dut_pkt);

    if(exp_pkt.res == dut_pkt.res)
      `uvm_info("SB","RESULT MATCH",UVM_LOW)
    else
      `uvm_error("SB",
        $sformatf("RESULT MISMATCH Exp=%0d Act=%0d",
                  exp_pkt.res,dut_pkt.res));


    if(exp_pkt.err == dut_pkt.err)
      `uvm_info("SB","ERR MATCH",UVM_LOW)
    else
      `uvm_error("SB",
        $sformatf("ERR MISMATCH Exp=%0b Act=%0b",
                  exp_pkt.err,dut_pkt.err));


    if(exp_pkt.cout == dut_pkt.cout)
      `uvm_info("SB","COUT MATCH",UVM_LOW)
    else
      `uvm_error("SB",
        $sformatf("COUT MISMATCH Exp=%0b Act=%0b",
                  exp_pkt.cout,dut_pkt.cout));


    if(exp_pkt.oflow == dut_pkt.oflow)
      `uvm_info("SB","OFLOW MATCH",UVM_LOW)
    else
      `uvm_error("SB",
        $sformatf("OFLOW MISMATCH Exp=%0b Act=%0b",
                  exp_pkt.oflow,dut_pkt.oflow));


    if(exp_pkt.G == dut_pkt.G)
      `uvm_info("SB","GREATER MATCH",UVM_LOW)
    else
      `uvm_error("SB",
        $sformatf("GREATER MISMATCH Exp=%0b Act=%0b",
                  exp_pkt.G,dut_pkt.G));

  if(exp_pkt.E == dut_pkt.E)
      `uvm_info("SB","EQUAL MATCH",UVM_LOW)
    else
      `uvm_error("SB",
        $sformatf("EQUAL MISMATCH Exp=%0b Act=%0b",
                  exp_pkt.E,dut_pkt.E));


    if(exp_pkt.L == dut_pkt.L)
      `uvm_info("SB","LESS MATCH",UVM_LOW)
    else
      `uvm_error("SB",
        $sformatf("LESS MISMATCH Exp=%0b Act=%0b",
                  exp_pkt.L,dut_pkt.L));

  endtask



  virtual task ref_model(trans t);

    bit [7:0] oprd1, oprd2;
    bit [3:0] CMD_tmp;

    bit [7:0] AU_out_tmp1;
    bit [7:0] AU_out_tmp2;

    bit [7:0] OPA_1;
    bit [7:0] OPB_1;




    if (t.rst) begin
      oprd1   = 0;
      oprd2   = 0;
      CMD_tmp = 0;
    end
    else if (t.inp_valid == 2'b01) begin
      oprd1   = t.OA;
      CMD_tmp = t.cmd;
    end
    else if (t.inp_valid == 2'b10) begin
      oprd2   = t.OB;
      CMD_tmp = t.cmd;
    end
    else if (t.inp_valid == 2'b11) begin
      oprd1   = t.OA;
      oprd2   = t.OB;
      CMD_tmp = t.cmd;
    end
    else begin
      oprd1   = 0;
      oprd2   = 0;
      CMD_tmp = 0;
    end


   
    if (t.ce) begin


      if (t.rst) begin

        t.res    = 9'bz;
        t.cout   = 1'bz;
        t.oflow  = 1'bz;
        t.G      = 1'bz;
        t.E      = 1'bz;
        t.L      = 1'bz;
        t.err    = 1'bz;

        AU_out_tmp1 = 0;
        AU_out_tmp2 = 0;

      end

   
      else if (t.mode) begin

        t.res    = 9'bz;
        t.cout   = 1'bz;
        t.oflow  = 1'bz;
        t.G      = 1'bz;
        t.E      = 1'bz;
        t.L      = 1'bz;
        t.err    = 1'bz;

        case (CMD_tmp)

        
          4'b0000: begin
            t.res  = oprd1 + oprd2;
            t.cout = t.res[8];
          end

      
          4'b0001: begin
            t.oflow = (oprd1 < oprd2);
            t.res   = oprd1 - oprd2;
          end

          4'b0010: begin
            t.res  = oprd1 + oprd2 + t.cin;
            t.cout = t.res[8];
          end

         
          4'b0011: begin
            t.oflow = (oprd1 < oprd2);
            t.res   = oprd1 - oprd2 - t.cin;
          end

         
          4'b0100:
            t.res = oprd1 + 1;

       
          4'b0101:
            t.res = oprd1 - 1;

        
          4'b0110:
            t.res = oprd2 + 1;

       
          4'b0111:
            t.res = oprd2 - 1;

        
          4'b1000: begin

            t.res = 9'bz;

            if (oprd1 == oprd2) begin
              t.E = 1;
              t.G = 1'bz;
              t.L = 1'bz;
            end
            else if (oprd1 > oprd2) begin
              t.G = 1;
              t.E = 1'bz;
              t.L = 1'bz;
            end
            else begin
              t.L = 1;
              t.G = 1'bz;
              t.E = 1'bz;
            end

          end

      
          4'b1001: begin

            AU_out_tmp1 = oprd1 + 1;
            AU_out_tmp2 = oprd2 + 1;

            t.res = AU_out_tmp1 * AU_out_tmp2;

          end

          
          4'b1010: begin

            AU_out_tmp1 = oprd1 << 1;
            AU_out_tmp2 = oprd2;

            t.res = AU_out_tmp1 * AU_out_tmp2;

          end

          default: begin

            t.res    = 9'bz;
            t.cout   = 1'bz;
            t.oflow  = 1'bz;
            t.G      = 1'bz;
            t.E      = 1'bz;
            t.L      = 1'bz;
            t.err    = 1'bz;

          end

        endcase

      end

   
      else begin

      
        t.res    = 9'bz;
        t.cout   = 1'bz;
        t.oflow  = 1'bz;
        t.G      = 1'bz;
        t.E      = 1'bz;
        t.L      = 1'bz;
        t.err    = 1'bz;

        case (CMD_tmp)

         
          4'b0000: t.res = {1'b0, (oprd1 & oprd2)};

          
          4'b0001: t.res = {1'b0, ~(oprd1 & oprd2)};

    
          4'b0010: t.res = {1'b0, (oprd1 | oprd2)};

      
          4'b0011: t.res = {1'b0, ~(oprd1 | oprd2)};

  
          4'b0100: t.res = {1'b0, (oprd1 ^ oprd2)};

          4'b0101: t.res = {1'b0, ~(oprd1 ^ oprd2)};


          4'b0110: t.res = {1'b0, ~oprd1};


          4'b0111: t.res = {1'b0, ~oprd2};

     
          4'b1000: t.res = {1'b0, (oprd1 >> 1)};

      
          4'b1001: t.res = {1'b0, (oprd1 << 1)};

     
          4'b1010: t.res = {1'b0, (oprd2 >> 1)};


          4'b1011: t.res = {1'b0, (oprd2 << 1)};

          4'b1100: begin

            if(oprd2[0])
              OPA_1 = {oprd1[6:0],oprd1[7]};
            else
              OPA_1 = oprd1;

            if(oprd2[1])
              OPB_1 = {OPA_1[5:0],OPA_1[7:6]};
            else
              OPB_1 = OPA_1;

            if(oprd2[2])
              t.res = {OPB_1[3:0],OPB_1[7:4]};
            else
              t.res = OPB_1;

            if(oprd2[4] || oprd2[5] || oprd2[6] || oprd2[7])
              t.err = 1'b1;

          end

        
          4'b1101: begin

            if(oprd2[0])
              OPA_1 = {oprd1[0],oprd1[7:1]};
            else
              OPA_1 = oprd1;

            if(oprd2[1])
              OPB_1 = {OPA_1[1:0],OPA_1[7:2]};
            else
              OPB_1 = OPA_1;

            if(oprd2[2])
              t.res = {OPB_1[3:0],OPB_1[7:4]};
            else
              t.res = OPB_1;

            if(oprd2[4] || oprd2[5] || oprd2[6] || oprd2[7])
              t.err = 1'b1;

          end

         
          default: begin
            t.res    = 9'bz;
            t.cout   = 1'bz;
            t.oflow  = 1'bz;
            t.G      = 1'bz;
            t.E      = 1'bz;
            t.L      = 1'bz;
            t.err    = 1'bz;
          end

        endcase

      end // Logic mode

    end // ce

  endtask : ref_model

endclass

