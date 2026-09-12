package my_test_pkg;

import uvm_pkg::*;
import cntrl_seq_pkg::*;
import reg1_seq_pkg::*;
import reg2_seq_pkg::*;
import reg3_seq_pkg::*;
import reg4_seq_pkg::*;
`include "uvm_macros.svh"

import my_env_pkg::*;


`define create(type , inst_name)  type::type_id::create(inst_name,this); // This is a macro to save the much code into small one for constructing


class my_test extends uvm_test;
  `uvm_component_utils(my_test)


  my_env  env;


  function new (string name = "my_test" , uvm_component parent = null);
	super.new(name , parent);
  endfunction


  function void build_phase(uvm_phase phase);
  	super.build_phase(phase);
	
      env = `create(my_env , "env");
      `uvm_info("MY_TEST" , "TEST BUILT" , UVM_LOW);
	  
    endfunction




  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction


  task run_phase(uvm_phase phase);

      cntrl_seq ctrl_seq;
      reg1_seq  reg1_seq_h;
      reg2_seq  reg2_seq_h;
      reg3_seq  reg3_seq_h;
      reg4_seq  reg4_seq_h;

      phase.raise_objection(this);

      ctrl_seq = cntrl_seq::type_id::create("ctrl_seq");
      reg1_seq_h = reg1_seq::type_id::create("reg1_seq_h");
      reg2_seq_h = reg2_seq::type_id::create("reg2_seq_h");
      reg3_seq_h = reg3_seq::type_id::create("reg3_seq_h");
      reg4_seq_h = reg4_seq::type_id::create("reg4_seq_h");

      // Give the RAL sequence access to the register model
      ctrl_seq.regmodel = env.regmodel;
      `uvm_info("CNTRL RUN TEST", "TEST HERE", UVM_LOW)
      ctrl_seq.start(null);

      reg1_seq_h.regmodel = env.regmodel;
      `uvm_info("REG 1 RUN TEST", "TEST HERE", UVM_LOW)
      reg1_seq_h.start(null);

      reg2_seq_h.regmodel = env.regmodel;
      `uvm_info("REG 2 RUN TEST", "TEST HERE", UVM_LOW)
      reg2_seq_h.start(null);

      reg3_seq_h.regmodel = env.regmodel;
      `uvm_info("REG 3 RUN TEST", "TEST HERE", UVM_LOW)
      reg3_seq_h.start(null);

      reg4_seq_h.regmodel = env.regmodel;
      `uvm_info("REG 4 RUN TEST", "TEST HERE", UVM_LOW)
      reg4_seq_h.start(null);


      phase.drop_objection(this);

  endtask 

endclass

endpackage
