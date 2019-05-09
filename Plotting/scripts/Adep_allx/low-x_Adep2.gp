################################################################################
#Gnuplot script for data/theory comparison                                     #
################################################################################
system("rm -f figs/*")
As="4 6 9 12 27 40 56 64 108 119 197" 
blue_gradient="#57E0FF #4FC9F0 #48B3E2 #419CD4 #3A86C5 #3370B7 #2C59A9 #25439A #1E2C8C #17167E #100070" #from http://www.perbang.dk/rgbgradient/
inverse_blue_gradient="#57E0FF #49F0BB #3DE25A #67D432 #ABC528 #B7841F #A92E17 #9A0F3F #8C0978 #53047E #100070"
#As="4 12 56"
PDFs="Sigma Gluon T8"
PDFs_syms="'$\Sigma$' g T'$_8$'"
colors="red blue #006400"
colors_fit="red blue #006400"

outfile="figs/Adep.eps"

#infile="lhapdfGrids/lhapdf". word(PDFs,j) ."_A" . word(As, i) . ".dat"

set o outfile
set term post enh col 20 linewidth 1 'Helvetica,14' #size 20,12
set multiplot layout 1,1

#set logscale x
#set logscale y
set xrange[0:0.1]
set bars 1.0

set yrange[0:4]
#set xtics(1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
          ""1e+00 0)
unset xtics

set ytics(-1 0, ""-0.5 0, 0 0, ""0.5 0, 1 0, ""1.5 0, 2 0, ""2.5 0, 3 0, ""3.5, 4 0) #font 'Helvetica,14'

#set label "E_hd^3{/Symbol s}^{h^{/Symbol=\261}}/d^3p^h [mbarn/GeV^2]" at 7.3,2e-2
#set label "{/Symbol=\264}10^{-2}" at 33,2e-10
#set label "{/Symbol=\264}10^{-4}" at 20.5,5e-12
set label "Level-0 Closure Test" at 0.03,4.3 font 'Helvetica,24'
set label "x=0.01" at 0.005,3.8 font 'Helvetica,24'
#set label "|{/Symbol h}|<0.8" at 37.5,6e-5
#set key at 49,3e-1 spacing 1.2

#set for [j=1:words(PDFs)] style line j lt 1 dashtype '-  -' lc rgb word(colors,j) lw 3
set linetype 9 dashtype '-'
set linetype 8 dashtype '.'

#--- to plot the central value of lhapdfgrids
#for [j=1:words(PDFs)] "lhapdfGrids/lhapdf". word(PDFs,j) ."_A" . word(As, i) . ".dat" u 1:2 lt 9 lc rgb word(colors,j) lw 3 with lines notitle #ls j notitle #line lc rgb word(colors,j) lt 2 lw 4 

set ylabel "g(x,A)"

plot for [i=1:words(As)]  "<(sed -n '87,87p' tensorflow/A". word(As, i) . ".dat)" u (($1)+i*0.005):($4):5 lt 7 lc rgb word(blue_gradient,i) lw 3 with yerr t "A = ".word(As,i),\
     for [i=1:words(As)]  "<(sed -n '753,753p' lhapdfGrids/lhapdf". word(PDFs,2) ."_A" . word(As, i) . ".dat)" u (($1)+i*0.005):2:($4-$2) lt 9 lc rgb word(blue_gradient,i) lw 2 with yerr notitle,\
#plot for [i=1:words(As)] "lhapdfGrids/lhapdf". word(PDFs,2) ."_A" . word(As, i) . ".dat" u 1:3:4 with filledcu fs transparent solid 0.5 noborder lc rgb word(colors,2) lt 3 lw 3 t "EPPS16",\
     for [i=1:words(As)] "lhapdfGrids/lhapdf". word(PDFs,2) ."_A" . word(As, i) . ".dat" u 1:2 lt 8 lc rgb word(colors,2) lw 3 with lines notitle,\
     \
     for [i=1:words(As)] "tensorflow/A". word(As, i) . ".dat" u 1:($4-$5):($4+$5) with filledcu fs transparent pattern 5 lc rgb word(colors_fit,2) lt 3 lw 3 t "nNNPDF1.0",\
     for [i=1:words(As)] "tensorflow/A". word(As, i) . ".dat" u 1:($4-$5) lt 1 lc rgb word(colors_fit,2) lw 1 with lines notitle,\
     for [i=1:words(As)] "tensorflow/A". word(As, i) . ".dat" u 1:($4+$5) lt 1 lc rgb word(colors_fit,2) lw 1 with lines notitle,\
     for [i=1:words(As)] "tensorflow/A". word(As, i) . ".dat" u 1:(($4)-i*0.1) lt 1 lc rgb word(colors_fit,2) lw 3 with lines notitle,\

unset label
unset logscale y
unset ytics
unset format
unset multiplot
unset output
