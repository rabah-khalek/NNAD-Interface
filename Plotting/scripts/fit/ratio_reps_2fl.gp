################################################################################
#Gnuplot script for data/theory comparison                                     #
################################################################################

if (!exists("reps")) reps=0
PDFs="Sigma Gluon T8"
PDFs_syms="'$\Sigma$' g T'$_8$'"
colors="red blue #006400"
colors_fit="red blue #006400"
outfile="figs/3.ratiopdfplot.eps"

#infile="lhapdfGrids/". word(PDFs,j) . ".dat"

set o outfile
set term post enh col 20 linewidth 1 'Helvetica,12' #size 20,12
set multiplot layout 1,4

set logscale x
set xrange[1e-3:1]
set bars 1.0

set yrange[-1:3]
set xtics(""1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          ""1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
          ""1e+00 0)

set ytics(-2 0, ""-1.5 0, -1 0, ""-0.5 0, 0 0, ""0.5 0, 1 0, ""1.5 0, 2 0, ""2.5 0, 3 0) #font 'Helvetica,14'

#set label "E_hd^3{/Symbol s}^{h^{/Symbol=\261}}/d^3p^h [mbarn/GeV^2]" at 7.3,2e-2
#set label "{/Symbol=\264}10^{-2}" at 33,2e-10
#set label "{/Symbol=\264}10^{-4}" at 20.5,5e-12
set label "Level-0 Closure Test" center at 1.1,3.8 font 'Helvetica,15'
set label "Preliminary, Q_{0} = 1.3 [GeV]" center at 0.03,-0.5 tc rgb"#cccccc"


set label "g(x)" center at 0.03,3.2 font 'Helvetica,15'
#set label "|{/Symbol h}|<0.8" at 37.5,6e-5
#set key at 49,3e-1 spacing 1.2

#set for [j=1:words(PDFs)] style line j lt 1 dashtype '-  -' lc rgb word(colors,j) lw 3
set linetype 9 dashtype '-'
set linetype 8 dashtype '.'

#--- to plot the central value of lhapdfGrids
#for [j=1:words(PDFs)] "lhapdfGrids/". word(PDFs,j) . ".dat" u 1:2 lt 9 lc rgb word(colors,j) lw 3 with lines notitle #ls j notitle #line lc rgb word(colors,j) lt 2 lw 4 

#Panel1
set tmargin at screen 0.95
set bmargin at screen 0.5
set lmargin at screen 0.03
set rmargin at screen 0.48

#set ylabel "g(x)"
unset xlabel
unset arrow

plot for [j=2:2] "lhapdfGrids/". word(PDFs,j) . ".dat" u 1:3:4 with filledcu fs transparent solid 0.3 noborder lc rgb word(colors,j) lt 3 lw 3 t "EPPS16",\
     for [j=2:2] "lhapdfGrids/". word(PDFs,j) . ".dat" u 1:2 lt 8 lc rgb word(colors,j) lw 3 with lines notitle,\
     \
     for [j=0:0] "reps/". fitname ."/". j ."/". word(PDFs,2) . ".dat" u 1:($2-$3):($2+$3) with filledcu fs transparent pattern 5 lc rgb word(colors_fit,2) lt 3 lw 3 t "nNNPDF1.0",\
     for [j=0:0] "reps/". fitname ."/". j ."/". word(PDFs,2) . ".dat" u 1:($2-$3) lt 1 lc rgb word(colors_fit,2) lw 1 with lines notitle,\
     for [j=0:0] "reps/". fitname ."/". j ."/". word(PDFs,2) . ".dat" u 1:($2+$3) lt 1 lc rgb word(colors_fit,2) lw 1 with lines notitle,\
     for [j=0:0] "reps/". fitname ."/". j ."/". word(PDFs,2) . ".dat" u 1:2 lt 1 lc rgb word(colors_fit,2) lw 3 with lines notitle,\
     \
     for [j=1:reps-1] "reps/". fitname ."/". j ."/". word(PDFs,2) . ".dat" u 1:2 lt 1 lc rgb word(colors_fit,2) lw 1 with lines notitle,\

#Panel2
unset yrange
unset ytics
unset label

set yrange[0.:2.]

#set ytics(-2 0, ""-1.5 0, -1 0, ""-0.5 0, 0 0, ""0.5 0, 1 0, ""1.5 0, 2 0, ""2.5 0, 3 0) #font 'Helvetica,14'
set ytics(0. 0, 0.5 0, 1. 0, 1.5 0, 2. 0)


set tmargin at screen 0.4
set bmargin at screen 0.05
set lmargin at screen 0.03
set rmargin at screen 0.48

set label  "g Ratio" center at 0.03,2.3 font 'Helvetica,15'
#set xlabel "x"
#set ylabel "g(x)"

set xtics(""1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          ""1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
          ""1e+00 0) #font 'Helvetica,36'

set arrow 1 lt 8 lc rgb "black" lw 0.1 from 1e-3,1 to 1,1 nohead 

