// Driver 

class driver;

    virtual abp_if         vif;
    mailbox #(transaction) mbx;
    transaction            tr;
    event                  nextdrv;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    // Reset
    task reset();
        vif.PRESETn <= 1'b0;
        vif.PSEL    <= 1'b0;
        vif.PENABLE <= 1'b0;
        vif.PWRITE  <= 1'b0;
        vif.PADDR   <= 32'd0;
        vif.PWDATA  <= 32'd0;
        repeat(5) @(posedge vif.PCLK);
        vif.PRESETn <= 1'b1;
        $display("");
        $display("============================================================");
        $display("  [%0t ns] [DRV] RESET COMPLETE - DUT is ready             ", $time);
        $display("============================================================");
        $display("");
    endtask

    // Drive Transfer
    task drive_transfer(transaction t);

        // SETUP
        @(posedge vif.PCLK);
        vif.PSEL    <= 1'b1;
        vif.PENABLE <= 1'b0;
        vif.PADDR   <= t.paddr;
        vif.PWRITE  <= t.pwrite;
        vif.PWDATA  <= (t.pwrite) ? t.pwdata : 32'd0;

        // ACCESS
        @(posedge vif.PCLK);
        vif.PENABLE <= 1'b1;

        // Wait for PREADY
        @(posedge vif.PCLK);
        while (!vif.PREADY) @(posedge vif.PCLK);

        // Capture outputs
        if (!t.pwrite)
            t.prdata = vif.PRDATA;
        t.pslverr = vif.PSLVERR;

        t.display("DRV");

        // Deassert
        @(posedge vif.PCLK);
        vif.PSEL    <= 1'b0;
        vif.PENABLE <= 1'b0;
        vif.PWRITE  <= 1'b0;

        ->nextdrv;

    endtask

    // Run
    task run();
        forever begin
            mbx.get(tr);
            drive_transfer(tr);
        end
    endtask

endclass
