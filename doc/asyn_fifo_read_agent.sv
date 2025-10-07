class asyn_fifo_read_agent extends uvm_agent;
  asyn_fifo_read_driver driver;
  asyn_fifo_read_monitor monitor;
  asyn_fifo_read_sequencer sequencer;
  
  `uvm_component_utils(asyn_fifo_read_agent)
  
  function new(string name="asyn_fifo_read_agent",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(get_is_active()== UVM_ACTIVE)
      begin
    driver=asyn_fifo_read_driver::type_id::create("driver",this);
    sequencer=asyn_fifo_read_sequencer::type_id::create("sequencer",this);
      end
     monitor=asyn_fifo_read_monitor::type_id::create("monitor",this);
    
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    if(get_is_active()== UVM_ACTIVE)
      begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
      end
  endfunction
  
endclass
