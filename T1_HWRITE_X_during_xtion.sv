class ahb_seq_x_write extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_x_write");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("xwrite_item");
    item.addr   = 32'h280;
    item.write  = 'x; // Illegal X value
    item.size   = 3'b010;
    item.burst  = 3'b000;
    item.length = 4;
    item.wdata  = 32'hBEEF_BEEF;
    start_item(item);
    finish_item(item);
  endtask

  `uvm_object_utils(ahb_seq_x_write)
endclass

class ahb_test_x_write extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq_x_write seq = ahb_seq_x_write::type_id::create("xwrite_seq");
    seq.start(env.agent.seqr);
    #100ns;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_x_write)
endclass