outfile="figs/kinematics.eps"

SLAC_Sets=  "nSLACHED nSLACCD nSLACBED nSLACALD nSLACAGD nSLACAUD nSLACCAD nSLACFED"
EMC_Sets=   "nEMCCAD nEMCCD nEMCCUD nEMCFED nEMCSND"
NMC_Sets=   "nNMCCAD nNMCCD nNMCHED nNMCLID"
FNAL_Sets= "nFNALCAD nFNALCD nFNALPBD"
BCDMS_Sets= "nBCDMSFED nBCDMSND"

SLAC_Sets_names= "'He/D' 'C/D' 'Be/D' 'Al/D' 'Ag/D' 'Au/D' 'Ca/D' 'Fe/D'"
EMC_Sets_names="'Ca/D' 'C/D' 'Cu/D' 'Fe/D' 'Sn/D'"
NMC_Sets_names="'Ca/D' 'C/D' 'He/D' 'Li/D'"
FNAL_Sets_names= "'Ca/D' 'C/D' 'Pb/D'"
BCDMS_Sets_names= "'Fe/D' 'Sn/D'"

SLAC_Colors="#E55800 #DF0008 #DA0065 #D400BE #8C00CF #3200C9 #00C4BD #0073BF" 
EMC_Colors="#97E500 #D87200 #CB0039 #0073BF #AC00BF"
NMC_Colors="#7C0FFF #08ADD9 #09B403 #8F6600"
FNAL_Colors="#E55800 #DF0008 #DA0065"
BCDMS_Colors="#E55800 #DF0008"

set o outfile
set term post enh col 20 linewidth 1 'Helvetica,12' #size 20,12
set termoption enhanced
save_encoding = GPVAL_ENCODING
set encoding utf8

xmin = 1e-2
xmax = 1
q2min = 1
q2max = 200

set xrange[xmin:xmax]
set yrange[q2min:q2max]
set logscale x
set logscale y
set bars 1.0

#set format x "10^{%T}"
set format y "10^{%T}"
set format x "10^{%T}"

set xtics(1e-02 0, ""2e-02 0, ""3e-02 0, ""4e-02 0, ""5e-02 0, ""6e-02 0, ""7e-02 0, ""8e-02 0, ""9e-02 0,\
          1e-01 0, ""2e-01 0, ""3e-01 0, ""4e-01 0, ""5e-01 0, ""6e-01 0, ""7e-01 0, ""8e-01 0, ""9e-01 0,\
          1e+00 0)

set ytics(0 0, 1 0, ""2 0, ""3 0, ""4 0, ""5 0, ""6 0, ""7 0, ""8 0, ""9 0,\
          1e01 0, ""2e01 0, ""3e01 0, ""4e01 0, ""5e01 0, ""6e01 0, ""7e01 0, ""8e01 0, ""9e01 0,\
          1e02 0)

set grid xtics ytics

set ylabel "Q^{2} [GeV^{2}]" offset 0,-4,0 font 'Helvetica,20'
set xlabel "x" font 'Helvetica,20'
set key outside
#set key left top

#set style fill transparent solid 0.5 noborder
#set style circle radius 0.005
#plot for [i=1:words(Sets)] "Kinematics/".word(Sets,i).".dat" u 1:2 with circles lc rgb word(Colors,i) fs solid 1 noborder t word(Sets_names,i), \
#5 7

#Q2 cut
q2cut=1.69
w2cut=0

set arrow 1 lt '-' lc rgb "black" lw 5 from xmin,q2cut to xmax,q2cut nohead

plot 0 w p ps 0.0000001 t " {/=18 SLAC}",\
     for [i=1:words(SLAC_Sets)] "kinematics/".word(SLAC_Sets,i).".dat" u 1:2 with p ls 5 lc rgb word(SLAC_Colors,i) t word(SLAC_Sets_names,i),\
     0 w p ps 0.0000001 t " ",\
     0 w p ps 0.0000001 t " {/=18 EMC}",\
     for [i=1:words(EMC_Sets)] "kinematics/".word(EMC_Sets,i).".dat" u 1:2 with p ls 7 lc rgb word(EMC_Colors,i) t word(EMC_Sets_names,i),\
     0 w p ps 0.0000001 t " ",\
     0 w p ps 0.0000001 t " {/=18 NMC}",\
     for [i=1:words(NMC_Sets)] "kinematics/".word(NMC_Sets,i).".dat" u 1:2 with p pt 11 lc rgb word(NMC_Colors,i) t word(NMC_Sets_names,i),\
     0 w p ps 0.0000001 t " ",\
     0 w p ps 0.0000001 t " {/=18 FNAL}",\
     for [i=1:words(FNAL_Sets)] "kinematics/".word(FNAL_Sets,i).".dat" u 1:2 with p pt 15 lc rgb word(FNAL_Colors,i) t word(FNAL_Sets_names,i),\
     0 w p ps 0.0000001 t " ",\
     0 w p ps 0.0000001 t " {/=18 BCDMS}",\
     for [i=1:words(BCDMS_Sets)] "kinematics/".word(BCDMS_Sets,i).".dat" u 1:2 with p pt 19 lc rgb word(BCDMS_Colors,i) t word(BCDMS_Sets_names,i),\
     w2cut*x/(1-x) lt '-' lw 5 notitle