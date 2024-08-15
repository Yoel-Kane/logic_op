`ifndef OP_IN_MONITOR__SV
`define OP_IN_MONITOR__SV
`define MON_VIF vif.mon_cb
class op_in_monitor extends uvm_monitor;

  // UVM Factory Registration Macro
  //
  `uvm_component_utils(op_in_monitor)

  // Virtual Interface
  virtual op_in_if vif;

  //------------------------------------------
  // Data Members (Outputs rand, inputs non-rand)
  //------------------------------------------

  //------------------------------------------
  // Component Members
  //------------------------------------------  
  uvm_analysis_port #(op_in_seq_item) analysis_port;


  //------------------------------------------
  // Methods
  //------------------------------------------

  // Standard UVM Methods:
  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

  // User_defined Methods

endclass: op_in_monitor

function op_in_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  `uvm_info("TRACE",$sformatf("%m"), UVM_HIGH)
endfunction: new

function void op_in_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("TRACE",$sformatf("%m"), UVM_HIGH)
//  uvm_config_db#(int)::get(this, "", "item_count", item_count);

  analysis_port = new("analysis_port", this);
endfunction: build_phase

task op_in_monitor::run_phase(uvm_phase phase);
  op_in_seq_item tr_clone;
  op_in_seq_item tr;
  `uvm_info("TRACE",$sformatf("%m"), UVM_HIGH)

  tr = op_in_seq_item::type_id::create("tr", this);
  forever begin
    while(`MON_VIF.rst_n!==1) begin
      @(`MON_VIF);
    end
    @(`MON_VIF);
    if(`MON_VIF.data_en) begin
      tr.begin_tr(); //tr.begin_time set to the time begin monitor interface
      tr.data1 = `MON_VIF.data1;
      tr.data2 = `MON_VIF.data2;
      tr.end_tr();   //tr.end_time   set to the time end monitor interface and send out
      
      
      `uvm_info("OP_IN_MONITOR_TRANS", {"\n", tr.sprint()}, UVM_MEDIUM)
      $cast(tr_clone, tr.clone);
      analysis_port.write(tr_clone);
    end

  end
endtask: run_phase

`undef MON_VIF
`endif
