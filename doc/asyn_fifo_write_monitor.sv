class asyn_fifo_write_monitor extends uvm_monitor;
  virtual asyn_fifo_interface vif;
  asyn_fifo_write_sequence_item trans;
  
  uvm_analysis_port#(asyn_fifo_write_sequence_item) mon_write_port;

  `uvm_component_utils(asyn_fifo_write_monitor)

  function new(string name="asyn_fifo_write_monitor",uvm_component parent);
    super.new(name,parent);
    mon_write_port = new("mon_write_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual asyn_fifo_interface)::get(this,"","vif",vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for:",get_full_name(),".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    $display("write_monitor run phase started");
    forever begin
      
      repeat(2)@(vif.mon_write_cb);
      trans = asyn_fifo_write_sequence_item::type_id::create("trans");
      trans.winc  = vif.mon_write_cb.winc;
      trans.wdata = vif.mon_write_cb.wdata;
      trans.wfull = vif.mon_write_cb.wfull;

     // repeat(2) @(vif.mon_write_cb);

      `uvm_info("WMON",$sformatf("MONITOR Captured: WINC=%0b, WDATA=%0d, wfull=%0b", 
                 trans.winc, trans.wdata, trans.wfull),UVM_NONE);
      mon_write_port.write(trans);
    end
  endtask

endclass

