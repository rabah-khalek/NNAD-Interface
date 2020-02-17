#################################################################################
#Gnuplot script for data/theory comparison                                     #
################################################################################
#As="12 64 119"
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
set multiplot layout 1,3
set logscale x
set xrange[1e-3:1]
set bars 1.0

set yrange[-1:3]

set xtics(""1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          ""1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
          ""1e+00 0)

set ytics(-2 0, ""-1.5 0, -1 0, ""-0.5 0, 0 0, ""0.5 0, 1 0, ""1.5 0, 2 0, ""2.5 0, 3 0) #font 'Helvetica,14'

#
#
#




#
#set key at 49,3e-1 spacing 1.2

#set for [j=1:words(PDFs)] style line j lt 1 dashtype '-  -' lc rgb word(colors,j) lw 3
set linetype 9 dashtype '-'
set linetype 8 dashtype '.'

#--- to plot the central value of lhapdfgrids
#for [j=1:words(PDFs)] "lhapdfGrids/lhapdf". word(PDFs,j) ."_A" . word(As, i) . ".dat" u 1:2 lt 9 lc rgb word(colors,j) lw 3 with lines notitle #ls j notitle #line lc rgb word(colors,j) lt 2 lw 4 
#Panel1
set tmargin at screen 0.95
set bmargin at screen 0.5
set lmargin at screen 0.03
set rmargin at screen 0.48

plot "tensorflow_new500k/lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($3):($4) with filledcu fs transparent solid 0.3 noborder lc rgb "#8A2BE2" lt 3 lw 3 t "EPPS16",\
     "tensorflow_new500k/lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($2) lt 8 lc rgb "#8A2BE2" lw 3 with lines notitle,\
     "tensorflow_new500k/A". word(As, i) . ".dat" u 1:(($2)+($6)/4) lt 1 lc rgb word(colors_fit,1) lw 3 with lines notitle,\

#set ylabel "g(x,A)"
unset xlabel
unset xrange
unset arrow
unset xtics
unset ytics
unset logscale


#Panel2

set xrange[0:0.9]
set bars 1.0

set yrange[0.8:1.2]
set xtics(0 0, ""0.1 1, 0.2 0, ""0.3 1, 0.4 0, ""0.5 1, 0.6 0, ""0.7 1, 0.8 0, ""0.9 0)

#set ytics(-2 0, ""-1.5 0, -1 0, ""-0.5 0, 0 0, ""0.5 0, 1 0, ""1.5 0, 2 0, ""2.5 0, 3 0) #font 'Helvetica,14'
set ytics(0.8 0, 0.85 0, 0.9 0, 0.95 0, 1 0, 1.05 0, 1.1 0, 1.15 0, 1.2 0 )

unset label
set tmargin at screen 0.4
set bmargin at screen 0.05
set lmargin at screen 0.03
set rmargin at screen 0.48


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

plot "tensorflow_new500k/lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($3/$2):($4/$2) with filledcu fs transparent solid 0.3 noborder lc rgb "blue" lt 3 lw 3 t "EPPS16",\
     "tensorflow_new500k/lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($2/$2) lt 8 lc rgb "#8A2BE2" lw 3 with lines notitle,\
     "<paste tensorflow_new500k/A". word(As, i) . ".dat tensorflow_new500k/lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:((($2)+($6)/4)/($9)) lt 1 lc rgb "black" lw 3 with lines notitle,\

#Panel3
unset label
unset xtics
unset xrange 

set xrange[1e-3:1]
set logscale x
set tmargin at screen 0.4
set bmargin at screen 0.05
set lmargin at screen 0.53
set rmargin at screen 0.97
#set arrow 1 lt 8 lc rgb "black" lw 0.1 from 1e-3,1 to 1,1 nohead 


#set ylabel "[{/Symbol=\123} + 1/4 T_{8}](x,A)"

set xlabel "x"

set xtics(1e-03 0, ""2e-03 1, ""3e-03 1, ""4e-03 1, ""5e-03 1, ""6e-03 1, ""7e-03 1, ""8e-03 1, ""9e-03 1,\
          1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
          1e+00 0)

plot "tensorflow_new500k/lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($3/$2):($4/$2) with filledcu fs transparent solid 0.3 noborder lc rgb "blue" lt 3 lw 3 t "EPPS16",\
     "tensorflow_new500k/lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:($2/$2) lt 8 lc rgb "#8A2BE2" lw 3 with lines notitle,\
     "<paste tensorflow_new500k/A". word(As, i) . ".dat tensorflow_new500k/lhapdfGrids/lhapdfSigmaT8_A" . word(As, i) . ".dat" u 1:((($2)+($6)/4)/$9) lt 1 lc rgb "black" lw 3 with lines notitle,\

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