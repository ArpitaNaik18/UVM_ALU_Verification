class trans extends uvm_sequence_item;

  `uvm_object_utils(trans)

  rand bit [7:0] OA;
  rand bit [7:0] OB;
  rand bit [1:0] inp_valid;
  rand bit [3:0] cmd;
  rand bit mode;
  rand bit cin;
  rand bit ce;

  logic [8:0] res;
  logic rst;
  logic err;
  logic oflow;
  logic cout;
  logic G, E, L;

  // Constraints
  constraint c0 { ce dist {1 := 90, 0 := 10}; }

  constraint c1 { OA inside {[8'd1:8'd255]}; }

  constraint c2 { OB inside {[8'd1:8'd255]}; }

  constraint c3 {
    inp_valid dist {
      2'b00 := 5,
      2'b01 := 5,
      2'b10 := 5,
      2'b11 := 500
    };
  }

  constraint c4 {
    mode dist {
      1'b1 := 5,
      1'b0 := 5
    };
  }

  constraint c5 {
    if (mode)
      cmd < 11;
    else
      cmd < 13;
  }

  constraint c6 {
    cin dist {
      1 := 5,
      0 := 5
    };
  }

  function new(string name="trans");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);

    trans rhs_;

    if(!$cast(rhs_,rhs))
      `uvm_fatal("DO_COPY","Cast failed")

    super.do_copy(rhs);

    OA        = rhs_.OA;
    OB        = rhs_.OB;
    inp_valid = rhs_.inp_valid;
    cmd       = rhs_.cmd;
    mode      = rhs_.mode;
    cin       = rhs_.cin;
    ce        = rhs_.ce;
    res       = rhs_.res;
    rst       = rhs_.rst;
    err       = rhs_.err;
    oflow     = rhs_.oflow;
    cout      = rhs_.cout;
    G         = rhs_.G;
    E         = rhs_.E;
    L         = rhs_.L;

  endfunction


  virtual function bit do_compare
  (
      uvm_object rhs,
      uvm_comparer comparer
  );

    trans rhs_;

    if(!$cast(rhs_,rhs))
      `uvm_fatal("DO_COMPARE","Cast failed")

    return super.do_compare(rhs,comparer) &&
           res   == rhs_.res &&
           err   == rhs_.err &&
           oflow == rhs_.oflow &&
           cout  == rhs_.cout &&
           G     == rhs_.G &&
           E     == rhs_.E &&
           L     == rhs_.L;

  endfunction


  virtual function void do_print(uvm_printer printer);

    super.do_print(printer);

    printer.print_field("Clock Enable", ce, 1, UVM_DEC);
    printer.print_field("INPUT_A", OA, 8, UVM_DEC);
    printer.print_field("INPUT_B", OB, 8, UVM_DEC);
    printer.print_field("INPUT_VALID", inp_valid, 2, UVM_DEC);
    printer.print_field("COMMAND", cmd, 4, UVM_DEC);
    printer.print_field("MODE", mode, 1, UVM_DEC);
    printer.print_field("CIN", cin, 1, UVM_DEC);

    printer.print_field("RESULT", res, 9, UVM_DEC);
    printer.print_field("ERROR", err, 1, UVM_DEC);
    printer.print_field("OFLOW", oflow, 1, UVM_DEC);
    printer.print_field("COUT", cout, 1, UVM_DEC);
    printer.print_field("GREATER", G, 1, UVM_DEC);
    printer.print_field("EQUALITY", E, 1, UVM_DEC);
    printer.print_field("LESSER", L, 1, UVM_DEC);

  endfunction

endclass
