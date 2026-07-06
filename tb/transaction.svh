// Transaction

class transaction;

    rand logic [31:0] paddr;
    rand logic [31:0] pwdata;
    randc logic       pwrite;

    logic [31:0]      prdata;
    logic             pready;
    logic             pslverr;

    constraint addr_c {
        paddr[1:0] == 2'b00;
        paddr dist {
            [32'h0000_0000 : 32'h0000_007C] := 80,
            [32'h0000_0080 : 32'h0000_00FF] := 20
        };
    }

    function void display(string tag);
        $display("[%0t ns] [%-3s] | ADDR: 0x%08h | DATA_W: 0x%08h | DATA_R: 0x%08h | PWRITE: %0b | PSLVERR: %0b |",
                 $time, tag, paddr, pwdata, prdata, pwrite, pslverr);
    endfunction

endclass
