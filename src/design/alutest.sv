class test extends uvm_test;
        `uvm_component_utils(test)

 env env_h;
 alu_config m_cfg;

 function new(string name="test",uvm_component parent);
        super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
        super.build_phase(phase);

  m_cfg=alu_config::type_id::create("m_cfg");
  //virtual_get
  if(!uvm_config_db#(virtual alu_if)::get(this,"","alu_if",m_cfg.vif))
        `uvm_fatal(get_type_name,"Can't get the interface")
  m_cfg.input_agent_is_active=UVM_ACTIVE;
  m_cfg.output_agent_is_active=UVM_PASSIVE;

  uvm_config_db#(alu_config)::set(this,"*","alu_config",m_cfg);

  env_h=env::type_id::create("env_h",this);

 endfunction

 function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
   uvm_top.print_topology();
endfunction



endclass
