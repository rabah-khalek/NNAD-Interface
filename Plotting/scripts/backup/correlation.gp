################################################################################
#Gnuplot script for data/theory comparison                                     #
################################################################################
system("rm -f figs/*")
if (!exists("lhapdfname")) lhapdfname="needed-as-input via '-e'"

As="4 6 9 12 27 40 56 64 108 119 197"
indices="a b c d e f g h i j k l m n o p q "
if (!exists("reps")) reps=0

PDFs="Sigma Gluon T8"
PDFs_syms="'$\Sigma$' g T'$_8$'"
colors="red blue #006400"
colors_fit="red blue #006400"
#infile="lhapdfGrids/lhapdf". word(PDFs,j) ."_A" . word(As, i) . ".dat"

outfile="figs/".lhapdfname."_corr.eps"

set o outfile
set term post enh col 20 linewidth 1 'Helvetica,14' #size 20,12



set logscale x
set xrange[1e-3:1]
set bars 1.0

set yrange[-1:3]
set xtics(""1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          ""1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
          ""1e+00 0)

set ytics(-2 0, ""-1.5 0, -1 0, ""-0.5 0, 0 0, ""0.5 0, 1 0, ""1.5 0, 2 0, ""2.5 0, 3 0) #font 'Helvetica,14'

#set for [j=1:words(PDFs)] style line j lt 1 dashtype '-  -' lc rgb word(colors,j) lw 3
set linetype 9 dashtype '-'
set linetype 8 dashtype '.'

#--- to plot the central value of lhapdfgrids
#for [j=1:words(PDFs)] "lhapdfGrids/lhapdf". word(PDFs,j) ."_A" . word(As, i) . ".dat" u 1:2 lt 9 lc rgb word(colors,j) lw 3 with lines notitle #ls j notitle #line lc rgb word(colors,j) lt 2 lw 4 

#Panel1
#set tmargin at screen 0.95
#set bmargin at screen 0.7
#set lmargin at screen 0.105
#set rmargin at screen 0.945
set label "LHAPDF correlation between {/Symbol=\123} and T_{8}" center at 0.03,3.3 font 'Helvetica,15'
set ylabel "{/Symbol=\162}[{/Symbol=\123},T_{8}]"
unset xlabel
unset arrow

plot lhapdfname ."/rho_sigma_t8.dat" u 1:2 lt 1 lc rgb "black" lw 3 with lines t "{/Symbol=\162}[{/Symbol=\123},T_{8}]",\

unset label
unset logscale y
unset ytics
unset format
unset multiplot
unset output