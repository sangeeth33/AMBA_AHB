class ahb_seq_split_stall extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_split_stall");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("split_item");
    item.addr   = 32'h300;
    item.write  = 1;
    item.size   = 3'b010;
    item.burst  = 3'b000;
    item.length = 4;
    item.wdata  = 32'h5A5A_A5A5;
    start_item(item);
    finish_item(item);
    // DUT edit: issue SPLIT and never return bus grant
  endtask

  `uvm_object_utils(ahb_seq_split_stall)
endclass

class ahb_test_split_stall extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq_split_stall seq = ahb_seq_split_stall::type_id::create("split_seq");
    seq.start(env.agent.seqr);
    #300ns;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_split_stall)
endclass