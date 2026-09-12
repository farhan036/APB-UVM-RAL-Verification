package regs_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class cntrl_reg extends uvm_reg;
        `uvm_object_utils(cntrl_reg)

        rand uvm_reg_field CTRL0;
        rand uvm_reg_field CTRL1;
        rand uvm_reg_field CTRL2;
        rand uvm_reg_field CTRL3;
        rand uvm_reg_field F_Reserved;

        
        covergroup cntrl_cov;

            cp_ctrl0: coverpoint CTRL0.value 
            {
                bins zero = {0};
                bins one  = {1};
            }

            cp_ctrl1: coverpoint CTRL1.value 
            {
                bins zero = {0};
                bins one  = {1};
            }

            cp_ctrl2: coverpoint CTRL2.value 
            {
                bins zero = {0};
                bins one  = {1};
            }

            cp_ctrl3: coverpoint CTRL3.value 
            {
                bins zero = {0};
                bins one  = {1};
            }

        endgroup
        

        function new (string name = "cntrl_reg");
            super.new(name,32,UVM_CVR_FIELD_VALS);

            if(has_coverage(UVM_CVR_FIELD_VALS))
            cntrl_cov = new();

        endfunction

        virtual function void build();
            CTRL0 = uvm_reg_field::type_id::create("CTRL0");    
            CTRL1 = uvm_reg_field::type_id::create("CTRL1");   
            CTRL2 = uvm_reg_field::type_id::create("CTRL2");   
            CTRL3 = uvm_reg_field::type_id::create("CTRL3");   
            F_Reserved = uvm_reg_field::type_id::create("F_Reserved");

            CTRL0.configure(this,1,0,"RW",0,0,1,1,1);    
            CTRL1.configure(this,1,1,"RW",0,0,1,1,1);    
            CTRL2.configure(this,1,2,"RW",0,0,1,1,1);    
            CTRL3.configure(this,1,3,"RW",0,0,1,1,1);    
            F_Reserved.configure(this,28,4,"RO",0,0,1,1,1);    

        endfunction

        virtual function void sample
        (
            uvm_reg_data_t data,
            uvm_reg_data_t byte_en,
            bit is_read,
            uvm_reg_map map
        );
            cntrl_cov.sample();
        endfunction

        endclass

        class reg1_reg extends uvm_reg;

            `uvm_object_utils(reg1_reg)
            rand uvm_reg_field data;

            covergroup reg1_cov;
                coverpoint data.value[31:0] 
                {
                    bins lower = {[0:63]};
                    bins mid   = {[64:127]};
                    bins high  = {[128:255]};
                }
                
            endgroup

            function new(string name = "REG1");
                super.new(name, 32, UVM_CVR_FIELD_VALS);

                if(has_coverage(UVM_CVR_FIELD_VALS))
                    reg1_cov = new();
            endfunction

            virtual function void build();
                data = uvm_reg_field::type_id::create("data");

                data.configure(
                    this,
                    32,        // size
                    0,         // lsb_pos
                    "RW",      // access
                    0,         // volatile
                    32'h0,     // reset
                    1,         // has_reset
                    1,         // is_rand
                    0          // individually_accessible
                );
            endfunction

            virtual function void sample
            (
                uvm_reg_data_t data,
                uvm_reg_data_t byte_en,
                bit is_read,
                uvm_reg_map map
            );
            reg1_cov.sample();
        endfunction

        endclass
        class reg2_reg extends uvm_reg;

            `uvm_object_utils(reg2_reg)
            rand uvm_reg_field data;

            covergroup reg2_cov;
                coverpoint data.value[31:0] 
                {
                    bins lower = {[0:63]};
                    bins mid   = {[64:127]};
                    bins high  = {[128:255]};
                }
                
            endgroup

            function new(string name = "REG2");
                super.new(name, 32, UVM_CVR_FIELD_VALS);

                if(has_coverage(UVM_CVR_FIELD_VALS))
                    reg2_cov = new();
            endfunction

            virtual function void build();
                data = uvm_reg_field::type_id::create("data");

                data.configure(
                    this,
                    32,        // size
                    0,         // lsb_pos
                    "RW",      // access
                    0,         // volatile
                    32'h0,     // reset
                    1,         // has_reset
                    1,         // is_rand
                    0          // individually_accessible
                );
            endfunction

            virtual function void sample
            (
                uvm_reg_data_t data,
                uvm_reg_data_t byte_en,
                bit is_read,
                uvm_reg_map map
            );
            reg2_cov.sample();
        endfunction

        endclass

        
        class reg3_reg extends uvm_reg;

            `uvm_object_utils(reg3_reg)
            rand uvm_reg_field data;

            covergroup reg3_cov;
                coverpoint data.value[31:0] 
                {
                    bins lower = {[0:63]};
                    bins mid   = {[64:127]};
                    bins high  = {[128:255]};
                }
                
            endgroup

            function new(string name = "REG3");
                super.new(name, 32, UVM_CVR_FIELD_VALS);

                if(has_coverage(UVM_CVR_FIELD_VALS))
                    reg3_cov = new();
            endfunction

            virtual function void build();
                data = uvm_reg_field::type_id::create("data");

                data.configure(
                    this,
                    32,        // size
                    0,         // lsb_pos
                    "RW",      // access
                    0,         // volatile
                    32'h0,     // reset
                    1,         // has_reset
                    1,         // is_rand
                    0          // individually_accessible
                );
            endfunction

            virtual function void sample
            (
                uvm_reg_data_t data,
                uvm_reg_data_t byte_en,
                bit is_read,
                uvm_reg_map map
            );
            reg3_cov.sample();
        endfunction

        endclass
        class reg4_reg extends uvm_reg;

            `uvm_object_utils(reg4_reg)
            rand uvm_reg_field data;

            covergroup reg4_cov;
                coverpoint data.value[31:0] 
                {
                    bins lower = {[0:63]};
                    bins mid   = {[64:127]};
                    bins high  = {[128:255]};
                }
                
            endgroup

            function new(string name = "REG4");
                super.new(name, 32, UVM_CVR_FIELD_VALS);

                if(has_coverage(UVM_CVR_FIELD_VALS))
                    reg4_cov = new();
            endfunction

            virtual function void build();
                data = uvm_reg_field::type_id::create("data");

                data.configure(
                    this,
                    32,        // size
                    0,         // lsb_pos
                    "RW",      // access
                    0,         // volatile
                    32'h0,     // reset
                    1,         // has_reset
                    1,         // is_rand
                    0          // individually_accessible
                );
            endfunction

            virtual function void sample
            (
                uvm_reg_data_t data,
                uvm_reg_data_t byte_en,
                bit is_read,
                uvm_reg_map map
            );
            reg4_cov.sample();
        endfunction

        endclass
        

endpackage