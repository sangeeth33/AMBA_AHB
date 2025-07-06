class ahb_seq_oversize_transfer extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_oversize_transfer");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("oversize_item");

    item.addr          = 32'h104;
    item.write         = 1;
    item.size          = 3'b011;         // 64-bit on 32-bit bus
    item.burst         = 3'b000;
    item.length        = 8;
    item.wdata         = 32'hBAD_F00D;

    start_item(item);
    finish_item(item);
  endtask

  `uvm_object_utils(ahb_seq_oversize_transfer)
endclass

class ahb_test_oversize_transfer extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq_oversize_transfer seq = ahb_seq_oversize_transfer::type_id::create("oversize_seq");
    seq.start(env.agent.seqr);
    #100ns;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_oversize_transfer)
endclass