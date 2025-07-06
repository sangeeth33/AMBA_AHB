class ahb_seq_wrap_misalign extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_wrap_misalign");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("wrap_item");

    item.addr          = 32'h12C;           // Not aligned for wrap boundary
    item.write         = 1;
    item.size          = 3'b010;
    item.burst         = 3'b010;            // WRAP burst
    item.length        = 16;                // Wrap misalignment
    item.wdata         = 32'hFACE_CAFE;

    start_item(item);
    finish_item(item);
  endtask

  `uvm_object_utils(ahb_seq_wrap_misalign)
endclass

class ahb_test_wrap_misalign extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq_wrap_misalign seq = ahb_seq_wrap_misalign::type_id::create("wrap_seq");
    seq.start(env.agent.seqr);
    #200ns;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_wrap_misalign)
endclass