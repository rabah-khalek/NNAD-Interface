################################################################################
#Gnuplot script for data/theory comparison                                     #
################################################################################
#system("rm -f figs/*")
if (!exists("fitname")) fitname="needed-as-input via '-e'"

if (!exists("reps")) reps=0
PDFs="Sigma Gluon T8"
PDFs_syms="'$\Sigma$' g T'$_8$'"
colors="red blue #006400"
colors_fit="red blue #006400"

outfile="figs/ind_pdfplot.eps"

#infile="NNPDF31_nlo_as_0118_grids/lhapdf". word(PDFs,j) . ".dat"

set o outfile
set term post enh col 20 linewidth 1 'Helvetica,14' #size 20,12
set multiplot layout 1,3

set logscale x
set xrange[1e-3:1]
set bars 1.0

set yrange[-1:3]
set xtics(""1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          ""1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
          ""1e+00 0)

set ytics(-1 0, ""-0.5 0, 0 0, ""0.5 0, 1 0, ""1.5 0, 2 0, ""2.5 0, 3 0) #font 'Helvetica,14'

#set label "E_hd^3{/Symbol s}^{h^{/Symbol=\261}}/d^3p^h [mbarn/GeV^2]" at 7.3,2e-2
#set label "{/Symbol=\264}10^{-2}" at 33,2e-10
#set label "{/Symbol=\264}10^{-4}" at 20.5,5e-12
set label "Preliminary Level-0 Closure Test" at 0.007,3.5 font 'Helvetica,20'
#set label "|{/Symbol h}|<0.8" at 37.5,6e-5
#set key at 49,3e-1 spacing 1.2

#set for [j=1:words(PDFs)] style line j lt 1 dashtype '-  -' lc rgb word(colors,j) lw 3
set linetype 9 dashtype '-'
set linetype 8 dashtype '.'

#--- to plot the central value of NNPDF31_nlo_as_0118_grids
#for [j=1:words(PDFs)] "NNPDF31_nlo_as_0118_grids/lhapdf". word(PDFs,j) . ".dat" u 1:2 lt 9 lc rgb word(colors,j) lw 3 with lines notitle #ls j notitle #line lc rgb word(colors,j) lt 2 lw 4 

#Panel1
set tmargin at screen 0.95
set bmargin at screen 0.7
set lmargin at screen 0.105
set rmargin at screen 0.945

set ylabel "{/Symbol=\123}(x)"
unset xlabel

plot for [j=1:1] "NNPDF31_nlo_as_0118_grids/lhapdf". word(PDFs,j) . ".dat" u 1:3:4 with filledcu fs transparent solid 0.3 noborder lc rgb word(colors,j) lt 3 lw 3 t "EPPS16",\
     for [j=1:1] "NNPDF31_nlo_as_0118_grids/lhapdf". word(PDFs,j) . ".dat" u 1:2 lt 8 lc rgb word(colors,j) lw 3 with lines notitle,\
     \
     for [j=0:0]  "reps/". fitname ."/". j ."/". word(PDFs,1) . ".dat" u 1:($2-$3):($2+$3) with filledcu fs transparent pattern 7 lc rgb word(colors_fit,1) lt 3 lw 3 t "nNNPDF1.0",\
     for [j=0:0]  "reps/". fitname ."/". j ."/". word(PDFs,1) . ".dat" u 1:($2-$3) lt 1 lc rgb word(colors_fit,1) lw 1 with lines notitle,\
     for [j=0:0]  "reps/". fitname ."/". j ."/". word(PDFs,1) . ".dat" u 1:($2+$3) lt 1 lc rgb word(colors_fit,1) lw 1 with lines notitle,\
     for [j=0:0]  "reps/". fitname ."/". j ."/". word(PDFs,1) . ".dat" u 1:2 lt 1 lc rgb word(colors_fit,1) lw 3 with lines notitle,\
     \
     for [j=1:reps-1]  "reps/". fitname ."/". j ."/". word(PDFs,1) . ".dat" u 1:2 lt 1 lc rgb word(colors_fit,1) lw 1 with lines notitle,\

