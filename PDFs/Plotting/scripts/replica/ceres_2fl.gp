
PDFs="Sigma Gluon T8"
colors="red blue #006400"
colors_fit="red blue #006400"

outfile="figs/pdfplot.eps"

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

plot for [j=1:1] "lhapdfGrids/". word(PDFs,j) .".dat" u 1:3:4 with filledcu fs transparent solid 0.3 noborder lc rgb word(colors,j) lt 3 lw 3 t "NNPDF3.1 ".word(PDFs,j),\
     for [j=1:1] "lhapdfGrids/". word(PDFs,j) .".dat" u 1:2 lt 8 lc rgb word(colors,j) lw 3 with lines notitle,\
     for [j=1:1] "ceres/". word(PDFs,j) .".dat" u 1:2 lt 1 lc rgb word(colors,j) lw 3 with lines notitle,\
     for [j=3:3] "lhapdfGrids/". word(PDFs,j) .".dat" u 1:3:4 with filledcu fs transparent solid 0.3 noborder lc rgb word(colors,j) lt 3 lw 3 t "NNPDF3.1 ".word(PDFs,j),\
     for [j=3:3] "lhapdfGrids/". word(PDFs,j) .".dat" u 1:2 lt 8 lc rgb word(colors,j) lw 3 with lines notitle,\
     for [j=3:3] "ceres/". word(PDFs,j) .".dat" u 1:2 lt 1 lc rgb word(colors,j) lw 3 with lines notitle,\



unset label
#Panel2
set tmargin at screen 0.65
set bmargin at screen 0.4
set lmargin at screen 0.105
set rmargin at screen 0.945

plot for [j=2:2] "lhapdfGrids/". word(PDFs,j) .".dat" u 1:3:4 with filledcu fs transparent solid 0.5 noborder lc rgb word(colors,j) lt 3 lw 3 t "NNPDF3.1 ".word(PDFs,j),\
     for [j=2:2] "lhapdfGrids/". word(PDFs,j) .".dat" u 1:2 lt 8 lc rgb word(colors,j) lw 3 with lines notitle,\
     for [j=2:2] "ceres/". word(PDFs,j) .".dat" u 1:2 lt 1 lc rgb word(colors,j) lw 3 with lines notitle,\

     

#Panel3
set xtics(1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
          1e+00 0) #font 'Helvetica,36'

set tmargin at screen 0.35
set bmargin at screen 0.05
set lmargin at screen 0.105
set rmargin at screen 0.945

plot for [j=3:3] "<paste lhapdfGrids/". word(PDFs,j) .".dat lhapdfGrids/". word(PDFs,1) . ".dat" u 1:($2)/4+($6) lt 8 lc rgb "black" lw 3 with lines notitle,\
     for [j=3:3] "<paste ceres/". word(PDFs,j) . ".dat ceres/". word(PDFs,1) . ".dat" u 1:($2)/4+($4) lt 1 lc rgb "black" lw 3 with lines notitle,\
     
    
unset label
unset logscale y
unset ytics
unset format
unset multiplot
unset output