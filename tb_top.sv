module tb_top;
  import ahb_pkg::*;
  // Clock & reset signals
  logic HCLK, HRESETn;

  // Instantiate the AHB interface.
  ahb_if ahb_vif();

  // Generate a 10ns period clock
  initial begin
    HCLK = 0;
    forever #5 HCLK = ~HCLK;
  end

  // Generate reset: asserted for the first 20ns.
  initial begin
    HRESETn = 0;
    #20;
    HRESETn = 1;
  end

  // Connect testbench signals to the interface.
  initial begin
    ahb_vif.HCLK    = HCLK;
    ahb_vif.HRESETn = HRESETn;
    // Tie HREADY to 1 (always ready)
    ahb_vif.HREADY  = 1;
  end

  // Instantiate the enhanced AHB DUT
  ahb_dut DUT (
    .HCLK    (ahb_vif.HCLK),
    .HRESETn (ahb_vif.HRESETn),
    .HTRANS  (ahb_vif.HTRANS),
    .HADDR   (ahb_vif.HADDR),
    .HWRITE  (ahb_vif.HWRITE),
    .HSIZE   (ahb_vif.HSIZE),
    .HBURST  (ahb_vif.HBURST),
    .HLENGTH (ahb_vif.HLENGTH),
    .HREADY  (ahb_vif.HREADY),
    .HWDATA  (ahb_vif.HWDATA),
    .HRESP   (ahb_vif.HRESP),
    .HRDATA  (ahb_vif.HRDATA)
  );

  // UVM configuration: set the virtual interface then launch the UVM test.
  initial begin
    uvm_config_db#(virtual ahb_if)::set(null, "*", "vif", ahb_vif);
    run_test("ahb_base_test");
  end

endmodule: tb_top