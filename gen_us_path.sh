#!/bin/bash

print_main_md_input()
{
cat > pmd.in  << EOF
equil-MD: 10ps MD with NVT ensemble at 300K at 1g/cm3
&cntrl
 imin = 0, irest = 1, ntx = 5,
 ntb = 1, ntp = 0,
 ifqnt = 1,
 iwrap  = 1,
 cut = 8.0, ntr = 0,
 ntc = 2, ntf = 2,
 nmropt = 0,
 tempi = 300.0, temp0 = 300.0,
 ntt = 3, gamma_ln = 1.0,
 nstlim = 10000, dt = 0.001,
 ntpr = 10, ntwx = 10, ntwr = 10
/

&qmmm
 qmmask=':2-4,6,8,20,25,26',
 qmcharge=-2,
 qm_theory='PM6',
 qmshake=0,
 qm_ewald=1, qm_pme=1
/
EOF
}

print_pmd_input()
{
cat >> pmd.in << EOF
ncsu_pmd
  output_file = 'pmd.txt'
  output_freq = 50

  variable
    type = LCAO
    i = (36,37,4,37)
    r = (1.0, -1.0)
    anchor_position = "$1"
    anchor_strength = 50.0
  end variable
end ncsu_pmd
EOF
}

create_input()
{
    # must avoid furth dashing
    mkdir -p "./$1"
    cd "./$1"
    print_main_md_input
    print_pmd_input "$1"
    cd ../
}

clean_input()
{
    rm -rf "./$1"
}

cv_lo=-0.97
cv_hi=2.03
cv_step=0.1
opt="$1"

cv_path=($(seq $cv_lo $cv_step $cv_hi))

for ((i=0;i<${#cv_path[@]};i++))
do
    case "$opt" in
    "create")
	create_input "${cv_path[$i]}"
	;;
    "clean")
	clean_input "${cv_path[$i]}"
	;;
    *) echo "unknown options"
	;;
    esac
done
