package cntrl_seq_pkg;

    import uvm_pkg::*;
    import regs_pkg::*;
    import reg_block_pkg::*;
    `include "uvm_macros.svh"

    class cntrl_seq extends uvm_sequence;

        reg_block    regmodel;
        `uvm_object_utils(cntrl_seq)
        function new(string name = "cntrl_seq");
            super.new(name);
        endfunction

        task body();
            uvm_status_e status;
            bit [31:0] rdata;

            rdata = regmodel.CNTRL.get();
            `uvm_info("CNTRL SEQ", $sformatf("Initial Desired Value : %0d", rdata), UVM_NONE);

            // Set new desired value (does NOT affect hardware yet)
            regmodel.CNTRL.set(32'hA);

            // Get updated desired value from the model (still not hardware)
            rdata = regmodel.CNTRL.get();
            `uvm_info("CNTRL SEQ", $sformatf("Updated Desired Value : %0d", rdata), UVM_NONE);

            // Write the desired value to the actual DUT register
            regmodel.CNTRL.update(status);

            // Frontdoor Read Check
            regmodel.CNTRL.read(status, rdata, UVM_FRONTDOOR);
            `uvm_info("CNTRL SEQ", $sformatf("FRONTDOOR RDATA Value : %0h", rdata), UVM_NONE);
            if (rdata != 32'hA) begin
                `uvm_error("CNTRL_TEST", $sformatf("FRONTDOOR read mismatch! Expected: 'hA, Got: 'h%0h", rdata))
            end else begin
                `uvm_info("CNTRL_TEST", $sformatf("FRONTDOOR read PASSED with value: 'h%0h", rdata), UVM_NONE)
            end

            // Backdoor Access Check
            regmodel.CNTRL.write(status, 32'h5, UVM_BACKDOOR);
            regmodel.CNTRL.read(status, rdata, UVM_BACKDOOR);
            `uvm_info("CNTRL SEQ", $sformatf("BACKDOOR RDATA Value : %0h", rdata), UVM_NONE);
            if (rdata != 32'h5) begin
                `uvm_error("CNTRL_TEST", $sformatf("BACKDOOR read mismatch! Expected: 'h5, Got: 'h%0h", rdata))
            end else begin
                `uvm_info("CNTRL_TEST", $sformatf("BACKDOOR read PASSED with value: 'h%0h", rdata), UVM_NONE)
            end

            // For Coverage
            regmodel.CNTRL.write(status, 32'h0, UVM_FRONTDOOR);
            regmodel.CNTRL.write(status, 32'hf, UVM_FRONTDOOR);
        endtask

    endclass

endpackage