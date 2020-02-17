################################################################################
#Gnuplot script for data/theory comparison                                     #
################################################################################
As="4 6 9 12 27 40 56 64 108 119"# 197" 
fake_As="1 2 3 4 5 6 7 8 9 10"
blue_gradient="#57E0FF #4FC9F0 #48B3E2 #419CD4 #3A86C5 #3370B7 #2C59A9 #25439A #1E2C8C #17167E #100070" #from http://www.perbang.dk/rgbgradient/
inverse_blue_gradient="#57E0FF #49F0BB #3DE25A #67D432 #ABC528 #B7841F #A92E17 #9A0F3F #8C0978 #53047E #100070"
green_gradient="#29B300 #186B00 #0C3500"
red_gradient="#FF3853 #B2273A #661621"
#As="4 12 56"
PDFs="Sigma Gluon T8"
PDFs_syms="'$\Sigma$' g T'$_8$'"
colors="red blue #006400"
colors_fit="red blue #006400"

outfile="figs/Adep.eps"

#infile="lhapdfGrids/lhapdf". word(PDFs,j) ."_A" . word(As, i) . ".dat"

set o outfile
set term post enh col 20 linewidth 1 'Helvetica,14' #size 20,12
set multiplot layout 1,3

#set logscale x
#set logscale y

set xrange[0:13.5]
set bars 1.0

set yrange[-1:3]
#set xtics(1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
          ""1e+00 0)

#set xtics(""4 0, ""6 0, ""9 0, ""12 0, ""27 0, ""40 0, ""56 0, ""64 0, ""108 0, ""119 0, ""197 0)
set xtics(""0 0, ""1 0, ""2 0, ""3 0, ""4 0, ""5 0, ""6 0, ""7 0, ""8 0, ""9 0, ""10 0)
set ytics(-2 0, ""-1.5 0, -1 0, ""-0.5 0, 0 0, ""0.5 0, 1 0, ""1.5 0, 2 0, ""2.5 0, 3 0, ""3.5, 4 0, ""4.5 0, 5 0, ""5.5 0, 6 0, ""6.5 0, 7 0) #font 'Helvetica,14'
set grid xtics
#set label "E_hd^3{/Symbol s}^{h^{/Symbol=\261}}/d^3p^h [mbarn/GeV^2]" at 7.3,2e-2
#set label "{/Symbol=\264}10^{-2}" at 33,2e-10
#set label "{/Symbol=\264}10^{-4}" at 20.5,5e-12
set label "Level-0 Closure Test" center at 6,3.5 font 'Helvetica,20'
set label "Preliminary" center at 6,2.5 tc rgb"#cccccc"

#set label "|{/Symbol h}|<0.8" at 37.5,6e-5
#set key at 49,3e-1 spacing 1.2

#set for [j=1:words(PDFs)] style line j lt 1 dashtype '-  -' lc rgb word(colors,j) lw 3
set linetype 9 dashtype '-'
set linetype 8 dashtype '.'

#--- to plot the central value of lhapdfgrids
#for [j=1:words(PDFs)] "lhapdfGrids/lhapdf". word(PDFs,j) ."_A" . word(As, i) . ".dat" u 1:2 lt 9 lc rgb word(colors,j) lw 3 with lines notitle #ls j notitle #line lc rgb word(colors,j) lt 2 lw 4 

#Panel1
set tmargin at screen 0.95
set bmargin at screen 0.7
set lmargin at screen 0.105
set rmargin at screen 0.945

set ylabel "{/Symbol=\123}(x,A)"

plot for [i=9:9]  "<(sed -n '87,87p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(As, i)+ 0):($6):7 lt 7 lc rgb "black" lw 3 with yerr t "nNNPDF1.0",\
     for [i=9:9]  "<(sed -n '753,753p' lhapdfGrids/lhapdf". word(PDFs,3) ."_A" . word(As, i) . ".dat)" u (($1)-($1)+word(As, i)+ 0):2:($4-$2) lt 6 lc rgb "black" lw 1 with yerr t "EPPS16",\
     for [i=9:9]  "<(sed -n '753,753p' lhapdfGrids/lhapdf". word(PDFs,3) ."_A" . word(As, i) . ".dat)" u (($1)-($1)+word(As, i)+ 0):2:($4-$2) lt 6 lc rgb "white" lw 1 with yerr t " ",\
     \
     for [i=1:1]  "<(sed -n '87,87p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)- 0.1):($6):7 lt 7 lc rgb word(colors_fit,1) lw 3 with l t "x=0.01",\
     for [i=1:words(As)]  "<(sed -n '87,87p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)- 0.1):($6):7 lt 7 lc rgb word(colors_fit,1) lw 3 with yerr notitle,\
     for [i=1:words(As)]  "<(sed -n '753,753p' lhapdfGrids/lhapdf". word(PDFs,3) ."_A" . word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.1):2:($4-$2) lt 6 lc rgb word(colors_fit,1) lw 1 with yerr notitle,\
     \
     #for [i=1:1]  "<(sed -n '101,101p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.1):($6):7 lt 7 lc rgb word(red_gradient,2) lw 3 with l t "x=0.1",\
     for [i=1:words(As)]  "<(sed -n '101,101p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.1):($6):7 lt 7 lc rgb word(red_gradient,2) lw 3 with yerr notitle,\
     for [i=1:words(As)]  "<(sed -n '878,878p' lhapdfGrids/lhapdf". word(PDFs,3) ."_A" . word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.1):2:($4-$2) lt 6 lc rgb word(red_gradient,2) lw 1 with yerr notitle,\
     \
     #for [i=1:1]  "<(sed -n '602,602p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.15):($6):7 lt 7 lc rgb word(red_gradient,3) lw 3 with yerr t "x=0.6",\
     for [i=1:words(As)]  "<(sed -n '602,602p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.15):($6):7 lt 7 lc rgb word(red_gradient,3) lw 3 with yerr notitle,\
     for [i=1:words(As)]  "<(sed -n '976,976p' lhapdfGrids/lhapdf". word(PDFs,3) ."_A" . word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.15):2:($4-$2) lt 9 lc rgb word(red_gradient,3) lw 2 with yerr notitle,\

