interface alu_if(input bit clk);

  logic [7:0] OA;
  logic [7:0] OB;
  logic [1:0] inp_valid;
  logic [3:0] cmd;
  logic [7:0] res;
  logic rst, mode, ce, cin;
  logic err, oflow, cout;
  logic G, E, L;

 
  clocking inp_dr_cb @(posedge clk);
    default input #1 output #1;

    output OA;
    output OB;
    output inp_valid;
    output cmd;
    output mode;
    output cin;
    output ce;
    output rst;
  endclocking


  clocking inp_mon_cb @(posedge clk);
    default input #1 output #1;

    input OA;
    input OB;
    input inp_valid;
    input cmd;
    input mode;
    input cin;
    input ce;
    input rst;
  endclocking

  clocking out_mon_cb @(posedge clk);
    default input #1 output #1;

    // DUT Inputs
    input OA;
    input OB;
    input inp_valid;
    input cmd;
    input mode;
    input cin;
    input ce;
    input rst;

  
    input err;
    input res;
    input oflow;
    input cout;
    input G;
    input E;
    input L;
  endclocking

  modport INP_DRV (clocking inp_dr_cb);
  modport INP_MON (clocking inp_mon_cb);
  modport OUT_MON (clocking out_mon_cb);

endinterface








