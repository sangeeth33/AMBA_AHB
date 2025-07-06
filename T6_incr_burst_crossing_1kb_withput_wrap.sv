class ahb_seq_incr_cross_1kb extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_incr_cross_1kb");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("cross_item");

    item.addr          = 32'h3F0;           // Close to 1KB boundary (0x400)
    item.write         = 1;
    item.size          = 3'b010;
    item.burst         = 3'b001;            // INCR burst
    item.length        = 32;                // 8 words → cross boundary
    item.wdata         = 32'hC0DE_CAFE;

    start_item(item);
    finish_item(item);
  endtask

  `uvm_object_utils(ahb_seq_incr_cross_1kb)
endclass

class ahb_test_incr_cross_1kb extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq_incr_cross_1kb seq = ahb_seq_incr_cross_1kb::type_id::create("cross_seq");
    seq.start(env.agent.seqr);
    #300ns;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_incr_cross_1kb)
endclass