unset label

#Panel2
set tmargin at screen 0.65
set bmargin at screen 0.4
set lmargin at screen 0.105
set rmargin at screen 0.945

set ylabel "g(x,A)"
set label "Preliminary" center at 6,2.5 tc rgb"#cccccc"

plot for [i=1:1]  "<(sed -n '87,87p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)- 0.1):($2):3 lt 7 lc rgb word(colors_fit,2) lw 3 with l t "x=0.01",\
     for [i=1:words(As)]  "<(sed -n '87,87p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)- 0.1):($2):3 lt 7 lc rgb word(colors_fit,2) lw 3 with yerr notitle,\
     for [i=1:words(As)]  "<(sed -n '753,753p' lhapdfGrids/lhapdf". word(PDFs,2) ."_A" . word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.1):2:($4-$2) lt 6 lc rgb word(colors_fit,2) lw 1 with yerr notitle,\
     \
     #for [i=1:1]  "<(sed -n '101,101p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.1):($2):3 lt 7 lc rgb word(blue_gradient,4) lw 3 with l t "x=0.1",\
     for [i=1:words(As)]  "<(sed -n '101,101p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.1):($2):3 lt 7 lc rgb word(blue_gradient,4) lw 3 with yerr notitle,\
     for [i=1:words(As)]  "<(sed -n '878,878p' lhapdfGrids/lhapdf". word(PDFs,2) ."_A" . word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.1):2:($4-$2) lt 6 lc rgb word(blue_gradient,4) lw 1 with yerr notitle,\
     \
     #for [i=1:1]  "<(sed -n '602,602p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.15):($2):3 lt 7 lc rgb word(blue_gradient,8) lw 3 with yerr t "x=0.6",\
     for [i=1:words(As)]  "<(sed -n '602,602p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.15):($2):3 lt 7 lc rgb word(blue_gradient,8) lw 3 with yerr notitle,\
     for [i=1:words(As)]  "<(sed -n '976,976p' lhapdfGrids/lhapdf". word(PDFs,2) ."_A" . word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.15):2:($4-$2) lt 9 lc rgb word(blue_gradient,8) lw 2 with yerr notitle,\

unset label

#Panel 3
#set xtics(4 0, 6 0, 9 0, 12 0, 27 0, 40 0, 56 0, 64 0, 108 0, 119 0, 197 0)
set xtics('4' 1 0, '6' 2 0, '9' 3 0, '12' 4 0, '27' 5 0, '40' 6 0, '56' 7 0, '64' 8 0, '108' 9 0, '119' 10 0)

set tmargin at screen 0.35
set bmargin at screen 0.05
set lmargin at screen 0.105
set rmargin at screen 0.945

set ylabel "T_{8}(x,A)"
set xlabel "A"

set label "Preliminary" center at 6,2.5 tc rgb"#cccccc"

plot for [i=1:1]  "<(sed -n '87,87p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)- 0.1):($6):7 lt 7 lc rgb word(colors_fit,3) lw 3 with l t "x=0.01",\
     for [i=1:words(As)]  "<(sed -n '87,87p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)- 0.1):($6):7 lt 7 lc rgb word(colors_fit,3) lw 3 with yerr notitle,\
     for [i=1:words(As)]  "<(sed -n '753,753p' lhapdfGrids/lhapdf". word(PDFs,3) ."_A" . word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.1):2:($4-$2) lt 6 lc rgb word(colors_fit,3) lw 1 with yerr notitle,\
     \
     #for [i=1:1]  "<(sed -n '101,101p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.1):($6):7 lt 7 lc rgb word(green_gradient,2) lw 3 with l t "x=0.1",\
     for [i=1:words(As)]  "<(sed -n '101,101p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.1):($6):7 lt 7 lc rgb word(green_gradient,2) lw 3 with yerr notitle,\
     for [i=1:words(As)]  "<(sed -n '878,878p' lhapdfGrids/lhapdf". word(PDFs,3) ."_A" . word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.1):2:($4-$2) lt 6 lc rgb word(green_gradient,2) lw 1 with yerr notitle,\
     \
     #for [i=1:1]  "<(sed -n '602,602p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.15):($6):7 lt 7 lc rgb word(green_gradient,3) lw 3 with yerr t "x=0.6",\
     for [i=1:words(As)]  "<(sed -n '602,602p' tensorflow/A". word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.15):($6):7 lt 7 lc rgb word(green_gradient,3) lw 3 with yerr notitle,\
     for [i=1:words(As)]  "<(sed -n '976,976p' lhapdfGrids/lhapdf". word(PDFs,3) ."_A" . word(As, i) . ".dat)" u (($1)-($1)+word(fake_As, i)+ 0.15):2:($4-$2) lt 9 lc rgb word(green_gradient,3) lw 2 with yerr notitle,\

unset label
unset logscale y
unset ytics
unset format
unset multiplot
unset output
