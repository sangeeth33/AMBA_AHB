class ahb_env extends uvm_env;
  ahb_agent      agent;
  ahb_scoreboard scoreboard;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase: instantiate agent and scoreboard.
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = ahb_agent::type_id::create("agent", this);
    scoreboard = ahb_scoreboard::type_id::create("scoreboard", this);
  endfunction

  // Connect phase: connect monitor analysis port to scoreboard export.
  virtual function void connect_phase(uvm_phase phase);
    agent.mon.analysis_port.connect(scoreboard.analysis_export);
  endfunction

  `uvm_component_utils(ahb_env)
endclass: ahb_env