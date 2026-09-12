package my_env_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import my_agent_pkg::* ;
import my_sequence_item_pkg::*;
import my_scoreboard_pkg::*;
import reg_block_pkg::*;
import apb_adapter_pkg::*;


  `define create(type , inst_name)  type::type_id::create(inst_name,this);  // CREATE() HERE REPLACES THE CONSTRUCTION LINE LARGE CODE LIKE A TEXT REPLACEMENT

  class my_env extends uvm_env;
    `uvm_component_utils(my_env)


    my_agent   agent;
    my_scoreboard sco;
    reg_block    regmodel;
    uvm_reg_predictor #(my_sequence_item) predictor;
    apb_adapter  adapter;


      function new (string name = "my_env" , uvm_component parent = null);
        super.new(name , parent);
      endfunction

      
      function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("MY_ENV" , "ENVIRONMENT BUILT" , UVM_LOW);     
        agent     = `create(my_agent,"agent");       //HERE WE USED THE MACRO INSTEAD OF LARGE CODE WHICH DEFINED ABOVE
        sco       = `create(my_scoreboard,"sco");
        regmodel  = `create(reg_block,"regmodel");
        adapter   = `create(apb_adapter,"adapter");
        predictor = uvm_reg_predictor#(my_sequence_item)::type_id::create("predictor", this);
        regmodel.build();
        regmodel.lock_model();

      endfunction


      function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        regmodel.default_map.set_sequencer(agent.seqr, adapter);
        agent.mon.mon_ap.connect(predictor.bus_in);
        predictor.map = regmodel.default_map;
        predictor.adapter = adapter;

        agent.mon.mon_ap.connect(sco.sco_ap);
      endfunction
    
  endclass


endpackage