#################################################################################
#Gnuplot script for data/theory comparison                                     #
################################################################################

As="4 6 9 12 27 40 56 64 108 119 197"
if (!exists("reps")) reps=0
if (!exists("fitname")) fitname="needed-as-input via '-e'"

PDFs="Sigma Gluon T8"
PDFs_syms="'$\Sigma$' g T'$_8$'"
colors="red blue #006400"
colors_fit="red blue #006400"
do for [i=1:words(As)] {
outfile="figs/ratio_comparison". word(As, i) .".eps"

#infile="lhapdfGrids/lhapdf". word(PDFs,j) ."_A" . word(As, i) . ".dat"

set o outfile
set term post enh col 20 linewidth 1 'Helvetica,12' #size 20,12
set multiplot layout 1,2

set xrange[0:0.9]
set bars 1.0

set yrange[0.8:1.2]
set xtics(0 0, ""0.1 1, 0.2 0, ""0.3 1, 0.4 0, ""0.5 1, 0.6 0, ""0.7 1, 0.8 0, ""0.9 0)

#set ytics(-2 0, ""-1.5 0, -1 0, ""-0.5 0, 0 0, ""0.5 0, 1 0, ""1.5 0, 2 0, ""2.5 0, 3 0) #font 'Helvetica,14'
set ytics(0.8 0, 0.85 0, 0.9 0, 0.95 0, 1 0, 1.05 0, 1.1 0, 1.15 0, 1.2 0 )
#set label "E_hd^3{/Symbol s}^{h^{/Symbol=\261}}/d^3p^h [mbarn/GeV^2]" at 7.3,2e-2
#set label "{/Symbol=\264}10^{-2}" at 33,2e-10
#set label "{/Symbol=\264}10^{-4}" at 20.5,5e-12
set label "A = ".word(As, i) center at 1,1.3 font 'Helvetica,15'
set label "Level-0 Closure Test" center at 1,1.35 font 'Helvetica,15'
set label "Preliminary, Q_{0} = 1.3 [GeV]" center at 0.03,-0.5 tc rgb"#cccccc"

#set label "|{/Symbol h}|<0.8" at 37.5,6e-5
#set key at 49,3e-1 spacing 1.2

#set for [j=1:words(PDFs)] style line j lt 1 dashtype '-  -' lc rgb word(colors,j) lw 3
set linetype 9 dashtype '-'
set linetype 8 dashtype '.'

#--- to plot the central value of lhapdfgrids
#for [j=1:words(PDFs)] "lhapdfGrids/lhapdf". word(PDFs,j) ."_A" . word(As, i) . ".dat" u 1:2 lt 9 lc rgb word(colors,j) lw 3 with lines notitle #ls j notitle #line lc rgb word(colors,j) lt 2 lw 4 

#Panel1
set tmargin at screen 0.9
set bmargin at screen 0.45
set lmargin at screen 0.03
set rmargin at screen 0.48

set label "F_{2}^{LO} Ratio" center at 0.45,1.22 font 'Helvetica,15'
set xlabel "x"
#set ylabel "g(x,A)"

#set arrow 1 lt 8 lc rgb "black" lw 0.1 from 0,1 to 0.9,1 nohead 

##Gluon
#plot for [j=0:0] "kin_coverage/x_A". word(As, i) . ".dat" u 1:(-1):(0):(5) with vectors lw 0.05 lc rgb "red" nohead notitle,\
     \
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/". word(PDFs,2) ."_A". word(As, i) . ".dat lhapdfGrids/lhapdf". word(PDFs,2) ."_A" . word(As, i) . ".dat" u 1:($2-$3)/($5):($2+$3)/($5) with filledcu fs transparent pattern 5 lc rgb word(colors_fit,2) lt 3 lw 3 t "nNNPDF1.0",\
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/". word(PDFs,2) ."_A". word(As, i) . ".dat lhapdfGrids/lhapdf". word(PDFs,2) ."_A" . word(As, i) . ".dat" u 1:($2-$3)/($5) lt 1 lc rgb word(colors_fit,2) lw 1 with lines notitle,\
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/". word(PDFs,2) ."_A". word(As, i) . ".dat lhapdfGrids/lhapdf". word(PDFs,2) ."_A" . word(As, i) . ".dat" u 1:($2+$3)/($5) lt 1 lc rgb word(colors_fit,2) lw 1 with lines notitle,\
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/". word(PDFs,2) ."_A". word(As, i) . ".dat lhapdfGrids/lhapdf". word(PDFs,2) ."_A" . word(As, i) . ".dat" u 1:($2)/($5) lt 1 lc rgb word(colors_fit,2) lw 3 with lines notitle,\

plot "lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($3/$2):($4/$2) with filledcu fs transparent solid 0.3 noborder lc rgb "#8A2BE2" lt 3 lw 3 t "EPPS16",\
     "lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($2/$2) lt 8 lc rgb "#8A2BE2" lw 3 with lines notitle,\
     for [j=0:0] "kin_coverage/x_A". word(As, i) . ".dat" u 1:(-1):(0):(5) with vectors lw 0.05 lc rgb "red" nohead notitle,\
     \
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/SigmaT8_A". word(As, i) . ".dat lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($2-$3)/($6):($2+$3)/($6) with filledcu fs transparent pattern 5 lc rgb "#8A2BE2" lt 3 lw 3 t "nNNPDF1.0",\
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/SigmaT8_A". word(As, i) . ".dat lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($2-$3)/($6) lt 1 lc rgb "#8A2BE2" lw 1 with lines notitle,\
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/SigmaT8_A". word(As, i) . ".dat lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($2+$3)/($6) lt 1 lc rgb "#8A2BE2" lw 1 with lines notitle,\
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/SigmaT8_A". word(As, i) . ".dat lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($2)/($6) lt 1 lc rgb "#8A2BE2" lw 3 with lines notitle,\

#Panel2
unset label
unset xtics
unset xrange 

set xrange[1e-3:1]
set logscale x
set tmargin at screen 0.9
set bmargin at screen 0.45
set lmargin at screen 0.53
set rmargin at screen 0.97
set arrow 1 lt 8 lc rgb "black" lw 0.1 from 1e-3,1 to 1,1 nohead 

set label  "F_{2}^{LO} Ratio" center at 0.03,1.22 font 'Helvetica,15'
#set ylabel "[{/Symbol=\123} + 1/4 T_{8}](x,A)"
set label "Preliminary, Q_{0} = 1.3 [GeV]" center at 0.03,-0.5 tc rgb"#cccccc"
set xlabel "x"

set xtics(1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
          1e+00 0) #font 'Helvetica,36'

plot "lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($3/$2):($4/$2) with filledcu fs transparent solid 0.3 noborder lc rgb "#8A2BE2" lt 3 lw 3 t "EPPS16",\
     "lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($2/$2) lt 8 lc rgb "#8A2BE2" lw 3 with lines notitle,\
     \
     for [j=0:0] "kin_coverage/x_A". word(As, i) . ".dat" u 1:(-1):(0):(5) with vectors lw 0.05 lc rgb "red" nohead notitle,\
     \
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/SigmaT8_A". word(As, i) . ".dat lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($2-$3)/($6):($2+$3)/($6) with filledcu fs transparent pattern 5 lc rgb "#8A2BE2" lt 3 lw 3 t "nNNPDF1.0",\
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/SigmaT8_A". word(As, i) . ".dat lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($2-$3)/($6) lt 1 lc rgb "#8A2BE2" lw 1 with lines notitle,\
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/SigmaT8_A". word(As, i) . ".dat lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($2+$3)/($6) lt 1 lc rgb "#8A2BE2" lw 1 with lines notitle,\
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/SigmaT8_A". word(As, i) . ".dat lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($2)/($6) lt 1 lc rgb "#8A2BE2" lw 3 with lines notitle,\


unset label
unset logscale y
unset logscale x
unset xrange
unset ytics
unset format
unset multiplot
unset output
#pause 1
}