`include "defines.svh"
class asyn_fifo_write_driver extends uvm_driver#(asyn_fifo_write_sequence_item);
  virtual asyn_fifo_interface vif;
  event write;
  
  `uvm_component_utils(asyn_fifo_write_driver)


  function new(string name="asyn_fifo_write_driver",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual asyn_fifo_interface)::get(this,"","vif",vif))
      `uvm_fatal("NO_VIF",{"virtual interface must be set for:",get_full_name(),".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    $display("write_driver run phase started");
    forever 
      begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask

  virtual task drive();
    $display("write_driver drive task started");

      @(posedge vif.drv_write_cb);
      vif.drv_write_cb.winc  <= req.winc;
      vif.drv_write_cb.wdata  <= req.wdata;
    
    `uvm_info("WDRV",$sformatf("Driving: WINC=%0b, WDATA=%0d", req.winc, req.wdata),UVM_NONE);
      req.print();

  endtask

endclass
