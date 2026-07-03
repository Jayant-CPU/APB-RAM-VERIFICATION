// Coverage Report

class coverage;

    logic [31:0] paddr;
    logic        pwrite;
    logic        pslverr;
    logic        pready;

    covergroup apb_cg;

        cp_pwrite : coverpoint pwrite {
            bins write_op = {1};
            bins read_op  = {0};
        }

        cp_addr_range : coverpoint paddr {
            bins valid_low  = { [32'h0000_0000 : 32'h0000_003C] };
            bins valid_high = { [32'h0000_0040 : 32'h0000_007C] };
            bins invalid    = { [32'h0000_0080 : 32'h0000_00FF] };
        }

        cp_addr_boundary : coverpoint paddr {
            bins first_valid   = { 32'h0000_0000 };
            bins last_valid    = { 32'h0000_007C };
            bins first_invalid = { 32'h0000_0080 };
        }

        cp_pslverr : coverpoint pslverr {
            bins no_error = {0};
            bins error    = {1};
        }

        cp_pready : coverpoint pready {
            bins ready = {1};
        }

        cx_op_range    : cross cp_pwrite, cp_addr_range;
        cx_op_boundary : cross cp_pwrite, cp_addr_boundary;
        cx_err_op      : cross cp_pslverr, cp_pwrite;

    endgroup

    function new();
        apb_cg = new();
    endfunction

    function void sample(transaction tr);
        paddr   = tr.paddr;
        pwrite  = tr.pwrite;
        pslverr = tr.pslverr;
        pready  = tr.pready;
        apb_cg.sample();
    endfunction

    function void report();
        $display("");
        $display("============================================================");
        $display("  FUNCTIONAL COVERAGE REPORT                                ");
        $display("============================================================");
        $display("  %-25s : %0.2f%%", "cp_pwrite",        apb_cg.cp_pwrite.get_coverage());
        $display("  %-25s : %0.2f%%", "cp_addr_range",    apb_cg.cp_addr_range.get_coverage());
        $display("  %-25s : %0.2f%%", "cp_addr_boundary", apb_cg.cp_addr_boundary.get_coverage());
        $display("  %-25s : %0.2f%%", "cp_pslverr",       apb_cg.cp_pslverr.get_coverage());
        $display("  %-25s : %0.2f%%", "cp_pready",        apb_cg.cp_pready.get_coverage());
        $display("  %-25s : %0.2f%%", "cx_op_range",      apb_cg.cx_op_range.get_coverage());
        $display("  %-25s : %0.2f%%", "cx_op_boundary",   apb_cg.cx_op_boundary.get_coverage());
        $display("  %-25s : %0.2f%%", "cx_err_op",        apb_cg.cx_err_op.get_coverage());
        $display("------------------------------------------------------------");
        $display("  %-25s : %0.2f%%", "TOTAL COVERAGE",   apb_cg.get_coverage());
        $display("============================================================");
        $display("");
    endfunction

endclass
