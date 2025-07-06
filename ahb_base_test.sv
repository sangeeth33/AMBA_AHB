class ahb_base_test extends uvm_test;
  ahb_env env;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase: create the test environment.
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ahb_env::type_id::create("env", this);
  endfunction

  // Run phase: launch the base sequence on the agent’s sequencer.
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_base_sequence seq;
    seq = ahb_base_sequence::type_id::create("seq");
    seq.start(env.agent.seqr);
    #200ns; // Allow simulation time for transactions to propagate.
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_base_test)
endclass: ahb_base_test