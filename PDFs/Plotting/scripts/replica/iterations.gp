################################################################################
#Gnuplot script for data/theory comparison                                     #
################################################################################

outfile="figs/iterations.eps"

set o outfile
set term post enh col 20 linewidth 1 'Helvetica,14' #size 20,12


#set xrange[1e-3:1]
#set bars 1.0

#set yrange[-1:3]
#set xtics(""1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          ""1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
          ""1e+00 0)

#set ytics(-1 0, ""-0.5 0, 0 0, ""0.5 0, 1 0, ""1.5 0, 2 0, ""2.5 0, 3 0) #font 'Helvetica,14'

set xlabel "iterations"
set ylabel "chi2"

set logscale y

plot "iterations/minimizer_summary.dat" u 1:2 lt 8 lc rgb "black" lw 3 with lines notitle,\
        "iterations/minimizer_summary.dat" u 1:2 lt 6 lc rgb "black" lw 1 with points notitle,\
