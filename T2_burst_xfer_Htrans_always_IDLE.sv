class ahb_seq_idle_burst extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_idle_burst");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("idle_item");

    item.force_illegal = 1;
    item.trans         = HTRANS_IDLE;     // Illegal during burst
    item.addr          = 32'h100;
    item.write         = 1;
    item.size          = 3'b010;
    item.burst         = 3'b001;          // INCR burst
    item.length        = 16;
    item.wdata         = 32'hDEAD_BEEF;

    start_item(item);
    finish_item(item);
  endtask

  `uvm_object_utils(ahb_seq_idle_burst)
endclass

class ahb_test_idle_burst extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq_idle_burst seq = ahb_seq_idle_burst::type_id::create("idle_burst_seq");
    seq.start(env.agent.seqr);
    #100ns;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_idle_burst)
endclass