class input_monitor extends uvm_monitor;

  `uvm_component_utils(input_monitor)

  uvm_analysis_port #(trans) inp_monitor_port;

  virtual alu_if.INP_MON vif;
  alu_config m_cfg;

  trans drv2mon;

  function new(string name="input_monitor", uvm_component parent);
    super.new(name,parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(alu_config)::get(this,"","alu_config",m_cfg))
      `uvm_fatal(get_type_name(),"Input Monitor: Failed to get alu_config")

    inp_monitor_port = new("inp_monitor_port", this);

  endfunction


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = m_cfg.vif;
  endfunction


  task run_phase(uvm_phase phase);

    forever begin

      collect_input_monitor();

      `uvm_info("INPUT_MONITOR",
                $sformatf("Input Monitor\n%s",drv2mon.sprint()),
                UVM_LOW)

    end

  endtask


  virtual task collect_input_monitor();

    drv2mon = trans::type_id::create("drv2mon");

    repeat(7)
      @(vif.inp_mon_cb);

    drv2mon.ce        = vif.inp_mon_cb.ce;
    drv2mon.inp_valid = vif.inp_mon_cb.inp_valid;
    drv2mon.OA        = vif.inp_mon_cb.OA;
    drv2mon.OB        = vif.inp_mon_cb.OB;
    drv2mon.mode      = vif.inp_mon_cb.mode;
    drv2mon.cmd       = vif.inp_mon_cb.cmd;

    if ((drv2mon.mode == 1'b1) &&
        (drv2mon.cmd inside {4'b0010,4'b0011}))
      drv2mon.cin = vif.inp_mon_cb.cin;
    else
      drv2mon.cin = 1'b0;

    inp_monitor_port.write(drv2mon);

  endtask

endclass
