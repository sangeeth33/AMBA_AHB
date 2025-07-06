class ahb_agent extends uvm_agent;
  ahb_sequencer seqr;
  ahb_driver    drv;
  ahb_monitor   mon;
  bit           active;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase: instantiate sequencer, driver (if active) and monitor.
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(bit)::get(this, "", "active", active))
      active = 1;  // default to active mode
    if (active) begin
      seqr = ahb_sequencer::type_id::create("seqr", this);
      drv  = ahb_driver::type_id::create("drv", this);
    end
    mon = ahb_monitor::type_id::create("mon", this);
  endfunction

  // Connect phase: hook the sequencer to the driver.
  virtual function void connect_phase(uvm_phase phase);
    if (active)
      drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

  `uvm_component_utils(ahb_agent)
endclass: ahb_agent