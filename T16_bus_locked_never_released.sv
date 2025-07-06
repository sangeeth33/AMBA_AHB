class ahb_seq_lock_hold extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_lock_hold");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("lock_item");
    item.addr   = 32'h360;
    item.write  = 1;
    item.size   = 3'b010;
    item.burst  = 3'b000;
    item.length = 4;
    item.wdata  = 32'h1234_5678;
    start_item(item);
    finish_item(item);
    // Driver/DUT should enable bus lock without releasing
  endtask

  `uvm_object_utils(ahb_seq_lock_hold)
endclass

class ahb_test_lock_hold extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq_lock_hold seq = ahb_seq_lock_hold::type_id::create("lock_seq");
    seq.start(env.agent.seqr);
    #300ns;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_lock_hold)
endclass