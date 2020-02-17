import numpy as nump
import matplotlib.pyplot as py
import sys
import os
from cycler import cycler
from matplotlib import rc
#rc('font', **{'family': 'sans-serif', 'sans-serif': ['Times']})
rc('text', usetex=True)


txt = open("Data.dat", "r")
contents = txt.readlines()

data={}
q2_prev=0
for i, line in enumerate(contents):
    if i==0:continue
    q2_curr = round(float(line.split()[0]),1)
    if q2_curr != q2_prev:
        data[q2_curr]={'x':[],'cv':[],'sd':[]}
        q2_prev=q2_curr

    data[q2_curr]['x'].append(float(line.split()[1]))
    data[q2_curr]['cv'].append(float(line.split()[2]))
    data[q2_curr]['sd'].append(float(line.split()[3]))

ax = py.subplot(111)

#colors=['b','r','g','m','c','y']

ax.set_prop_cycle(cycler('color', ['c', 'm', 'y', 'k', 'g']))# +cycler('lw', [1.5, 2, 2.5, 3,3.5]))

for icol,q2 in enumerate(data.keys()):
    #ax.scatter(data[q2]['x'], data[q2]['cv'], s=0.5, marker="o")
    ax.errorbar(data[q2]['x'], data[q2]['cv'], fmt='o', markersize=1, yerr=data[q2]['sd'], linestyle='', elinewidth=0.5, label=r'$Q^2=$ '+str(q2)+" GeV$^2$")

#ax.text(0.72, 0.78, A_ref[A], fontsize=40, transform=ax.transAxes)
ax.set_xlabel(r'$x$', fontsize=12)
ax.set_ylabel(r'$F^{p}_2(x,Q^2)$', fontsize=12)
ax.legend(loc='best')

ax.set_xlim(1e-3, 1.0)
ax.set_xscale('log')
#ax.set_yscale('log')
ax.set_xticks([0.001, 0.01, 0.1, 1])
ax.set_xticklabels(
    [r'$10^{-3}$', r'$0.01$', r'$0.1$', r'$1$'])

# these are matplotlib.patch.Patch properties
props = dict(boxstyle='square', facecolor='white', edgecolor='gray', alpha=0.5)

# place a text box in upper left in axes coords
ax.text(0.05, 0.95, r"$5\% \leq $ $\sigma leq 7\%$", transform=ax.transAxes, fontsize=12,
        verticalalignment='top', bbox=props)

py.savefig('data.pdf')
py.cla()
py.clf()
