interface inf(input logic clk,input logic reset);
  logic [3:0] data_in, data_out;
  logic push,pop,fifo_full,fifo_empty,err1,err2,err3;
  //clocking block for driver
  clocking drv @(posedge clk);
   // default output #1;
    output push,data_in,pop;
    //input fifo_empty,fifo_full,data_out,err1,err2,err3;
  endclocking: drv
    //clocking block for monitor
  clocking mon @(posedge clk);
    default input #0;
    input  push,pop,data_in,data_out,fifo_empty,fifo_full,err1,err2,
    err3;
  endclocking: mon
  modport DRIVER (clocking drv,input clk,reset);
  modport MONITOR(clocking mon,input clk,reset);
endinterface:inf
