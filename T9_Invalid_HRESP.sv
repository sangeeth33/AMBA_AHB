class ahb_seq_bad_hresp extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_bad_hresp");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("bad_resp_item");
    item.addr   = 32'h240;
    item.write  = 1;
    item.size   = 3'b010;
    item.burst  = 3'b000;
    item.length = 4;
    item.wdata  = 32'hDEAD_FACE;
    start_item(item);
    finish_item(item);
    // DUT edit: assert HRESP = 'x' or invalid code for test
  endtask

  `uvm_object_utils(ahb_seq_bad_hresp)
endclass

class ahb_test_bad_hresp extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq_bad_hresp seq = ahb_seq_bad_hresp::type_id::create("bad_resp_seq");
    seq.start(env.agent.seqr);
    #150ns;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_bad_hresp)
endclass