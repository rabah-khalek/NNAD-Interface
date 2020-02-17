#################################################################################
#Gnuplot script for data/theory comparison                                     #
################################################################################
#if (!exists("pdf1")) pdf1="pdf1 needed-as-input via '-e'"
#if (!exists("pdf0")) pdf0="pdf0 needed-as-input via '-e'"

pdf0="nNNPDF10_nlo_as_0118_p" 
pdf1="nNNPDF10_nlo_as_0118_Sn119"#"nNNPDF10_nlo_as_0118_Cu64" #"nNNPDF10_nlo_as_0118_C12"
pdf2="nNNPDF10_nlo_as_0118_Cu64"
pdf3="nNNPDF10_nlo_as_0118_C12"

PDFs="Sigma Gluon T8"
PDFs_syms="'$\Sigma$' g T'$_8$'"
colors="red blue #006400"
colors_fit="red blue #006400"

outfile="figs/lhapdf_ratio_". pdf1 ."__". pdf0 .".pdf"

#infile="lhapdfGrids/lhapdf". word(PDFs,j) ."_A" . word(As, i) . ".dat"


#set term post enh col 20 linewidth 1 'Helvetica,14' #size 20,12
set term qt enhanced font "Helvetica,45" size 2000,2000
set o outfile

set logscale x
set xrange[1e-3:1]
set bars 1.0

set linetype 9 dashtype '-'
set linetype 8 dashtype '.'

unset xtics
set yrange[-1:3]
set xtics(""1e-03 0, ""2e-03 1, ""3e-03 1, ""4e-03 1, ""5e-03 1, ""6e-03 1, ""7e-03 1, ""8e-03 1, ""9e-03 1,\
          ""1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          ""1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
          ""1e+00 0)

set ytics(-2 0, ""-1.5 0, -1 0, ""-0.5 0, 0 0, ""0.5 0, 1 0, ""1.5 0, 2 0, ""2.5 0, 3 0) #font 'Helvetica,14'
#set arrow 1 lt 9 lc rgb "black" lw 0.8 from 1e-3,1 to 1,1 nohead 

#set label "E_hd^3{/Symbol s}^{h^{/Symbol=\261}}/d^3p^h [mbarn/GeV^2]" at 7.3,2e-2
#set label "{/Symbol=\264}10^{-2}" at 33,2e-10
#set label "{/Symbol=\264}10^{-4}" at 20.5,5e-12
set label "Level-0 Closure Test" center at 0.03,3.5 font 'Helvetica,15'
set label "Q_{0} = 1.3 [GeV]" center at 0.03,-0.5 tc rgb"#cccccc"
#set label "|{/Symbol h}|<0.8" at 37.5,6e-5
set key at 0.5,2.9 spacing 1.4

#set for [j=1:words(PDFs)] style line j lt 1 dashtype '-  -' lc rgb word(colors,j) lw 3
set linetype 9 dashtype '-'
set linetype 8 dashtype '.'

#--- to plot the central value of lhapdfgrids
#for [j=1:words(PDFs)] "lhapdfGrids/lhapdf". word(PDFs,j) ."_A" . word(As, i) . ".dat" u 1:2 lt 9 lc rgb word(colors,j) lw 3 with lines notitle #ls j notitle #line lc rgb word(colors,j) lt 2 lw 4 

#Panel1
#set tmargin at screen 0.95
#set bmargin at screen 0.5
#set lmargin at screen 0.105
#set rmargin at screen 0.945

#set grid xtics ytics

#set ylabel ""
set xlabel "x"

set format x "10^{%T}"
set xtics(1e-03 0, ""2e-03 1, ""3e-03 1, ""4e-03 1, ""5e-03 1, ""6e-03 1, ""7e-03 1, ""8e-03 1, ""9e-03 1,\
          1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
          1e+00 0)


plot pdf0."_grids/gluon.dat" u 1:(($3)):(($4)) with filledcu fs transparent solid 0.09 noborder lc rgb "black" lt 3 lw 3 t "g^{proton}",\
     pdf0."_grids/gluon.dat" u 1:($2) lt 1 lc rgb "black" lw 1.5 with lines notitle,\
     \
     pdf3."_grids/gluon.dat" u 1:(($3)):(($4)) with filledcu fs transparent solid 0.09 noborder lc rgb "#0F00E5" lt 3 lw 3 t "g^{Carbon(12)}",\
     pdf3."_grids/gluon.dat" u 1:($2) lt 1 lc rgb "#0F00E5" lw 1.5 with lines notitle,\
     \
     pdf2."_grids/gluon.dat" u 1:(($3)):(($4)) with filledcu fs transparent solid 0.09 noborder lc rgb "#B14EC4" lt 3 lw 3 t "g^{Copper(64)}",\
     pdf2."_grids/gluon.dat" u 1:($2) lt 1 lc rgb "#B14EC4" lw 1.5 with lines notitle,\
     \
     pdf1."_grids/gluon.dat" u 1:(($3)):(($4)) with filledcu fs transparent solid 0.09 noborder lc rgb "#949494" lt 3 lw 3 t "g^{Tin(119)}",\
     pdf1."_grids/gluon.dat" u 1:($2) lt 1 lc rgb "#949494" lw 1.5 with lines notitle,\
     


unset label
unset logscale y
unset ytics
unset format
unset multiplot
unset output

pause 1000
#pause 1