class ahb_seq_hsel_toggle extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_hsel_toggle");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("hsel_item");
    item.addr   = 32'h2A0;
    item.write  = 1;
    item.size   = 3'b010;
    item.burst  = 3'b000;
    item.length = 4;
    item.wdata  = 32'hA5A5_5A5A;
    start_item(item);
    finish_item(item);
    // Top-level or driver should simulate toggling HSEL mid-transaction
  endtask

  `uvm_object_utils(ahb_seq_hsel_toggle)
endclass

class ahb_test_hsel_toggle extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq_hsel_toggle seq = ahb_seq_hsel_toggle::type_id::create("hsel_seq");
    seq.start(env.agent.seqr);
    #200ns;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_hsel_toggle)
endclass