class ahb_seq_retry_loop extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_retry_loop");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("retry_item");
    item.addr   = 32'h320;
    item.write  = 0;
    item.size   = 3'b010;
    item.burst  = 3'b000;
    item.length = 4;
    start_item(item);
    finish_item(item);
    // DUT edit: drive HRESP = RETRY and never allow completion
  endtask

  `uvm_object_utils(ahb_seq_retry_loop)
endclass

class ahb_test_retry_loop extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq_retry_loop seq = ahb_seq_retry_loop::type_id::create("retry_seq");
    seq.start(env.agent.seqr);
    #300ns;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_retry_loop)
endclass