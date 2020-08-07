`include "uvm_macros.svh"
import uvm_pkg::*;
class item extends uvm_sequence_item;
   logic fifo_full,fifo_empty,err1,err2,err3;
   logic [3:0] data_out;
  rand bit push;
  rand bit pop;
  rand  bit [3:0] data_in;
   // used for registration
  `uvm_object_utils_begin(item)    
  `uvm_field_int(push,UVM_ALL_ON)
  `uvm_field_int(pop,UVM_ALL_ON)
  `uvm_field_int(data_in,UVM_ALL_ON)
  `uvm_field_int(data_out,UVM_ALL_ON)
  `uvm_field_int(fifo_full,UVM_ALL_ON)
  `uvm_field_int(fifo_empty,UVM_ALL_ON)
  `uvm_field_int(err1,UVM_ALL_ON)
  `uvm_field_int(err2,UVM_ALL_ON)
  `uvm_field_int(err3,UVM_ALL_ON)
  `uvm_object_utils_end
  function new(string name="item");
    super.new(name);
  endfunction
  virtual function string convert2str();
    return $sformatf("push=%d,pop=%d,data_in=%d,data_out=%d,fifo_full=%d,fifo_empty=%d,err1=%d,err2=%d,err3=%d",push,pop,data_in,data_out,fifo_full,fifo_empty,err1,err2,err3);
  endfunction
endclass:item
