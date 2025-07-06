import ahb_pkg::*;

interface ahb_if;
  logic        HCLK;
  logic        HRESETn;
  htrans_t     HTRANS;    // Transfer type defined by our enum
  logic [31:0] HADDR;
  logic        HWRITE;
  logic [2:0]  HSIZE;     // Transfer size (e.g., 3'b010 for word)
  logic [2:0]  HBURST;    // Burst type (e.g., 3'b001 for incrementing burst)
  logic [7:0]  HLENGTH;   // Configurable burst length (in bytes)
  logic        HREADY;
  logic [31:0] HWDATA;
  logic        HRESP;
  logic [31:0] HRDATA;
endinterface: ahb_if