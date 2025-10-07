class asyn_fifo_virtual_sequencer extends uvm_sequencer;
  
  `uvm_component_utils(asyn_fifo_virtual_sequencer)
  
  asyn_fifo_write_sequencer wr_seqr;
  asyn_fifo_read_sequencer rd_seqr;
  
  function new(string name = "asyn_fifo_virtual_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction 
  
endclass
