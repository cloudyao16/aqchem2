#!/bin/bash

# exit on error
set -e
# turn on command echoing
set -v
# make sure that the current directory is the one where this script is
cd ${0%/*}
# make the output directory if it doesn't exist
mkdir -p out

../../partmc run_part_drydep.spec
../../partmc run_exact_drydep.spec

../../extract_aero_size --num --dmin 1e-9 --dmax 1e-3 --nbin 160 out/loss_part_drydep_0001
../../extract_sectional_aero_size --num out/loss_exact_drydep

../../numeric_diff --by col --rel-tol 0.1 out/loss_exact_drydep_aero_size_num.txt out/loss_part_drydep_0001_aero_size_num.txt
