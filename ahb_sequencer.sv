
class ahb_sequencer extends uvm_sequencer #(ahb_seq_item);
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  `uvm_component_utils(ahb_sequencer)
endclass: ahb_sequencer