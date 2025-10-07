class asyn_fifo_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(asyn_fifo_scoreboard)
  
  asyn_fifo_write_sequence_item write_seq;
  asyn_fifo_read_sequence_item  read_seq;
  uvm_tlm_analysis_fifo #( asyn_fifo_write_sequence_item) write_sr;
  uvm_tlm_analysis_fifo #( asyn_fifo_read_sequence_item )  read_sr;
  bit [7:0] q[$];  
  bit [7:0] exp; 
  int depth = 16; 

  function new(string name = "asyn_fifo_scoreboard", uvm_component parent);    
    super.new(name, parent);
  endfunction
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    read_sr = new("read_sr", this);
    write_sr = new("write_sr", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin 
      write_sr.get(write_seq);
      read_sr.get(read_seq);
      
      sco(write_seq, read_seq);
    end
  endtask 
  
  task sco(asyn_fifo_write_sequence_item write,
           asyn_fifo_read_sequence_item  read); 
    if (write.winc) begin
      if (q.size() == depth) begin
        if (!write.wfull)
          `uvm_error("SCOREBOARD", "FIFO full but DUT did NOT assert wfull")
        else
          `uvm_info("SCOREBOARD", "WRITE blocked (FIFO full as expected)", UVM_LOW);
      end
      q.push_back(write.wdata);
      `uvm_info("SCOREBOARD", $sformatf("WRITE: Stored %0d (size=%0d)",write.wdata, q.size()), UVM_MEDIUM);
      end
    if (read.rinc) begin
      if (q.size() == 0) begin
        if (!read.rempty)
          `uvm_error("SCOREBOARD", "FIFO empty but DUT did NOT assert rempty")
        else
          `uvm_info("SCOREBOARD", "READ blocked (FIFO empty as expected)", UVM_LOW);
      end

      exp = q.pop_front();
        if (exp != read.rdata)
          `uvm_error("SCOREBOARD",
                     $sformatf("DATA MISMATCH: Expected %0d, Got %0d",
                               exp, read.rdata))
        else
          `uvm_info("SCOREBOARD",
                    $sformatf("match: Got %0d (size=%0d)",
                              read.rdata, q.size()), UVM_MEDIUM);
      
    end
  endtask
endclass

 

