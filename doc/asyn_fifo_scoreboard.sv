class asyn_fifo_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(asyn_fifo_scoreboard)

 
  uvm_tlm_analysis_fifo#(asyn_fifo_read_sequence_item) sco_read_port;
  uvm_tlm_analysis_fifo#(asyn_fifo_write_sequence_item) sco_write_port;


  asyn_fifo_read_sequence_item rseq;
  asyn_fifo_write_sequence_item wseq;


  bit [7:0] w_fifo[$];
  bit [7:0] r_fifo[$];

  int depth = 16;

  function new(string name="asyn_fifo_scoreboard", uvm_component parent);
    super.new(name,parent);
    sco_read_port = new("sco_read_port", this);
    sco_write_port = new("sco_write_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    fork
      
      forever begin
  sco_write_port.get(wseq);
  
  if (wseq.winc == 1) begin
    if (w_fifo.size() == depth) begin
      if (!wseq.wfull) begin
        `uvm_error("SCOREBOARD", "DUT did not assert wfull when FIFO is full");
      end 
      else begin
        `uvm_info("SCOREBOARD", "WRITE blocked due to FIFO full (as expected)", UVM_LOW);
      end
    end 
    else begin
      w_fifo.push_back(wseq.wdata);
      `uvm_info("SCOREBOARD", $sformatf("Collected WDATA = %0d size=%0d", wseq.wdata, w_fifo.size()), UVM_LOW);
    end
  end

  compare_if_possible();
end

     
      forever begin
        sco_read_port.get(rseq);
        if(rseq.rinc==1)
        if (r_fifo.size() == 0) begin
          if (!rseq.rempty) begin
            `uvm_error("SCOREBOARD", "DUT did not assert rempty when FIFO is empty");
          end
           else begin
            `uvm_info("SCOREBOARD", "READ blocked due to FIFO empty (as expected)", UVM_LOW);
        end 
      end
        else begin
          r_fifo.push_back(rseq.rdata);
          `uvm_info("SCOREBOARD", $sformatf("Collected RDATA = %0d", rseq.rdata), UVM_LOW);
        end

        compare_if_possible();
      end
    join_none
  endtask

  task compare_if_possible();
    while (w_fifo.size() > 0 && r_fifo.size() > 0) begin
      bit [7:0] wdata = w_fifo.pop_front();
      bit [7:0] rdata = r_fifo.pop_front();

      if (wdata === rdata) begin
        `uvm_info("SCOREBOARD", $sformatf("MATCH: wdata=%0d, rdata=%0d ", wdata, rdata), UVM_LOW);
      end else begin
        `uvm_error("SCOREBOARD", $sformatf("MISMATCH: wdata=%0d, rdata=%0d", wdata, rdata));
      end
    end
  endtask
endclass


