class asyn_fifo_virtual_sequence extends uvm_sequence;
  
  asyn_fifo_write_sequence1 wr_seq1;
  asyn_fifo_write_sequence2 wr_seq2;
 
  
  asyn_fifo_read_sequence1 rd_seq1;
  asyn_fifo_read_sequence2 rd_seq2;
 
  
  asyn_fifo_write_sequencer wr_seqr;
  asyn_fifo_read_sequencer rd_seqr;
  
  
  `uvm_object_utils(asyn_fifo_virtual_sequence)
  `uvm_declare_p_sequencer(asyn_fifo_virtual_sequencer)
  
  function new(string name = "asyn_fifo_virtual_seq");
    super.new(name);
  endfunction 
  
  virtual task body();
    wr_seq1 =  asyn_fifo_write_sequence1::type_id::create("wr_Seq1");
   wr_seq2 =  asyn_fifo_write_sequence2::type_id::create("wr_Seq2");
   
    
    rd_seq1 =  asyn_fifo_read_sequence1::type_id::create("rd_seq1");
   rd_seq2 =  asyn_fifo_read_sequence2::type_id::create("rd_seq2");
  
    
    fork
      begin
        wr_seq1.start(p_sequencer.wr_seqr);
        #100;
      end
      begin
        rd_seq1.start(p_sequencer.rd_seqr);
        #100;
      end
    join
    fork
        wr_seq2.start(p_sequencer.wr_seqr);
        rd_seq2.start(p_sequencer.rd_seqr);
    join

  endtask
  
endclass
