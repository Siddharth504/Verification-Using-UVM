 `define MON_MAC vif.MONITOR.mon
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  function new(string name="monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  uvm_analysis_port  #(item) mon_analysis_port;
virtual inf vif;
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  if (!uvm_config_db#(virtual inf)::get(this, "", "vir_intf", vif))
      `uvm_fatal("MON", "Could not get vif")
    mon_analysis_port = new ("mon_analysis_port", this);
endfunction
virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever 
      begin
        item m_item = item::type_id::create("m_item");
        @(posedge vif.clk);  
				#1;
                 m_item.push=`MON_MAC.push;
                 m_item.pop=`MON_MAC.pop;
                 m_item.fifo_full=`MON_MAC.fifo_full;
                 m_item.fifo_empty=`MON_MAC.fifo_empty;
                 m_item.data_out=`MON_MAC.data_out;
                 m_item.data_in=`MON_MAC.data_in;
                 m_item.err1=`MON_MAC.err1;
                 m_item.err2=`MON_MAC.err2;
                 m_item.err3=`MON_MAC.err3;
        `uvm_info("MON", $sformatf("Received item %s", m_item.convert2str()), UVM_LOW)
        mon_analysis_port.write(m_item);
	   end
  endtask
endclass:monitor
