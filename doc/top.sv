`include "uvm_pkg.sv"
`include "uvm_macros.svh"
`include "asyn_fifo_pkg.sv"
`include "asyn_fifo_interface.sv"
`include "design.sv"

module top;
  
  import uvm_pkg::*;
  import asyn_fifo_pkg::*;
  
  bit wclk,rclk,wrst_n,rrst_n;
  
  always #5 wclk = ~wclk;
  
  always #10 rclk = ~rclk;
    
    initial begin
      wclk=0;rclk=0;wrst_n=0;rrst_n=0;
     #10 rrst_n = 1;
        wrst_n = 1;
  
      end

    
    asyn_fifo_interface intf(wclk,rclk,wrst_n,rrst_n);
  
  FIFO dut( .rdata(intf.rdata),
           .wfull(intf.wfull),
           .rempty(intf.rempty),
           .wdata(intf.wdata),
           .winc(intf.winc),
           .wclk(wclk),
           .wrst_n(wrst_n),
           .rinc(intf.rinc),
           .rclk(rclk),
           .rrst_n(rrst_n));
  
  
  initial begin
    uvm_config_db#(virtual asyn_fifo_interface)::set(null,"*","vif",intf);
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  initial begin
    run_test("asyn_fifo_test");
    #10000 $finish;
  end
  
endmodule
    
