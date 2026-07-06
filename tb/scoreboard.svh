// Scoreboard

class scoreboard;

    mailbox #(transaction) mbx;
    transaction            tr;
    logic [31:0]           ref_mem [0:31];
    int                    err;
    int                    pass;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
        foreach(ref_mem[i])
            ref_mem[i] = 32'd0;
        err  = 0;
        pass = 0;
    endfunction

    // Run
    task run();
        forever begin
            mbx.get(tr);

            $display("------------------------------------------------------------");
            tr.display("SCO");

            // INVALID ADDRESS
            if ((tr.paddr >= 32'd128) || (tr.paddr[1:0] != 2'b00)) begin
                if (tr.pslverr) begin
                    pass++;
                    $display("[%0t ns] [SCO] PASS  | PSLVERR correctly asserted    | ADDR: 0x%08h |",
                              $time, tr.paddr);
                end
                else begin
                    err++;
                    $display("[%0t ns] [SCO] FAIL  | PSLVERR expected but missing  | ADDR: 0x%08h |",
                              $time, tr.paddr);
                end
            end

            // WRITE
            else if (tr.pwrite) begin
                ref_mem[tr.paddr[6:2]] = tr.pwdata;
                pass++;
                $display("[%0t ns] [SCO] WRITE | OK | ADDR: 0x%08h | DATA: 0x%08h |",
                          $time, tr.paddr, tr.pwdata);
            end

            // READ
            else begin
                if (tr.prdata === ref_mem[tr.paddr[6:2]]) begin
                    pass++;
                    $display("[%0t ns] [SCO] READ  | MATCH | ADDR: 0x%08h | GOT:  0x%08h |",
                              $time, tr.paddr, tr.prdata);
                end
                else begin
                    err++;
                    $display("[%0t ns] [SCO] READ  | MISMATCH  | ADDR: 0x%08h | GOT:  0x%08h | EXP: 0x%08h |",
                              $time, tr.paddr, tr.prdata, ref_mem[tr.paddr[6:2]]);
                end
            end

            $display("------------------------------------------------------------");
            $display("");
        end
    endtask
endclass
