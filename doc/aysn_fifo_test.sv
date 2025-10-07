class asyn_fifo_test extends uvm_test;
  `uvm_component_utils(asyn_fifo_test)
  asyn_fifo_environment env;
  asyn_fifo_virtual_sequence vseq;
  
  function new(string name="asyn_fifo_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env=asyn_fifo_environment::type_id::create("env",this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
     
    super.run_phase(phase);
    phase.raise_objection(this);
    
    vseq=asyn_fifo_virtual_sequence::type_id::create("vseq");
   
    repeat(1) begin
      vseq.start(env.vseqr);
    end
    phase.drop_objection(this);
  endtask
endclass
