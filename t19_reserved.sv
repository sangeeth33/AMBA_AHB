class ahb_seq_reserved_hburst extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_reserved_hburst");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("reserved_burst_item");

    item.addr   = 32'h3C0;
    item.write  = 1;
    item.size   = 3'b010;
    item.burst  = 3'b101; // Reserved burst type
    item.length = 8;
    item.wdata  = 32'hABCD_EF01;

    start_item(item);
    finish_item(item);
  endtask

  `uvm_object_utils(ahb_seq_reserved_hburst)
endclass

class ahb_test_reserved_hburst extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq_reserved_hburst seq = ahb_seq_reserved_hburst::type_id::create("reserved_burst_seq");
    seq.start(env.agent.seqr);
    #200ns;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_reserved_hburst)
endclass