package apb_adapter_pkg;

    import uvm_pkg::*;
    import my_sequence_item_pkg::*;
    `include "uvm_macros.svh"
    class apb_adapter extends uvm_reg_adapter;

        `uvm_object_utils(apb_adapter)
        function new(string name = "apb_adapter");
            super.new(name);
            supports_byte_enable = 0;
            provides_responses    = 1;
        endfunction    
        
        virtual function uvm_sequence_item reg2bus (const ref uvm_reg_bus_op rw ) ;
            my_sequence_item tr;
            tr = my_sequence_item::type_id::create("tr");
            tr.paddr   = rw.addr;
            tr.pwdata  = rw.data;
            tr.pwrite  = (rw.kind == UVM_WRITE);

            return tr;
        endfunction  
        virtual function void bus2reg (uvm_sequence_item bus_item , ref uvm_reg_bus_op rw ) ;
            my_sequence_item tr;
            if(!$cast(tr,bus_item))
            begin
                `uvm_fatal("APB_ADAPTER", "bus_item is not an apb_seq_item")
                return;    
            end
            
            rw.addr   = tr.paddr;
            rw.kind  = tr.pwrite ? UVM_WRITE : UVM_READ;
            if (tr.pwrite)
                rw.data = tr.pwdata;
            else
                rw.data = tr.prdata;

            rw.status = UVM_IS_OK;
        endfunction  

    endclass



endpackage