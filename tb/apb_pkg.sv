package apb_pkg;

    // 1. Transaction first — everyone depends on it
    `include "transaction.svh"
    
    // 2. Coverage second — monitor depends on it
    `include "coverage.svh"

    // 3. Generator, Driver, Monitor, Scoreboard
    `include "generator.svh"
    `include "driver.svh"
    `include "monitor.svh"
    `include "scoreboard.svh"

    // 4. Environment last — depends on all of the above
    `include "environment.svh"

endpackage
