outfile="figs/chi2.eps"

E139_Sets=  "nE139HED nE139CD nE139BED nE139ALD nE139AGD nE139AUD nE139CAD nE139FED"
EMC_Sets=   "nEMCCAD nEMCCUD nEMCCD nEMCSND"
NMC_Sets=   "nNMCHED nNMCCAD nNMCCD nNMCLID"

E139_Sets_names= "'He/D' 'C/D' 'Be/D' 'Al/D' 'Ag/D' 'Au/D' 'Ca/D' 'Fe/D'"
EMC_Sets_names="'Ca/D' 'Cu/D' 'C/D' 'Sn/D'"
NMC_Sets_names="'He/D' 'Ca/D' 'C/D' 'Li/D'"

E139_Colors="#E55800 #DF0008 #DA0065 #D400BE #8C00CF #3200C9 #00C4BD #0073BF" 
EMC_Colors="#97E500 #D87200 #CB0039 #AC00BF"
NMC_Colors="#7C0FFF #08ADD9 #09B403 #8F6600"

set o outfile
set term post enh col 20 linewidth 1 'Helvetica,12' #size 20,12
set termoption enhanced
save_encoding = GPVAL_ENCODING
set encoding utf8

set xrange[1e-2:1]
set yrange[0.9:1.1]
set logscale x
set logscale y
set bars 1.0

#set format x "10^{%T}"
#set format y "10^{%T}"
set format x "10^{%T}"

set xtics(1e-02 0, ""2e-02 0, ""3e-02 0, ""4e-02 0, ""5e-02 0, ""6e-02 0, ""7e-02 0, ""8e-02 0, ""9e-02 0,\
          1e-01 0, ""2e-01 0, ""3e-01 0, ""4e-01 0, ""5e-01 0, ""6e-01 0, ""7e-01 0, ""8e-01 0, ""9e-01 0,\
          1e+00 0)

#set ytics(0 0, ""1 0, ""2 0, ""3 0, ""4 0, ""5 0, ""6 0, ""7 0, ""8 0, ""9 0,\
          1e01 0, ""2e01 0, ""3e01 0, ""4e01 0, ""5e01 0, ""6e01 0, ""7e01 0, ""8e01 0, ""9e01 0,\
          1e02 0)

set ytics(0.9 0, ""0.91 0, ""0.92 0, ""0.93 0, ""0.94 0, ""0.95 0, ""0.96 0, ""0.97 0, ""0.98 0, ""0.99 0,\
          1.0 0, ""1.01 0, ""1.02 0, ""1.03 0, ""1.04 0, ""1.05 0, ""1.06 0, ""1.07 0, ""1.08 0, ""1.09, 1.1 0)

set grid xtics ytics

set ylabel "Pred/Exp"
set xlabel "x"
set key outside
#set key left top

#set style fill transparent solid 0.5 noborder
#set style circle radius 0.005
#plot for [i=1:words(Sets)] "Kinematics/".word(Sets,i).".dat" u 1:2 with circles lc rgb word(Colors,i) fs solid 1 noborder t word(Sets_names,i), \
#5 7

set arrow 1 lt 8 lc rgb "black" lw 0.1 from 0.01,1 to 1,1 nohead 

plot 0 w p ps 0.0000001 t " {/=18 SLAC}",\
     for [i=1:words(E139_Sets)] "Kinematics/".word(E139_Sets,i).".dat" u 1:($5)/($3) with p ls 5 lc rgb word(E139_Colors,i) t word(E139_Sets_names,i), \
     0 w p ps 0.0000001 t " ", \
     0 w p ps 0.0000001 t " {/=18 EMC}", \
     for [i=1:words(EMC_Sets)] "Kinematics/".word(EMC_Sets,i).".dat" u 1:($5)/($3) with p ls 7 lc rgb word(EMC_Colors,i) t word(EMC_Sets_names,i), \
     0 w p ps 0.0000001 t " ", \
     0 w p ps 0.0000001 t " {/=18 NMC}", \
     for [i=1:words(NMC_Sets)] "Kinematics/".word(NMC_Sets,i).".dat" u 1:($5)/($3) with p pt 11 lc rgb word(NMC_Colors,i) t word(NMC_Sets_names,i)