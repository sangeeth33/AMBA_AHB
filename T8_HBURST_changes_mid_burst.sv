class ahb_seq_burst_switch extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_burst_switch");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("switch_item");
    item.addr   = 32'h220;
    item.write  = 1;
    item.size   = 3'b010;
    item.burst  = 3'b001;
    item.length = 16;
    item.wdata  = 32'hBAD_BEEF;
    start_item(item);
    finish_item(item);
    // Driver extension: switch HBURST mid-sequence (requires driver edit)
  endtask

  `uvm_object_utils(ahb_seq_burst_switch)
endclass

class ahb_test_burst_switch extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq_burst_switch seq = ahb_seq_burst_switch::type_id::create("switch_seq");
    seq.start(env.agent.seqr);
    #300ns;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_burst_switch)
endclass