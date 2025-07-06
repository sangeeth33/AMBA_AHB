class ahb_seq_active_during_reset extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_active_during_reset");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("reset_item");
    item.addr   = 32'h380;
    item.write  = 1;
    item.size   = 3'b010;
    item.burst  = 3'b000;
    item.length = 4;
    item.wdata  = 32'hCAFEBABE;
    start_item(item);
    finish_item(item);
    // Top-level TB drives HRESETn low while this runs
  endtask

  `uvm_object_utils(ahb_seq_active_during_reset)
endclass

class ahb_test_active_during_reset extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    env.agent.vif.HRESETn = 0;
    ahb_seq_active_during_reset seq = ahb_seq_active_during_reset::type_id::create("reset_seq");
    seq.start(env.agent.seqr);
    #100ns;
    env.agent.vif.HRESETn = 1;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_active_during_reset)
endclass