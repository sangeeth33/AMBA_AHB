class ahb_monitor extends uvm_monitor;
  import ahb_pkg::*;
  // Virtual interface for sampling DUT signals.
  virtual ahb_if vif;
  // Analysis port to send the sampled transactions.
  uvm_analysis_port#(ahb_seq_item) analysis_port;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  // Build phase: retrieve the virtual interface.
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ahb_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for monitor!");
  endfunction

  // Run phase: monitor and capture transactions on clock edges.
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.HCLK);
      if (vif.HTRANS != HTRANS_IDLE) begin
        ahb_seq_item mon_item;
        mon_item = ahb_seq_item::type_id::create("mon_item");
        mon_item.trans  = vif.HTRANS;
        mon_item.addr   = vif.HADDR;
        mon_item.write  = vif.HWRITE;
        mon_item.size   = vif.HSIZE;
        mon_item.burst  = vif.HBURST;
        mon_item.length = vif.HLENGTH;
        mon_item.wdata  = vif.HWDATA;
        analysis_port.write(mon_item);
      end
    end
  endtask

  `uvm_component_utils(ahb_monitor)
endclass: ahb_monitor