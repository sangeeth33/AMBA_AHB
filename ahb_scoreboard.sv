class ahb_scoreboard extends uvm_component implements uvm_analysis_imp#(ahb_seq_item,ahb_scoreboard);
  // Analysis export port for monitor connection.
  uvm_analysis_export#(ahb_seq_item) analysis_export;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
  endfunction

  // Connect phase: (Could set up connections here if needed.)
  virtual function void connect_phase(uvm_phase phase);
    // The environment connects the export to our write() method.
  endfunction

  // Write method: called when a monitored transaction is received.
  virtual function void write(ahb_seq_item trans);
    `uvm_info("SCOREBOARD", $sformatf("Scoreboard received: %s", trans.convert2string()), UVM_MEDIUM)
    // Here you would normally check the DUT response versus expected results.
  endfunction

  `uvm_component_utils(ahb_scoreboard)
endclass: ahb_scoreboard