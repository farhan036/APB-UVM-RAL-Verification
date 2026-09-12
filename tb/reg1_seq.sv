package reg1_seq_pkg;

    import uvm_pkg::*;
    import regs_pkg::*;
    import reg_block_pkg::*;
    `include "uvm_macros.svh"

    class reg1_seq extends uvm_sequence;

        reg_block    regmodel;
        `uvm_object_utils(reg1_seq)
        function new(string name = "reg1_seq");
            super.new(name);
        endfunction

        task body();
            uvm_status_e status;
            bit [31:0] rdata;

            rdata = regmodel.reg1.get();
            `uvm_info("REG1 SEQ ", $sformatf("Initial Desired Value : %0d", rdata), UVM_NONE);

            // Set new desired value (does NOT affect hardware yet)
            regmodel.reg1.set(32'hAA);

            // Get updated desired value from the model (still not hardware)
            rdata = regmodel.reg1.get();
            `uvm_info("REG1 SEQ", $sformatf("Updated Desired Value : %0d", rdata), UVM_NONE);

            // Write the desired value to the actual DUT register
            regmodel.reg1.update(status);

            // Frontdoor Read Check
            regmodel.reg1.read(status, rdata, UVM_FRONTDOOR);
            `uvm_info("REG1 SEQ", $sformatf("FRONTDOOR RDATA Value : %0h", rdata), UVM_NONE);
            if (rdata != 32'hAA) begin
                `uvm_error("REG1_TEST", $sformatf("FRONTDOOR read mismatch! Expected: 'hAA, Got: 'h%0h", rdata))
            end else begin
                `uvm_info("REG1_TEST", $sformatf("FRONTDOOR read PASSED with value: 'h%0h", rdata), UVM_NONE)
            end

            // Backdoor Access Check
            regmodel.reg1.write(status, 32'h55, UVM_BACKDOOR);
            regmodel.reg1.read(status, rdata, UVM_BACKDOOR);
            `uvm_info("REG1 SEQ", $sformatf("BACKDOOR RDATA Value : %0h", rdata), UVM_NONE);
            if (rdata != 32'h55) begin
                `uvm_error("REG1_TEST", $sformatf("BACKDOOR read mismatch! Expected: 'h55, Got: 'h%0h", rdata))
            end else begin
                `uvm_info("REG1_TEST", $sformatf("BACKDOOR read PASSED with value: 'h%0h", rdata), UVM_NONE)
            end

            //For Coverage
            regmodel.reg1.write(status, 32'h20, UVM_FRONTDOOR); // lower
            regmodel.reg1.write(status, 32'h55, UVM_FRONTDOOR); // mid
            regmodel.reg1.write(status, 32'hAA, UVM_FRONTDOOR); // high
        endtask

    endclass

endpackage