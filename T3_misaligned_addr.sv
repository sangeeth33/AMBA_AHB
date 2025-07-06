class ahb_seq_misaligned_addr extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_misaligned_addr");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("misalign_item");

    item.addr          = 32'h101;         // Not word-aligned
    item.write         = 1;
    item.size          = 3'b010;          // Word transfer
    item.burst         = 3'b000;          // SINGLE
    item.length        = 4;
    item.wdata         = 32'hFEED_BEEF;

    start_item(item);
    finish_item(item);
  endtask

  `uvm_object_utils(ahb_seq_misaligned_addr)
endclass

class ahb_test_misaligned_addr extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq_misaligned_addr seq = ahb_seq_misaligned_addr::type_id::create("misalign_seq");
    seq.start(env.agent.seqr);
    #100ns;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_misaligned_addr)
endclass