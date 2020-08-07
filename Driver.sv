`define DRIV_MAC vif.DRIVER.drv
class driver extends uvm_driver #(item);
  `uvm_component_utils(driver)
  function new(string name = "driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction
virtual inf vif;
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  if (!uvm_config_db#(virtual inf)::get(this, "", "vir_intf", vif))
      `uvm_fatal("DRV", "Could not get vif")
  endfunction
virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever 
     begin
      item m_item;
       `uvm_info("DRV", $sformatf("Wait for item from sequencer"), UVM_LOW)
      seq_item_port.get_next_item(m_item);
      drive_item(m_item);
       `uvm_info("DRV", $sformatf("Transfered to Dut"), UVM_LOW)
      seq_item_port.item_done();
    end
endtask
virtual task reset;
      wait (vif.reset);
    $display("%d:reset starts of driver",$time);
      `DRIV_MAC.push<=0;
      `DRIV_MAC.pop<=0;
      `DRIV_MAC.data_in<=0;
  wait (vif.reset==0);
    $display("%d:reset done of driver",$time);
endtask:reset
  virtual task drive_item(item m_item);
  @(posedge vif.clk);
  $display("%d:driver enters in posedge",$time,vif.clk);
        begin
             `DRIV_MAC.data_in<=m_item.data_in;
             `DRIV_MAC.push<=m_item.push;  
             `DRIV_MAC.pop<=m_item.pop;
          `uvm_info("DRV", $sformatf("D=%d,p=%d,pop=%d",m_item.data_in,m_item.push,m_item.pop), UVM_LOW)
          
        end
endtask:drive_item
endclass:driver
