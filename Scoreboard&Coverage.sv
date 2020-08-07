class scoreboard extends uvm_scoreboard;
  bit pred_push;
  bit pred_pop;
  logic [3:0] pred_data_in;  
  logic [3:0] pred_data_out;
  bit pred_fifo_full;
  bit pred_fifo_empty;
  bit pred_err1;
  bit pred_err2;
  bit pred_err3;
  int q[$];
  virtual inf vif;
  uvm_analysis_imp #(item, scoreboard) m_analysis_imp;
covergroup covport;
  coverpoint pred_pop; 
  coverpoint pred_push ;
  coverpoint pred_data_in;    
  coverpoint pred_fifo_full;
  coverpoint pred_fifo_empty;
  coverpoint pred_err1;
  coverpoint pred_err2;
  coverpoint pred_err3;
endgroup
  `uvm_component_utils(scoreboard)
  function new(string name="scoreboard", uvm_component parent=null);
    super.new(name, parent);
     covport=new;
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual inf)::get(this, "", "vir_intf", vif))
      `uvm_fatal("SCB", "Could not get vif")
    m_analysis_imp = new("m_analysis_imp", this);
  endfunction
virtual task reset;
    wait(vif.reset);
    $display("%d:scoreboard reset starts",$time);
    pred_data_in=0;
    pred_data_out=0;
    pred_fifo_full=0;
    pred_fifo_empty=0;
      wait(!vif.reset);
    $display("%d:scoreboard reset ends",$time);
endtask:reset
  virtual function write(item m_item);
    `uvm_info("SCBD", $sformatf("Entered in SCBD"), UVM_LOW)
    pred_pop=m_item.pop;
    pred_push=m_item.push;
    pred_data_in=m_item.data_in;
   if(m_item.push&&m_item.pop==1)
           begin
            pred_err1=1;
             if(m_item.push&&pred_fifo_full)
              pred_err2=1;
            else
              pred_err2=0;
             if(m_item.pop&&pred_fifo_empty)
                pred_err3=1;
            else
                pred_err3=0;
             compare(m_item);
           end
     else
           begin
              pred_err1=0;
             if(m_item.push&&pred_fifo_full)
                begin
                  pred_err2=1; 
                end
             else
               begin
                 pred_err2=0; 
                 if(m_item.push==1)
                   begin
                     q.push_front(m_item.data_in);
                   end 
               end
             if(m_item.pop&&pred_fifo_empty)
                begin
                  pred_err3=1;
                end
              else
                begin
                  pred_err3=0;
                  if(m_item.pop==1)
                    begin
                       pred_data_out=q.pop_back();
                    end
                end
          if (q.size==4)
            pred_fifo_full=1;
          else
            pred_fifo_full=0;
          if (q.size==0)
            pred_fifo_empty=1;
          else
            pred_fifo_empty=0;
             compare(m_item);
       end
endfunction:write
virtual function compare(item m_item);
  `uvm_info("SCBD", $sformatf("Entered in SCBD-Compare"), UVM_LOW)
   begin
     if (pred_data_out==m_item.data_out)
       `uvm_info("SCBD",$sformatf("pred_data_out=%d ,actual data_out=%d",pred_data_out, m_item.data_out), UVM_LOW)
     else
       `uvm_error("SCBD",$sformatf("pred_data_out=%d ,actual data_out=%d",pred_data_out, m_item.data_out))
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       if (pred_fifo_full!=m_item.fifo_full)
            `uvm_error("SCBD",$sformatf("predicted fifo full signal=%d ,actual fifo full signal=%d",pred_fifo_full, m_item.fifo_full))
     else
            `uvm_info("SCBD",$sformatf("predicted fifo full signal=%d ,actual fifo full signal=%d",pred_fifo_full, m_item.fifo_full), UVM_LOW)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       if (pred_fifo_empty!=m_item.fifo_empty)
       `uvm_error("SCBD",$sformatf("predicted fifo empty signal=%d ,actual fifo empty signal=%d",pred_fifo_empty, m_item.fifo_empty))
     else
       `uvm_info("SCBD",$sformatf("predicted fifo empty signal=%d ,actual fifo empty signal=%d",pred_fifo_empty, m_item.fifo_empty), UVM_LOW)  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       if(pred_err1==m_item.err1)
       `uvm_info("SCBD",$sformatf("Corner case satisfied when push and pop are simultaneously on predicted error signal =%d,actual error signal =%d",pred_err1,m_item.err1),UVM_LOW)
     else
              `uvm_error("SCBD",$sformatf("Error in corner case  when push and pop simultaneously on err1 is not high:- predicted error signal =%d,actual error signal =%d",pred_err1,m_item.err1))
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       if(pred_err2==m_item.err2)
       `uvm_info("SCBD",$sformatf("corner case satisfied :- push is given when fifo is full:-predicted error signal =%d,actual error signal =%d",pred_err2,m_item.err2),UVM_LOW)
            else
              `uvm_error("SCBD",$sformatf("Error in corner case :- push is given when fifo is full but Err2 is not high:-predicted error signal =%d,actual error signal =%d",pred_err2,m_item.err2))
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              if(pred_err3==m_item.err3)
            `uvm_info("SCBD",$sformatf("corner case satisfy to check :-pop is given when fifo is empty:-predicted error signal =%d,actual error signal =%d",pred_err3,m_item.err3),UVM_LOW)
            else
              `uvm_error("SCBD",$sformatf("Error in corner case :- pop is given when fifo is empty but Err3 is not high predicted error signal =%d,actual error signal =%d",pred_err3,m_item.err3))
    covport.sample();
    coverage; //$display("%d:push=%d,pop=%d,data_in=%d,fifofull=%d,fifoempty=%d,err1=%d,err2=%d,err3=%d",$time,tr.push,tr.pop,tr.data_in,pred_fifo_full,pred_fifo_empty,pred_err1,pred_err2,pred_err3);
   end       
 endfunction:compare
  virtual function coverage;
    `uvm_info("SCBD", $sformatf("Entered in SCBD-Coverage"), UVM_LOW)
    begin
      $display("Coverage Report =%0.2f",covport.get_inst_coverage());
    end
  endfunction:coverage
endclass:scoreboard
