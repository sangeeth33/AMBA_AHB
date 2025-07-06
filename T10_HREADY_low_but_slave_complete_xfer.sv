class ahb_seq_hready_misuse extends uvm_sequence #(ahb_seq_item);
  function new(string name = "ahb_seq_hready_misuse");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item = ahb_seq_item::type_id::create("hready_item");
    item.addr   = 32'h260;
    item.write  = 1;
    item.size   = 3'b010;
    item.burst  = 3'b000;
    item.length = 4;
    item.wdata  = 32'hF00D_DEED;
    start_item(item);
    finish_item(item);
    // DUT edit: assert HREADY=0 but still process transaction
  endtask

  `uvm_object_utils(ahb_seq_hready_misuse)
endclass

class ahb_test_hready_misuse extends ahb_base_test;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq_hready_misuse seq = ahb_seq_hready_misuse::type_id::create("misuse_seq");
    seq.start(env.agent.seqr);
    #200ns;
    phase.drop_objection(this);
  endtask

  `uvm_component_utils(ahb_test_hready_misuse)
endclass