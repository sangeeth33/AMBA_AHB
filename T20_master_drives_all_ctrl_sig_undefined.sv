class ahb_seq_undefined_ctrl extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_undefined_ctrl");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("undefined_ctrl_item");

    item.trans  = 'x;
    item.addr   = 32'h00000000;
    item.write  = 'x;
    item.size   = 'x;
    item.burst  = 'x;
    item.length = 8;
    item.wdata  = 'x;
    item.force_illegal = 1;

    start_item(item);
    finish_item(item);
  endtask

  `uvm_object_utils(ahb_seq_undefined_ctrl)
endclass

class ahb_test_undefined_ctrl extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq_undefined_ctrl seq = ahb_seq_undefined_ctrl::type_id::create("undefined_ctrl_seq");
    seq.start(env.agent.seqr);
    #150ns;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_undefined_ctrl)
endclass