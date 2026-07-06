// Testbench Top

`include "interface.sv"
`include "apb_pkg.sv"

module tb_top;
  	
  	import apb_pkg::*; 

    abp_if vif();

    apb_ram dut (
        .PRESETn (vif.PRESETn),
        .PCLK    (vif.PCLK),
        .PSEL    (vif.PSEL),
        .PENABLE (vif.PENABLE),
        .PWRITE  (vif.PWRITE),
        .PADDR   (vif.PADDR),
        .PWDATA  (vif.PWDATA),
        .PRDATA  (vif.PRDATA),
        .PREADY  (vif.PREADY),
        .PSLVERR (vif.PSLVERR)
    );

    initial vif.PCLK = 1'b0;
    always #10 vif.PCLK = ~vif.PCLK;

    environment env;

    initial begin
        env           = new(vif);
        env.gen.count = 50;
        env.run();
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule
