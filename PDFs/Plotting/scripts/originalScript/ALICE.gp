################################################################################
#Gnuplot script for data/theory comparison                                     #
################################################################################

infile1b="../dat/ALICE900_dtth.dat"
infile2b="../dat/ALICE2760_dtth.dat"
infile3b="../dat/ALICE7000_dtth.dat"
infile1a="../dat/ALICE900_dtth_af.dat"
infile2a="../dat/ALICE2760_dtth_af.dat"
infile3a="../dat/ALICE7000_dtth_af.dat"
outfile="../figs/comparison_ALICE.eps"

set o outfile
set term post enh col 20 linewidth 1 'Helvetica,28' size 12,22
set multiplot layout 1,4

set logscale x
set xrange[7:50]
set logscale y
set yrange[1e-14:1e0]
set bars 1.0

set xtics(""  5 1, ""  6 1, ""  7 1, ""  8 1, ""  9 1,\
          "" 10 0, "" 20 1, "" 30 1, "" 40 1, "" 50 1,\
          "" 60 1, "" 70 1, "" 80 1, "" 90 1, ""100 0,\
          ""200 1, ""300 1) 

#Panel1
set tmargin at screen 0.95
set bmargin at screen 0.495
set lmargin at screen 0.105
set rmargin at screen 0.945

set format y "10^{%T}"
set ytics(  1e-14 0, ""2e-14 1, ""3e-14 1, ""4e-14 1, ""5e-14 1, ""6e-14 1, ""7e-14 1, ""8e-14 1, ""9e-14 1,\
          ""1e-13 0, ""2e-13 1, ""3e-13 1, ""4e-13 1, ""5e-13 1, ""6e-13 1, ""7e-13 1, ""8e-13 1, ""9e-14 1,\
            1e-12 0, ""2e-12 1, ""3e-12 1, ""4e-12 1, ""5e-12 1, ""6e-12 1, ""7e-12 1, ""8e-12 1, ""9e-12 1,\
          ""1e-11 0, ""2e-11 1, ""3e-11 1, ""4e-11 1, ""5e-11 1, ""6e-11 1, ""7e-11 1, ""8e-11 1, ""9e-11 1,\
            1e-10 0, ""2e-10 1, ""3e-10 1, ""4e-10 1, ""5e-10 1, ""6e-10 1, ""7e-10 1, ""8e-10 1, ""9e-10 1,\
          ""1e-09 0, ""2e-09 1, ""3e-09 1, ""4e-09 1, ""5e-09 1, ""6e-09 1, ""7e-09 1, ""8e-09 1, ""9e-09 1,\
            1e-08 0, ""2e-08 1, ""3e-08 1, ""4e-08 1, ""5e-08 1, ""6e-08 1, ""7e-08 1, ""8e-08 1, ""9e-08 1,\
          ""1e-07 0, ""2e-07 1, ""3e-07 1, ""4e-07 1, ""5e-07 1, ""6e-07 1, ""7e-07 1, ""8e-07 1, ""9e-07 1,\
            1e-06 0, ""2e-06 1, ""3e-06 1, ""4e-06 1, ""5e-06 1, ""6e-06 1, ""7e-06 1, ""8e-06 1, ""9e-06 1,\
          ""1e-05 0, ""2e-05 1, ""3e-05 1, ""4e-05 1, ""5e-05 1, ""6e-05 1, ""7e-05 1, ""8e-05 1, ""9e-05 1,\
            1e-04 0, ""2e-04 1, ""3e-04 1, ""4e-04 1, ""5e-04 1, ""6e-04 1, ""7e-04 1, ""8e-04 1, ""9e-04 1,\
          ""1e-03 0, ""2e-03 1, ""3e-03 1, ""4e-03 1, ""5e-03 1, ""6e-03 1, ""7e-03 1, ""8e-03 1, ""9e-03 1,\
            1e-02 0, ""2e-02 1, ""3e-02 1, ""4e-02 1, ""5e-02 1, ""6e-02 1, ""7e-02 1, ""8e-02 1, ""9e-02 1,\
          ""1e-01 0, ""2e-01 1, ""3e-01 1, ""4e-01 1, ""5e-01 1, ""6e-01 1, ""7e-01 1, ""8e-01 1, ""9e-01 1,\
            1e+00 0)

set label "E_hd^3{/Symbol s}^{h^{/Symbol=\261}}/d^3p^h [mbarn/GeV^2]" at 7.3,2e-2
set label "{/Symbol=\264}10^{-2}" at 33,2e-10
set label "{/Symbol=\264}10^{-4}" at 20.5,5e-12
set label "ALICE" at 7.3,1.5e-1 font 'Helvetica,36'
set label "|{/Symbol h}|<0.8" at 37.5,6e-5
set key at 49,3e-1 spacing 1.2

plot 0 w p ps 0.0000001 t "NNFF1.0h",\
     infile1b u 2:($5/10000):($3-$2):4 with vectors nohead lc rgb "#006400" lt 3 lw 3 notitle,\
     infile1b u 2:(($5+$6)/10000):($3-$2):4 with vectors nohead lc rgb "#006400" lt 1 lw 3 notitle,\
     infile1b u 2:(($5-$6)/10000):($3-$2):4 with vectors nohead lc rgb "#006400" lt 1 lw 3 notitle,\
     infile1b u 2:(($5+$6)/10000):(($5-$6)/10000) w filledcu fs transparent pattern 5\
     lt 1 lc rgb "#006400" t "{/Symbol=\326}s=0.90 TeV",\
     infile1a u 2:($5/10000):($3-$2):4 with vectors nohead lc rgb "black" lt 3 lw 3 notitle,\
     infile1a u 2:(($5+$6)/10000):($3-$2):4 with vectors nohead lc rgb "black" lt 1 lw 3 notitle,\
     infile1a u 2:(($5-$6)/10000):($3-$2):4 with vectors nohead lc rgb "black" lt 1 lw 3 notitle,\
     infile1a u 2:(($5+$6)/10000):(($5-$6)/10000) w filledcu fs transparent pattern 7\
     lt 1 lc rgb "black" notitle,\
     infile1b u (($2+$3)/2):($7/10000):($9/10000) w yerrorbars pt 7 lt 1 lw 3 lc rgb "black" notitle,\
     infile2b u 2:($5/100):($3-$2):4 with vectors nohead lc rgb "red" lt 3 lw 3 notitle,\
     infile2b u 2:(($5+$6)/100):($3-$2):4 with vectors nohead lc rgb "red" lt 1 lw 3 notitle,\
     infile2b u 2:(($5-$6)/100):($3-$2):4 with vectors nohead lc rgb "red" lt 1 lw 3 notitle,\
     infile2b u 2:(($5+$6)/100):(($5-$6)/100) w filledcu fs transparent pattern 4\
     lt 1 lc rgb "red" t "{/Symbol=\326}s=2.76 TeV",\
     infile2a u 2:($5/100):($3-$2):4 with vectors nohead lc rgb "black" lt 3 lw 3 notitle,\
     infile2a u 2:(($5+$6)/100):($3-$2):4 with vectors nohead lc rgb "black" lt 1 lw 3 notitle,\
     infile2a u 2:(($5-$6)/100):($3-$2):4 with vectors nohead lc rgb "black" lt 1 lw 3 notitle,\
     infile2a u 2:(($5+$6)/100):(($5-$6)/100) w filledcu fs transparent pattern 7\
     lt 1 lc rgb "black" notitle,\
     infile2b u (($2+$3)/2):($7/100):($9/100) w yerrorbars pt 7 lt 1 lw 3 lc rgb "black" notitle,\
     infile3b u 2:($5/1):($3-$2):4 with vectors nohead lc rgb "blue" lt 3 lw 3 notitle,\
     infile3b u 2:(($5+$6)/1):($3-$2):4 with vectors nohead lc rgb "blue" lt 1 lw 3 notitle,\
     infile3b u 2:(($5-$6)/1):($3-$2):4 with vectors nohead lc rgb "blue" lt 1 lw 3 notitle,\
     infile3b u 2:(($5+$6)/1):(($5-$6)/1) w filledcu fs transparent pattern 9\
     lt 1 lc rgb "blue" t "{/Symbol=\326}s=7.00 TeV",\
     infile3a u 2:($5/1):($3-$2):4 with vectors nohead lc rgb "black" lt 3 lw 3 notitle,\
     infile3a u 2:(($5+$6)/1):($3-$2):4 with vectors nohead lc rgb "black" lt 1 lw 3 notitle,\
     infile3a u 2:(($5-$6)/1):($3-$2):4 with vectors nohead lc rgb "black" lt 1 lw 3 notitle,\
     infile3a u 2:(($5+$6)/1):(($5-$6)/1) w filledcu fs transparent pattern 7\
     lt 1 lc rgb "black" t "NNFF1.1h",\
     infile3b u (($2+$3)/2):($7/1):($9/1) w yerrorbars pt 7 lt 1 lw 3 lc rgb "black" notitle

unset label
unset logscale y
unset ytics
unset format

#Panel2
set tmargin at screen 0.485
set bmargin at screen 0.370
set lmargin at screen 0.105
set rmargin at screen 0.945

set yrange[0.1:1.9]
set ytics("" 0.1 0, "" 0.16 1, "" 0.22 1, "" 0.28 1, "" 0.34 1,\
             0.4 0, "" 0.46 1, "" 0.52 1, "" 0.58 1, "" 0.64 1,\
          "" 0.7 0, "" 0.76 1, "" 0.82 1, "" 0.88 1, "" 0.94 1,\
             1.0 0, "" 1.06 1, "" 1.12 1, "" 1.18 1, "" 1.24 1,\
          "" 1.3 0, "" 1.36 1, "" 1.42 1, "" 1.48 1, "" 1.54 1,\
             1.6 0, "" 1.66 1, "" 1.72 1, "" 1.78 1, "" 1.84 1,\
          "" 1.9 0)

