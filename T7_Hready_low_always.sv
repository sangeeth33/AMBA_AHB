class ahb_seq_hready_stall extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_hready_stall");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("stall_item");
    item.addr   = 32'h200;
    item.write  = 1;
    item.size   = 3'b010;
    item.burst  = 3'b000;
    item.length = 4;
    item.wdata  = 32'hDEAD_C0DE;
    start_item(item);
    finish_item(item);
    // DUT interface HREADY would be overridden in TB to hold low
  endtask

  `uvm_object_utils(ahb_seq_hready_stall)
endclass


class ahb_test_hready_stall extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    env.agent.vif.HREADY = 0; // Stall signal
    ahb_seq_hready_stall seq = ahb_seq_hready_stall::type_id::create("stall_seq");
    seq.start(env.agent.seqr);
    #200ns;
    env.agent.vif.HREADY = 1; // Release after stall
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_hready_stall)
endclass