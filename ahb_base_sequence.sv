class ahb_base_sequence extends uvm_sequence #(ahb_seq_item);
  // Constructor
  function new(string name = "ahb_base_sequence");
    super.new(name);
  endfunction

  // Body: Create, randomize, and send a transaction item.
  virtual task body();
    ahb_seq_item item;
    item = ahb_seq_item::type_id::create("item");
    if (!item.randomize()) begin
      `uvm_error("RANDOMIZE", "Randomization failed for sequence item!");
    end
    start_item(item);
    finish_item(item);
  endtask

  `uvm_object_utils(ahb_base_sequence)
endclass: ahb_base_sequence