plot "lhapdfGrids/Gluon.dat" u 1:($3/$2):($4/$2) with filledcu fs transparent solid 0.3 noborder lc rgb word(colors_fit,2) lt 3 lw 3 t "EPPS16",\
     "lhapdfGrids/Gluon.dat" u 1:($2/$2) lt 8 lc rgb word(colors_fit,2) lw 3 with lines notitle,\
     \
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/Gluon.dat lhapdfGrids/Gluon.dat" u 1:($2-$3)/($5):($2+$3)/($5) with filledcu fs transparent pattern 5 lc rgb word(colors_fit,2) lt 3 lw 3 t "nNNPDF1.0",\
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/Gluon.dat lhapdfGrids/Gluon.dat" u 1:($2-$3)/($5) lt 1 lc rgb word(colors_fit,2) lw 1 with lines notitle,\
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/Gluon.dat lhapdfGrids/Gluon.dat" u 1:($2+$3)/($5) lt 1 lc rgb word(colors_fit,2) lw 1 with lines notitle,\
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/Gluon.dat lhapdfGrids/Gluon.dat" u 1:($2)/($5) lt 1 lc rgb word(colors_fit,2) lw 3 with lines notitle,\


#Panel3
unset label
unset yrange
unset ytics


set yrange[-1:3]

set ytics(-2 0, ""-1.5 0, -1 0, ""-0.5 0, 0 0, ""0.5 0, 1 0, ""1.5 0, 2 0, ""2.5 0, 3 0) #font 'Helvetica,14'

set tmargin at screen 0.95
set bmargin at screen 0.5
set lmargin at screen 0.53
set rmargin at screen 0.97
unset arrow
unset xlabel

#set xtics(""1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          ""1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
          ""1e+00 0)

set label  "F_{2}^{LO} = [{/Symbol=\123} + 1/4 T_{8}](x)" center at 0.03,3.2 font 'Helvetica,15'
#set ylabel "[{/Symbol=\123} + 1/4 T_{8}](x)"
set label "Preliminary, Q_{0} = 1.3 [GeV]" center at 0.03,-0.5 tc rgb"#cccccc"

     #for [j=0:0] "kin_coverage/x.dat" u 1:(3):2 with labels offset 0,char 0.6 rotate by 45
plot for [j=3:3] "lhapdfGrids/SigmaT8.dat" u 1:3:4 with filledcu fs transparent solid 0.3 noborder lc rgb "#8A2BE2" lt 3 lw 3 t "EPPS16",\
     for [j=3:3] "lhapdfGrids/SigmaT8.dat" u 1:2 lt 8 lc rgb "#8A2BE2" lw 3 with lines notitle,\
     \
     for [j=0:0] "reps/". fitname ."/". j ."/SigmaT8.dat" u 1:($2-$3):($2+$3) with filledcu fs transparent pattern 5 lc rgb "#8A2BE2" lt 3 lw 3 t "nNNPDF1.0",\
     for [j=0:0] "reps/". fitname ."/". j ."/SigmaT8.dat" u 1:($2-$3) lt 1 lc rgb "#8A2BE2" lw 1 with lines notitle,\
     for [j=0:0] "reps/". fitname ."/". j ."/SigmaT8.dat" u 1:($2+$3) lt 1 lc rgb "#8A2BE2" lw 1 with lines notitle,\
     for [j=0:0] "reps/". fitname ."/". j ."/SigmaT8.dat" u 1:2 lt 1 lc rgb "#8A2BE2" lw 3 with lines notitle,\


#Panel4
unset yrange
unset ytics
unset label


set yrange[0.8:1.2]

#set ytics(-2 0, ""-1.5 0, -1 0, ""-0.5 0, 0 0, ""0.5 0, 1 0, ""1.5 0, 2 0, ""2.5 0, 3 0) #font 'Helvetica,14'
set ytics(0.8 0, 0.85 0, 0.9 0, 0.95 0, 1 0, 1.05 0, 1.1 0, 1.15 0, 1.2 0 )
set tmargin at screen 0.4
set bmargin at screen 0.05
set lmargin at screen 0.53
set rmargin at screen 0.97
set arrow 1 lt 8 lc rgb "black" lw 0.1 from 1e-3,1 to 1,1 nohead 

set label  "F_{2}^{LO} Ratio" center at 0.03,2.3 font 'Helvetica,15'
#set ylabel "[{/Symbol=\123} + 1/4 T_{8}](x)"
set label "Preliminary, Q_{0} = 1.3 [GeV]" center at 0.03,-0.5 tc rgb "#cccccc"
set xlabel "x"

#set xtics(1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
          1e+00 0) #font 'Helvetica,36'

plot "lhapdfGrids/SigmaT8.dat" u 1:($3/$2):($4/$2) with filledcu fs transparent solid 0.3 noborder lc rgb "#8A2BE2" lt 3 lw 3 t "EPPS16",\
     "lhapdfGrids/SigmaT8.dat" u 1:($2/$2) lt 8 lc rgb "#8A2BE2" lw 3 with lines notitle,\
     \
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/SigmaT8.dat lhapdfGrids/SigmaT8.dat" u 1:($2-$3)/($6):($2+$3)/($6) with filledcu fs transparent pattern 5 lc rgb "#8A2BE2" lt 3 lw 3 t "nNNPDF1.0",\
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/SigmaT8.dat lhapdfGrids/SigmaT8.dat" u 1:($2-$3)/($6) lt 1 lc rgb "#8A2BE2" lw 1 with lines notitle,\
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/SigmaT8.dat lhapdfGrids/SigmaT8.dat" u 1:($2+$3)/($6) lt 1 lc rgb "#8A2BE2" lw 1 with lines notitle,\
     for [j=0:0] "<paste reps/". fitname ."/".  j ."/SigmaT8.dat lhapdfGrids/SigmaT8.dat" u 1:($2)/($6) lt 1 lc rgb "#8A2BE2" lw 3 with lines notitle,\

unset label
unset logscale y
unset ytics
unset format
unset multiplot
unset output
#pause 1
