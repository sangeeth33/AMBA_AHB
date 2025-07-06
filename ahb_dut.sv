`timescale 1ns/1ps
import ahb_pkg::*;

module ahb_dut (
  input  logic        HCLK,
  input  logic        HRESETn,
  input  htrans_t     HTRANS,   // Enum for transfer type
  input  logic [31:0] HADDR,
  input  logic        HWRITE,
  input  logic [2:0]  HSIZE,    // Transfer size (e.g., 3'b010 = word)
  input  logic [2:0]  HBURST,   // Burst type (incrementing burst)
  input  logic [7:0]  HLENGTH,  // **Configurable burst length**
  input  logic        HREADY,
  input  logic [31:0] HWDATA,
  output logic        HRESP,
  output logic [31:0] HRDATA
);

  // Simple memory model – 256 words (1024 bytes)
  logic [31:0] mem [0:255];  
  int burst_count;
  logic burst_active;
  logic [31:0] burst_addr;

  always_ff @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
      HRESP        <= 1'b0;
      HRDATA       <= '0;
      burst_active <= 1'b0;
      burst_count  <= 0;
      burst_addr   <= '0;
      // Set initial state to NONSEQ on reset
      HTRANS       <= HTRANS_NONSEQ;
    end else if (HREADY) begin
      case (HTRANS)
        // Single transaction (NONSEQ)
        HTRANS_NONSEQ: begin
          burst_active <= (HBURST != 3'b000);  // Activate burst if burst type is nonzero
          burst_count  <= (HBURST != 3'b000) ? (HLENGTH / 4) : 0;
          burst_addr   <= HADDR;

          if (HWRITE)
            mem[HADDR[7:0] >> 2] <= HWDATA;  // Write operation
          else
            HRDATA <= mem[HADDR[7:0] >> 2];   // Read operation
          HRESP <= 1'b0;  // OK response

          // If burst enabled, transition to SEQ state for additional cycles
          if (burst_active) HTRANS <= HTRANS_SEQ;
        end

        // Burst transaction cycles (SEQ)
        HTRANS_SEQ: begin
          if (burst_active) begin
            if (burst_count > 0) begin
              burst_count <= burst_count - 1;
              burst_addr  <= burst_addr + 4;  // Increment to next word address

              if (HWRITE)
                mem[burst_addr[7:0] >> 2] <= HWDATA;  // Burst write
              else
                HRDATA <= mem[burst_addr[7:0] >> 2];   // Burst read
              HRESP <= 1'b0;  // Valid response

              // End burst when count reaches 1
              if (burst_count == 1)
                HTRANS <= HTRANS_NONSEQ;
            end else begin
              HRESP <= 1'b1;  // Error: burst overrun
            end
          end else begin
            HRESP <= 1'b1;  // Error: SEQ without valid NONSEQ start
          end
        end

        default: begin
          HRESP <= 1'b1;  // Error for any invalid transaction type
        end
      endcase
    end
  end

endmodule