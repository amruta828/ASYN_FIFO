`include "defines.svh"
class asyn_fifo_subscriber extends uvm_component;


  `uvm_component_utils(asyn_fifo_subscriber)

  uvm_tlm_analysis_fifo#(asyn_fifo_write_sequence_item)cov_wport;
  uvm_tlm_analysis_fifo#(asyn_fifo_read_sequence_item)cov_rport;

  asyn_fifo_write_sequence_item w_seq;
asyn_fifo_read_sequence_item r_seq;


real cov_wreport,cov_rreport;

covergroup w_cg;
  WDATA: coverpoint w_seq.wdata{ bins wdata_vals[]={[0:(1<<`DSIZE-1)]};}
WINC  : coverpoint w_seq.winc  { bins inc[] = {0,1}; }
    WRST  : coverpoint w_seq.wrst_n { bins rst[] = {0,1}; }
     WFULL  : coverpoint w_seq.wfull { bins full[] = {0,1}; }
   
//     cross WINC, WRST;
//     cross RINC, RRST;
  endgroup
  
  covergroup r_cg;
    RDATA  : coverpoint r_seq.rdata { bins rdata_vals[] = {[0:(1<<`DSIZE)-1]}; }
    RINC  : coverpoint r_seq.rinc  { bins rinc[] = {0,1}; }
    RRST  : coverpoint r_seq.rrst_n { bins rrst[] = {0,1}; }
    REMPTY : coverpoint r_seq.rempty { bins empty[] = {0,1}; }
    //cross RDATA, REMPTY;
    
  endgroup
  
  function new(string name="asyn_fifo_subscriber",uvm_component parent);
    super.new(name,parent);
    cov_wport=new("cov_wport",this);
    cov_rport=new("cov_rport",this);
    w_cg=new;
    r_cg=new;
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      cov_wport.get(w_seq);
      cov_rport.get(r_seq);
      w_cg.sample();
      r_cg.sample();
    end
  endtask
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov_wreport=w_cg.get_coverage();
    cov_rreport=r_cg.get_coverage();
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),$sformatf("[W_MONITOR] coverage--%0.2f%%  [R_MONITOR] coverage--%0.2f%%",cov_wreport,cov_rreport),UVM_LOW);
  endfunction
  
endclass
