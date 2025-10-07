class asyn_fifo_read_monitor extends uvm_monitor;
  virtual asyn_fifo_interface vif;
  asyn_fifo_read_sequence_item trans;
  

  uvm_analysis_port#(asyn_fifo_read_sequence_item) mon_read_port;

  `uvm_component_utils(asyn_fifo_read_monitor)

  function new(string name="asyn_fifo_read_monitor",uvm_component parent);
    super.new(name,parent);
    mon_read_port = new("mon_read_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual asyn_fifo_interface)::get(this,"","vif",vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for:",get_full_name(),".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    $display("read_monitor run phase started");
    forever begin
      repeat(2)@(vif.mon_read_cb);

      trans = asyn_fifo_read_sequence_item::type_id::create("trans");
      trans.rinc  = vif.mon_read_cb.rinc;
      trans.rdata = vif.mon_read_cb.rdata;
           // repeat(2)@(vif.mon_read_cb);

     
      `uvm_info("RMON",$sformatf("MONITOR Captured: RINC=%0b, RDATA=%0d ", 
                 trans.rinc, trans.rdata ),UVM_NONE);
      mon_read_port.write(trans);
    end
  endtask

endclass
