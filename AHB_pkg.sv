package ahb_pkg;
  // Define enumeration for AHB transfer types.
  typedef enum logic [1:0] {
    HTRANS_IDLE    = 2'b00,
    HTRANS_BUSY    = 2'b01,
    HTRANS_NONSEQ = 2'b10,
    HTRANS_SEQ    = 2'b11
  } htrans_t;
endpackage: ahb_pkg