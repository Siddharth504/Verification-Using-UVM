class gen_seq extends uvm_sequence;
  `uvm_object_utils(gen_seq)
  function new(string name="gen_seq");
    super.new(name);
  endfunction
  int repeat_count;
  virtual task body();
    for (int i = 0; i < repeat_count;i ++)
      begin
    	item m_item = item::type_id::create("m_item");
    	start_item(m_item);
    	m_item.randomize();
       
        `uvm_info("SEQ", $sformatf("Generate new item: %s", m_item.convert2str()), UVM_LOW)
      	finish_item(m_item);
    end
    `uvm_info("SEQ", $sformatf("Done generation of %d items", repeat_count), UVM_LOW)
  endtask
endclass:gen_seq
