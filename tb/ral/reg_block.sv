package reg_block_pkg;

    import uvm_pkg::*;
    import regs_pkg::*;
    `include "uvm_macros.svh"

    class reg_block extends uvm_reg_block;

        `uvm_object_utils(reg_block);

        rand cntrl_reg CNTRL;
        rand reg1_reg  reg1;
        rand reg2_reg  reg2;
        rand reg3_reg  reg3;
        rand reg4_reg  reg4;

        function new (string name = "reg_block");
            super.new(name,UVM_NO_COVERAGE);
        endfunction

        virtual function void build();
            uvm_reg::include_coverage ( "*",UVM_CVR_ALL);

            CNTRL = cntrl_reg::type_id::create("CNTRL");
            reg1  = reg1_reg::type_id::create("reg1");
            reg2  = reg2_reg::type_id::create("reg2");
            reg3  = reg3_reg::type_id::create("reg3");
            reg4  = reg4_reg::type_id::create("reg4");

            CNTRL.configure(this); // to make reg block to be parent
            reg1.configure(this); // to make reg block to be parent
            reg2.configure(this); // to make reg block to be parent
            reg3.configure(this); // to make reg block to be parent
            reg4.configure(this); // to make reg block to be parent

            CNTRL.build();
            reg1.build();
            reg2.build();
            reg3.build();
            reg4.build();

            CNTRL.set_coverage(UVM_CVR_FIELD_VALS);
            reg1.set_coverage(UVM_CVR_FIELD_VALS);
            reg2.set_coverage(UVM_CVR_FIELD_VALS);
            reg3.set_coverage(UVM_CVR_FIELD_VALS);
            reg4.set_coverage(UVM_CVR_FIELD_VALS);
            
            add_hdl_path("top.DUT", "RTL");

            ///// For Backdoor Access /////
            CNTRL.add_hdl_path_slice("cntrl", 0, 4);
            reg1.add_hdl_path_slice("reg1", 0, 32);
            reg2.add_hdl_path_slice("reg2", 0, 32);
            reg3.add_hdl_path_slice("reg3", 0, 32);
            reg4.add_hdl_path_slice("reg4", 0, 32);
            ///// For Backdoor Access /////

            default_map = create_map("default_map",0,4,UVM_LITTLE_ENDIAN);
            default_map.add_reg(CNTRL, 32'h0  ,"RW");
            default_map.add_reg(reg1 , 32'h4  ,"RW");
            default_map.add_reg(reg2 , 32'h8  ,"RW");
            default_map.add_reg(reg3 , 32'hc  ,"RW");
            default_map.add_reg(reg4 , 32'h10 ,"RW");

            lock_model();

        endfunction

    endclass

endpackage