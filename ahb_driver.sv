class ahb_driver extends uvm_driver #(ahb_seq_item);
  import ahb_pkg::*;
  // Virtual interface to drive signals to the DUT.
  virtual ahb_if vif;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase: obtain the virtual interface from UVM configuration.
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ahb_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for driver!");
  endfunction

  // Run phase: drive the transaction on the DUT.
  virtual task run_phase(uvm_phase phase);
    forever begin
      ahb_seq_item req;
      // Receive next transaction from the sequencer.
      seq_item_port.get_next_item(req);
      
      // Drive first cycle as NONSEQ.
      vif.HTRANS  <= HTRANS_NONSEQ;
      vif.HADDR   <= req.addr;
      vif.HWRITE  <= req.write;
      vif.HSIZE   <= req.size;
      vif.HBURST  <= req.burst;
      vif.HLENGTH <= req.length;
      vif.HWDATA  <= req.wdata;
      @(posedge vif.HCLK);
      
      // If a burst is desired, drive additional SEQ cycles.
      if (req.burst != 3'b000 && req.length > 4) begin
        int num_cycles;
        num_cycles = req.length / 4 - 1;  // first cycle already driven
        for (int i = 0; i < num_cycles; i++) begin
          vif.HTRANS <= HTRANS_SEQ;
          vif.HADDR  <= vif.HADDR + 4;  // Increment address each word
          // For writes, drive same data (for simplicity).
          vif.HWDATA <= req.wdata;
          @(posedge vif.HCLK);
        end
      end
      
      // End transaction: set interface to idle.
      vif.HTRANS <= HTRANS_IDLE;
      seq_item_port.item_done();
    end
  endtask

  `uvm_component_utils(ahb_driver)
endclass: ahb_driver