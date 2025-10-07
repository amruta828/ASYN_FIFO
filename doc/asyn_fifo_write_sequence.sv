class asyn_fifo_write_sequence1 extends uvm_sequence #(asyn_fifo_write_sequence_item);
  
  `uvm_object_utils(asyn_fifo_write_sequence1)
  
  function new(string name = "asyn_fifo_write_sequence1");
    super.new(name);
  endfunction 
  
  virtual task body();
    repeat(17)begin
    req = asyn_fifo_write_sequence_item::type_id::create("req");
      `uvm_rand_send_with(req,{winc == 1;})
    end
  endtask
endclass

class asyn_fifo_write_sequence2 extends uvm_sequence #(asyn_fifo_write_sequence_item);
  
  `uvm_object_utils(asyn_fifo_write_sequence2)
  
  function new(string name = "asyn_fifo_write_sequence2");
    super.new(name);
  endfunction 
  
  virtual task body();
    req = asyn_fifo_write_sequence_item::type_id::create("req");
    `uvm_rand_send_with(req,{winc == 0;})
  endtask
endclass
