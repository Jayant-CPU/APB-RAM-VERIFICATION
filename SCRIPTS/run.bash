#!/bin/bash

echo "======================================"
echo " Running APB Verification (Questa) "
echo "======================================"

# Clean old files
rm -rf work transcript vsim.wlf covhtmlreport modelsim.ini

# Create library
vlib work

# Compile
vlog -sv \
     -f filelist.f

# Optimize
vopt tb -o tb_opt +acc

# Run simulation
vsim -c tb_opt \
     -coverage \
     -do "run -all; coverage save apb_cov.ucdb; quit -f"

echo "======================================"
echo " Simulation Completed"
echo "======================================"
