// Generator

class generator;

    transaction            tr;
    mailbox #(transaction) mbx;
    int                    count;
    event                  nextdrv;
    event                  done;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    // Send helper
    task send(transaction t);
        mbx.put(t);
        t.display("GEN");
        @(nextdrv);
    endtask

    // Run
    task run();

        transaction t;

        // ── Directed: first valid address write + read ────────
        t = new(); t.paddr = 32'h0000_0000; t.pwdata = 32'hAAAA_AAAA; t.pwrite = 1; send(t);
        t = new(); t.paddr = 32'h0000_0000; t.pwdata = 32'h0000_0000; t.pwrite = 0; send(t);

        // ── Directed: last valid address write + read ─────────
        t = new(); t.paddr = 32'h0000_007C; t.pwdata = 32'hBBBB_BBBB; t.pwrite = 1; send(t);
        t = new(); t.paddr = 32'h0000_007C; t.pwdata = 32'h0000_0000; t.pwrite = 0; send(t);

        // ── Directed: first invalid address write + read ──────
        t = new(); t.paddr = 32'h0000_0080; t.pwdata = 32'hCCCC_CCCC; t.pwrite = 1; send(t);
        t = new(); t.paddr = 32'h0000_0080; t.pwdata = 32'h0000_0000; t.pwrite = 0; send(t);

        // ── Directed: write then read same address ────────────
        t = new(); t.paddr = 32'h0000_0010; t.pwdata = 32'hDEAD_BEEF; t.pwrite = 1; send(t);
        t = new(); t.paddr = 32'h0000_0010; t.pwdata = 32'h0000_0000; t.pwrite = 0; send(t);

        // ── Directed: overwrite same address, verify latest ───
        t = new(); t.paddr = 32'h0000_0020; t.pwdata = 32'h1111_1111; t.pwrite = 1; send(t);
        t = new(); t.paddr = 32'h0000_0020; t.pwdata = 32'h2222_2222; t.pwrite = 1; send(t);
        t = new(); t.paddr = 32'h0000_0020; t.pwdata = 32'h0000_0000; t.pwrite = 0; send(t);

        // ── Random: fill remaining coverage bins ──────────────
        repeat(count) begin
            tr = new();
            assert(tr.randomize())
            else $fatal(1, "[GEN] RANDOMIZATION FAILED");
            send(tr);
        end

        ->done;
    endtask
endclass
