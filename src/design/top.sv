module top;

  bit clk;

  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  
  alu_if vif(clk);
  
  ALU_DESIGN dut (
    .INP_VALID(vif.INP_VALID),
    .OPA      (vif.OPA),
    .OPB      (vif.OPB),
    .CIN      (vif.CIN),
    .CLK      (vif.CLK),
    .RST      (vif.RST),
    .CMD      (vif.CMD),
    .CE       (vif.CE),
    .MODE     (vif.MODE),
    .COUT     (vif.COUT),
    .OFLOW    (vif.OFLOW),
    .RES      (vif.RES),
    .G        (vif.G),
    .E        (vif.E),
    .L        (vif.L),
    .ERR      (vif.ERR)
  );

  
  initial begin
    uvm_config_db#(virtual alu_if)::set(
      null,
      "*",
      "vif",
      vif
    );

    run_test("test");
  end
endmodule

endmodule
