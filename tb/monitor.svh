// Monitor

class monitor;

    virtual abp_if         vif;
    mailbox #(transaction) mbx;
    coverage               cov;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    // Run
    task run();
        transaction tr;

        forever begin
            @(posedge vif.PCLK);

            if (vif.PSEL && vif.PENABLE && vif.PREADY) begin

                tr         = new();
                tr.paddr   = vif.PADDR;
                tr.pwrite  = vif.PWRITE;
                tr.pwdata  = vif.PWDATA;
                tr.pslverr = vif.PSLVERR;
                tr.pready  = vif.PREADY;

                if (!vif.PWRITE)
                    tr.prdata = vif.PRDATA;
                else
                    tr.prdata = 32'd0;

                tr.display("MON");

                // Sample into persistent coverage instance
                cov.sample(tr);

                mbx.put(tr);

                wait (!vif.PSEL);

            end
        end
    endtask
endclass
