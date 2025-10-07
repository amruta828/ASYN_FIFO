`include "defines.svh"
interface asyn_fifo_interface( input bit  wclk,rclk,wrst_n,rrst_n);
 
  logic [`DSIZE-1:0] wdata;        
    logic winc;    
    logic rinc; 
  logic [`DSIZE-1:0] rdata;      
    logic wfull;         
    logic rempty;  

  clocking drv_read_cb @(posedge rclk);
    default input #0 output #0;
    output rinc;
  endclocking

  clocking mon_read_cb @(posedge rclk);
    default input #0 output #0;
    input rdata,rempty,rinc;
   
  endclocking

  clocking drv_write_cb @(posedge wclk);
    default input #0 output #0;
    output winc,wdata;
  endclocking

  clocking mon_write_cb @(posedge wclk);
    default input #0 output #0;
    input wdata,wfull,winc;
   
  endclocking

  modport DRV_READ(clocking drv_read_cb);
  modport MON_READ(clocking mon_read_cb);
  modport DRV_WRITE(clocking drv_write_cb);
  modport MON_WRITE(clocking mon_write_cb);



property p1;
    @(posedge wclk) disable iff(!wrst_n)
      (winc && wfull) |-> $stable(wdata);
  endproperty
    assert property(p1)
    $info("data stable p1");
    else $error("p2 FAILED");

  property p2;
    @(posedge rclk) disable iff(!rrst_n)
      rinc |-> !rempty;
  endproperty
      assert property(p2)
    $info("rempty high");
    
    else $error("p3 FAILED");

  
  property p3;
    @(posedge wclk) disable iff(!wrst_n)
      !(wfull && rempty);
  endproperty
    assert property(p3)
      $info("p3 passed");
      else $error("p3 FAILED");
    
endinterface