unset label
#Panel2
set tmargin at screen 0.65
set bmargin at screen 0.4
set lmargin at screen 0.105
set rmargin at screen 0.945

set ylabel "g(x)"
unset xlabel

plot for [j=2:2] "NNPDF31_nlo_as_0118_grids/lhapdf". word(PDFs,j) . ".dat" u 1:3:4 with filledcu fs transparent solid 0.5 noborder lc rgb word(colors,j) lt 3 lw 3 t "EPPS16",\
     for [j=2:2] "NNPDF31_nlo_as_0118_grids/lhapdf". word(PDFs,j) . ".dat" u 1:2 lt 8 lc rgb word(colors,j) lw 3 with lines notitle,\
     \
     for [j=0:0]  "reps/". fitname ."/". j ."/". word(PDFs,2) . ".dat" u 1:($2-$3):($2+$3) with filledcu fs transparent pattern 7 lc rgb word(colors_fit,2) lt 3 lw 3 t "nNNPDF1.0",\
     for [j=0:0]  "reps/". fitname ."/". j ."/". word(PDFs,2) . ".dat" u 1:($2-$3) lt 1 lc rgb word(colors_fit,2) lw 1 with lines notitle,\
     for [j=0:0]  "reps/". fitname ."/". j ."/". word(PDFs,2) . ".dat" u 1:($2+$3) lt 1 lc rgb word(colors_fit,2) lw 1 with lines notitle,\
     for [j=0:0]  "reps/". fitname ."/". j ."/". word(PDFs,2) . ".dat" u 1:2 lt 1 lc rgb word(colors_fit,2) lw 3 with lines notitle,\
     \
     for [j=1:reps-1]  "reps/". fitname ."/". j ."/". word(PDFs,2) . ".dat" u 1:2 lt 1 lc rgb word(colors_fit,2) lw 1 with lines notitle,\

#Panel3
set xtics(1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
          1e+00 0) #font 'Helvetica,36'

set tmargin at screen 0.35
set bmargin at screen 0.05
set lmargin at screen 0.105
set rmargin at screen 0.945

set ylabel "T_{8}(x)"
set xlabel "x"

plot for [j=3:3] "NNPDF31_nlo_as_0118_grids/lhapdf". word(PDFs,j) . ".dat" u 1:3:4 with filledcu fs transparent solid 0.3 noborder lc rgb word(colors,j) lt 3 lw 3 t "EPPS16",\
     for [j=3:3] "NNPDF31_nlo_as_0118_grids/lhapdf". word(PDFs,j) . ".dat" u 1:2 lt 8 lc rgb word(colors,j) lw 3 with lines notitle,\
     \
     \
     for [j=0:0]  "reps/". fitname ."/". j ."/". word(PDFs,3) . ".dat" u 1:($2-$3):($2+$3) with filledcu fs transparent pattern 7 lc rgb word(colors_fit,3) lt 3 lw 3 t "nNNPDF1.0",\
     for [j=0:0]  "reps/". fitname ."/". j ."/". word(PDFs,3) . ".dat" u 1:($2-$3) lt 1 lc rgb word(colors_fit,3) lw 1 with lines notitle,\
     for [j=0:0]  "reps/". fitname ."/". j ."/". word(PDFs,3) . ".dat" u 1:($2+$3) lt 1 lc rgb word(colors_fit,3) lw 1 with lines notitle,\
     for [j=0:0]  "reps/". fitname ."/". j ."/". word(PDFs,3) . ".dat" u 1:2 lt 1 lc rgb word(colors_fit,3) lw 3 with lines notitle,\
     \
     for [j=1:reps-1]  "reps/". fitname ."/". j ."/". word(PDFs,3) . ".dat" u 1:2 lt 1 lc rgb word(colors_fit,3) lw 1 with lines notitle,\

unset label
unset logscale y
unset ytics
unset format
unset multiplot
unset output
#pause 1
