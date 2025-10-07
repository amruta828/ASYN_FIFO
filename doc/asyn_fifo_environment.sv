class asyn_fifo_environment extends uvm_env;
  asyn_fifo_read_agent agentr;
  asyn_fifo_write_agent agentw;
  asyn_fifo_scoreboard scoreboard;
  asyn_fifo_subscriber coverage;
    asyn_fifo_virtual_sequencer vseqr;

  `uvm_component_utils(asyn_fifo_environment)
  
  function new(string name="asyn_fifo_environment",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agentr=asyn_fifo_read_agent::type_id::create("agentr",this);
    agentw=asyn_fifo_write_agent::type_id::create("agentw",this);
    scoreboard=asyn_fifo_scoreboard::type_id::create("scoreboard",this);
    coverage=asyn_fifo_subscriber::type_id::create("coverage",this);
     vseqr = asyn_fifo_virtual_sequencer::type_id::create("vseqr",this);
    
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    
    agentr.monitor.mon_read_port.connect(scoreboard.read_sr.analysis_export);
    agentw.monitor.mon_write_port.connect(scoreboard.write_sr.analysis_export);
    agentr.monitor.mon_read_port.connect(coverage.cov_rport.analysis_export);
    agentw.monitor.mon_write_port.connect(coverage.cov_wport.analysis_export);
    
     vseqr.wr_seqr = agentw.sequencer;
    vseqr.rd_seqr = agentr.sequencer;
    
      
      endfunction
      
      endclass
      
