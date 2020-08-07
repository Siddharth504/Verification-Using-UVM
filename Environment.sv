class environment extends uvm_env;
  `uvm_component_utils(environment)
  function new(string name="environment", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  agent 		agt; 		// Agent handle
  scoreboard	scb; 		// Scoreboard handle
  //gen_seq       gen;
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = agent::type_id::create("agt", this);
    scb = scoreboard::type_id::create("scb", this);
    //gen = gen_seq::type_id::create("gen", this);
  endfunction
virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  agt.m0.mon_analysis_port.connect(scb.m_analysis_imp);
  endfunction
endclass:environment