set label "ratio to data" at 31,1.6

plot infile1b u 2:($5/$7):($3-$2):4 with vectors nohead lc rgb "#006400" lt 3 lw 3 notitle,\
     infile1b u 2:(($5+$6)/$7):($3-$2):4 with vectors nohead lc rgb "#006400" lt 1 lw 3 notitle,\
     infile1b u 2:(($5-$6)/$7):($3-$2):4 with vectors nohead lc rgb "#006400" lt 1 lw 3 notitle,\
     infile1b u 2:(($5+$6)/$7):(($5-$6)/$7) w filledcu fs transparent pattern 5\
     lt 1 lc rgb "#006400" notitle,\
     infile1a u 2:($5/$7):($3-$2):4 with vectors nohead lc rgb "black" lt 3 lw 3 notitle,\
     infile1a u 2:(($5+$6)/$7):($3-$2):4 with vectors nohead lc rgb "black" lt 1 lw 3 notitle,\
     infile1a u 2:(($5-$6)/$7):($3-$2):4 with vectors nohead lc rgb "black" lt 1 lw 3 notitle,\
     infile1a u 2:(($5+$6)/$7):(($5-$6)/$7) w filledcu fs transparent pattern 7\
     lt 1 lc rgb "black" notitle,\
     infile1b u (($2+$3)/2):($7/$7):($9/$7) w yerrorbars pt 7 lt 1 lw 3 lc rgb "black" notitle

unset label

#Panel3
set tmargin at screen 0.360
set bmargin at screen 0.245
set lmargin at screen 0.105
set rmargin at screen 0.945

set yrange[0.1:1.9]

plot infile2b u 2:($5/$7):($3-$2):4 with vectors nohead lc rgb "red" lt 3 lw 3 notitle,\
     infile2b u 2:(($5+$6)/$7):($3-$2):4 with vectors nohead lc rgb "red" lt 1 lw 3 notitle,\
     infile2b u 2:(($5-$6)/$7):($3-$2):4 with vectors nohead lc rgb "red" lt 1 lw 3 notitle,\
     infile2b u 2:(($5+$6)/$7):(($5-$6)/$7) w filledcu fs transparent pattern 6\
     lt 1 lc rgb "red" notitle,\
     infile2a u 2:($5/$7):($3-$2):4 with vectors nohead lc rgb "black" lt 3 lw 3 notitle,\
     infile2a u 2:(($5+$6)/$7):($3-$2):4 with vectors nohead lc rgb "black" lt 1 lw 3 notitle,\
     infile2a u 2:(($5-$6)/$7):($3-$2):4 with vectors nohead lc rgb "black" lt 1 lw 3 notitle,\
     infile2a u 2:(($5+$6)/$7):(($5-$6)/$7) w filledcu fs transparent pattern 7\
     lt 1 lc rgb "black" notitle,\
     infile2b u (($2+$3)/2):($7/$7):($9/$7) w yerrorbars pt 7 lt 1 lw 3 lc rgb "black" notitle

#Panel4
set tmargin at screen 0.235
set bmargin at screen 0.120
set lmargin at screen 0.105
set rmargin at screen 0.945

set xtics(    5 0, ""  6 0,     7 0, ""  8 0, ""  9 0,\
             10 0,    20 0, "" 30 0, "" 40 0,    50 0) 
set xlabel "p@^h_T [GeV]" font 'Helvetica,36'

set yrange[0.1:1.9]

plot infile3b u 2:($5/$7):($3-$2):4 with vectors nohead lc rgb "blue" lt 3 lw 3 notitle,\
     infile3b u 2:(($5+$6)/$7):($3-$2):4 with vectors nohead lc rgb "blue" lt 1 lw 3 notitle,\
     infile3b u 2:(($5-$6)/$7):($3-$2):4 with vectors nohead lc rgb "blue" lt 1 lw 3 notitle,\
     infile3b u 2:(($5+$6)/$7):(($5-$6)/$7) w filledcu fs transparent pattern 9\
     lt 1 lc rgb "blue" notitle,\
     infile3a u 2:($5/$7):($3-$2):4 with vectors nohead lc rgb "black" lt 3 lw 3 notitle,\
     infile3a u 2:(($5+$6)/$7):($3-$2):4 with vectors nohead lc rgb "black" lt 1 lw 3 notitle,\
     infile3a u 2:(($5-$6)/$7):($3-$2):4 with vectors nohead lc rgb "black" lt 1 lw 3 notitle,\
     infile3a u 2:(($5+$6)/$7):(($5-$6)/$7) w filledcu fs transparent pattern 7\
     lt 1 lc rgb "black" notitle,\
     infile3b u (($2+$3)/2):($7/$7):($9/$7) w yerrorbars pt 7 lt 1 lw 3 lc rgb "black" notitle	

system('eps2eps ../figs/comparison_ALICE.eps ../figs/comparison_ALICE2.eps')
system('rm ../figs/comparison_ALICE.eps')
system('mv ../figs/comparison_ALICE2.eps ../figs/comparison_ALICE.eps')