// APB Interface

interface abp_if;

    logic PRESETn;
    logic PCLK;

    logic PSEL;
    logic PENABLE;
    logic PWRITE;

    logic [31:0] PADDR;
    logic [31:0] PWDATA;

    logic [31:0] PRDATA;

    logic PREADY;
    logic PSLVERR;

endinterface
