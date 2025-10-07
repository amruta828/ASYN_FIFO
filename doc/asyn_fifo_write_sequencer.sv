class asyn_fifo_write_sequencer extends uvm_sequencer#(asyn_fifo_write_sequence_item);
  `uvm_component_utils(asyn_fifo_write_sequencer)
  
  function new(string name ="asyn_fifo_write_sequencer",uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass
