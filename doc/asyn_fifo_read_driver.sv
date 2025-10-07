`include "defines.svh"
class asyn_fifo_read_driver extends uvm_driver#(asyn_fifo_read_sequence_item);
  virtual asyn_fifo_interface vif;
  event read;
  `uvm_component_utils(asyn_fifo_read_driver)


  function new(string name="asyn_fifo_read_driver",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual asyn_fifo_interface)::get(this,"","vif",vif))
      `uvm_fatal("NO_VIF",{"virtual interface must be set for:",get_full_name(),".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    $display("read_driver run phase started");  
    forever 
      begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask

  virtual task drive();
    @(posedge vif.drv_read_cb);
    $display("read_driver drive task started");
  

      vif.drv_read_cb.rinc <= req.rinc;
    
      `uvm_info("RDRV",$sformatf("Driving: RINC=%0b", req.rinc),UVM_NONE);
      req.print();
      endtask

endclass
