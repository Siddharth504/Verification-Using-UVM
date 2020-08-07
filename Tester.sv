 class tester extends uvm_test;
  `uvm_component_utils(tester)
  function new(string name = "tester", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  environment env;
  gen_seq 	seq;
  virtual inf vif;
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the environment
    env = environment::type_id::create("env", this);
    //env.gen.repeat_count=8;
    // Get virtual IF handle from top level and pass it to everything
    // in env level
    if (!uvm_config_db#(virtual inf)::get(this, "", "vir_intf", vif))
      `uvm_fatal("TEST", "Did not get vif")
      uvm_config_db#(virtual inf)::set(this, "env.*", "vir_intf", vif);
   // Create sequence and randomize it
   seq = gen_seq::type_id::create("seq");
    seq.repeat_count=8;
  endfunction
    virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    apply_reset();
      seq.start(env.agt.s0);
    #120;
    phase.drop_objection(this);
  endtask
  virtual task apply_reset();
    fork
    env.agt.d0.reset;
    env.scb.reset;
    `uvm_info("test", $sformatf("Done reset"), UVM_LOW)
    join
  endtask
endclass:tester
