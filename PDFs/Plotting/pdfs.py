import collections
from scipy.integrate import quad
from matplotlib import rc
import matplotlib.pyplot as py
from pylab import *
import numpy as np
import sys
import os
sys.path.append(os.getcwd()+"/../")
rc('font', **{'family': 'sans-serif', 'sans-serif': ['Times']})
rc('text', usetex=True)

if __name__ == '__main__':

    resultname = sys.argv[1]
    avg_dirname='reps/'+resultname+'/0/'

    gluon_path = avg_dirname+'Gluon.dat'
    sigma_path = avg_dirname+'Sigma.dat'

    ref_gluon_path = 'lhapdfGrids/Gluon.dat'
    ref_sigma_path = 'lhapdfGrids/Sigma.dat'

    gluon_dat = open(gluon_path, "r")
    sigma_dat = open(sigma_path, "r")

    ref_gluon_dat = open(ref_gluon_path, "r")
    ref_sigma_dat = open(ref_sigma_path, "r")

    gluon_contents = gluon_dat.readlines()
    sigma_contents = sigma_dat.readlines()

    ref_gluon_contents = ref_gluon_dat.readlines()
    ref_sigma_contents = ref_sigma_dat.readlines()

    Gluon = {'x': [], 'cv': [], 'sd': []}
    Sigma = {'x': [], 'cv': [], 'sd': []}

    ref_Gluon = {'x': [], 'cv': [], 'up': [], 'down':[]}
    ref_Sigma = {'x': [], 'cv': [], 'up': [], 'down':[]}

    for i, gluon_line in enumerate(gluon_contents):
        Gluon['x'].append(float(gluon_line.split()[0]))
        Gluon['cv'].append(float(gluon_line.split()[1]))
        Gluon['sd'].append(float(gluon_line.split()[2]))

    for i, sigma_line in enumerate(sigma_contents):
        Sigma['x'].append(float(sigma_line.split()[0]))
        Sigma['cv'].append(float(sigma_line.split()[1]))
        Sigma['sd'].append(float(sigma_line.split()[2]))

    for i, ref_gluon_line in enumerate(ref_gluon_contents):
        ref_Gluon['x'].append(float(ref_gluon_line.split()[0]))
        ref_Gluon['cv'].append(float(ref_gluon_line.split()[1]))
        ref_Gluon['down'].append(float(ref_gluon_line.split()[2]))
        ref_Gluon['up'].append(float(ref_gluon_line.split()[3]))

    for i, ref_sigma_line in enumerate(ref_sigma_contents):
        ref_Sigma['x'].append(float(ref_sigma_line.split()[0]))
        ref_Sigma['cv'].append(float(ref_sigma_line.split()[1]))
        ref_Sigma['down'].append(float(ref_sigma_line.split()[2]))
        ref_Sigma['up'].append(float(ref_sigma_line.split()[3]))


    # subplots decomposition
    nrows, ncols = 1, 1
    #py.figure()#figsize=(ncols*5, nrows*3.5))

    fig, ax = py.subplots()

    g1 = ax.plot(Gluon['x'], Gluon['cv'], ls='-', color='blue', lw=2, label=r'$g$')
    g2 = ax.fill_between(Gluon['x'], np.array(Gluon['cv'])+np.array(Gluon['sd']), np.array(Gluon['cv'])-np.array(Gluon['sd']),facecolor='blue', alpha=0.25, edgecolor=None, lw=1)
    #ax.legend([(g2[0], g1[0]), ], [r'$g$'])

    s1=ax.plot(Sigma['x'], Sigma['cv'], ls='-', color='red', lw=2, label=r'$\Sigma$')
    s2=ax.fill_between(Sigma['x'], np.array(Sigma['cv'])+np.array(Sigma['sd']), np.array(Sigma['cv'])-np.array(Sigma['sd']),facecolor='red', alpha=0.25, edgecolor=None, lw=1)
    #ax.legend([(s2[0], s1[0]), ], [r'$\Sigma$'])

    ax.plot(ref_Gluon['x'], ref_Gluon['cv'], ls='--', color='blue', lw=2,label=r'$g(prior)$')
    ax.fill_between(ref_Gluon['x'], ref_Gluon['up'], ref_Gluon['down'],facecolor='gray',alpha=0.3,lw=1)#facecolor="none", hatch="-", edgecolor="blue", alpha=0.25, lw=1)

    ax.plot(ref_Sigma['x'], ref_Sigma['cv'], ls='--', color='red', lw=2,label=r'$\Sigma(prior)$')
    ax.fill_between(ref_Sigma['x'], ref_Sigma['up'], ref_Sigma['down'],facecolor='gray',alpha=0.3,lw=1)#facecolor="none", hatch="-", edgecolor="red", alpha=0.25, lw=1)


    ax.set_xlim(1e-3, 1.0)
    ax.set_xscale('log')
    ax.set_xticks([0.001, 0.01, 0.1, 1])
    ax.set_xticklabels(
    [r'$10^{-3}$', r'$0.01$', r'$0.1$', r'$1$'])
    ax.tick_params(which='both', direction='in', labelsize=12)
    ax.tick_params(which='major', length=7)
    ax.tick_params(which='minor', length=3.5)

    ax.set_xlabel(r'$x$', fontsize=12)
    ax.set_ylabel(r'$f(x,Q_0=1\,GeV)$', fontsize=12)
    ax.legend(loc='lower right')

    # these are matplotlib.patch.Patch properties
    props = dict(boxstyle='square', facecolor='white', edgecolor='gray', alpha=0.5)

    # place a text box in upper left in axes coords
    ax.text(0.05, 0.95, r'$N_{rep}=100$', transform=ax.transAxes, fontsize=12,
            verticalalignment='top', bbox=props)
    
    resultpath = resultname+".pdf"

    py.savefig(resultpath)
    py.cla()
    py.clf()
