`include "defines.svh"
 `include "uvm_macros.svh"
  import uvm_pkg::*;
class asyn_fifo_read_sequence_item extends uvm_sequence_item;
           
   
    rand bit rinc, rrst_n; 
  rand bit [`DSIZE-1:0] rdata;      
    bit rempty;  
  
  function new(string name="asyn_fifo_read_sequence_item");
    super.new(name);
  endfunction
  
  `uvm_object_utils_begin(asyn_fifo_read_sequence_item);
  
 
  `uvm_field_int(rinc,UVM_ALL_ON);
  `uvm_field_int(rrst_n,UVM_ALL_ON);
  `uvm_field_int(rdata,UVM_ALL_ON);
  `uvm_field_int(rempty,UVM_ALL_ON);
 
  `uvm_object_utils_end
  
endclass
