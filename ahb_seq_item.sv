import uvm_pkg::*;
import ahb_pkg::*;
`include "uvm_macros.svh"

class ahb_seq_item extends uvm_sequence_item;
  // Transaction fields
  rand htrans_t trans;    // Should be HTRANS_NONSEQ for beginning, then SEQ for burst cycles
  rand bit [31:0] addr;
  rand bit        write;  // 1 = write, 0 = read
  rand bit [2:0]  size;   // Transfer size (e.g., 3'b010 for word)
  rand bit [2:0]  burst;  // 0 for single; nonzero for burst (e.g., 3'b001 for INCR)
  rand bit [7:0]  length; // Burst length in bytes (multiple of 4 for word transfers)
  rand bit [31:0] wdata;  // Write data

  // Constraint: assure address alignment (word aligned for simplicity)
  constraint addr_aligned { addr[1:0] == 2'b00; }

  // Utility function for printing the transaction details.
  function string convert2string();
    return $sformatf("TRANS: %s, ADDR: %0h, WRITE: %0d, SIZE: %0d, BURST: %0d, LENGTH: %0d, WDATA: %0h",
                     trans.name(), addr, write, size, burst, length, wdata);
  endfunction

  // Constructor
  function new(string name = "ahb_seq_item");
    super.new(name);
  endfunction

  `uvm_object_utils(ahb_seq_item)
endclass: ahb_seq_item