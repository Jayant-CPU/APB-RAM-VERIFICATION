// Environment

class environment;

    generator  gen;
    driver     drv;
    monitor    mon;
    scoreboard sco;
    coverage   cov;

    mailbox #(transaction) gdmbx;   // generator - driver
    mailbox #(transaction) msmbx;   // monitor - scoreboard

    event nextgd;

    virtual abp_if vif;

    function new(virtual abp_if vif);
        this.vif = vif;

        gdmbx = new();
        msmbx = new();

        gen = new(gdmbx);
        drv = new(gdmbx);
        mon = new(msmbx);
        sco = new(msmbx);
        cov = new();

        drv.vif = vif;
        mon.vif = vif;
        mon.cov = cov;

        gen.nextdrv = nextgd;
        drv.nextdrv = nextgd;
    endfunction

    task pre_test();
        drv.reset();
    endtask

    task test();
        fork
            gen.run();
            drv.run();
            mon.run();
            sco.run();
        join_none
    endtask

    task post_test();
        wait(gen.done.triggered);
        repeat(5) @(posedge vif.PCLK);

        cov.report();

        $display("============================================================");
        $display("  SCOREBOARD SUMMARY                                        ");
        $display("============================================================");
        $display("  Total Passed : %0d", sco.pass);
        $display("  Total Failed : %0d", sco.err);
        $display("------------------------------------------------------------");
        if (sco.err == 0)
            $display("  Status       : ** ALL TESTS PASSED **                  ");
        else
            $display("  Status       : ** FAILED **                            ");
        $display("============================================================");
        $display("");
        $display("  [%0t ns] SIMULATION ENDED                                ", $time);
        $display("============================================================");
        $display("");
        $finish();
    endtask

    task run();
        pre_test();
        test();
        post_test();
    endtask

endclass
