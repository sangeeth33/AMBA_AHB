class ahb_seq_contention extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_contention");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("contention_item");
    item.addr   = 32'h340;
    item.write  = 1;
    item.size   = 3'b010;
    item.burst  = 3'b000;
    item.length = 4;
    item.wdata  = 32'hCCCC_DDDD;
    start_item(item);
    finish_item(item);
    // Simulation setup should invoke 2 masters concurrently
  endtask

  `uvm_object_utils(ahb_seq_contention)
endclass

class ahb_test_contention extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq_contention seq = ahb_seq_contention::type_id::create("contention_seq");
    seq.start(env.agent.seqr);
    #300ns;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_contention)
endclass