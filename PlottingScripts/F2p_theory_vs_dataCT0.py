#!/usr/bin/env python
import numpy as np
import matplotlib.pyplot as py
import sys
import os
from cycler import cycler
from matplotlib import rc
#rc('font', **{'family': 'sans-serif', 'sans-serif': ['Times']})
rc('text', usetex=True)


datafile = open("data/F2p_dataCT0.dat", "r")
data_contents = datafile.readlines()


theories={}

all_results = [f for f in os.listdir("data/PDF_fits") if ".dat" not in f]

meth_txt = open("data/PDF_fits/analytic.dat", "r")
meth_contents = meth_txt.readlines()

path_string = "data/PDF_fits/"

chi2s={}
for i, meth_line in enumerate(meth_contents):
    chi2s[meth_line.split()[2]]=float(meth_line.split()[1])

all_results.sort()

accepted=0
for i,theory_file in enumerate(all_results):

    if chi2s[path_string+theory_file]>1.3e-4:
        continue

    accepted+=1
    theories[i]={}
    theories[i]["x"]=[]
    theories[i]["cv"]=[]
    
    theory_txt = open("data/PDF_fits/"+theory_file+"/theory/Theory.dat", "r")

    theory_contents = theory_txt.readlines()


    for j, theory_line in enumerate(theory_contents):
        if j == 0:
            continue

        theories[i]["x"].append(float(theory_line.split()[0]))
        theories[i]["cv"].append(float(theory_line.split()[1]))

    theories[i]["cv"] = np.array(theories[i]["cv"])

#print "Accepted ",accepted," fits..."
cv_theory = np.zeros(len(theories[0]["x"]))
sd_theory = np.zeros(len(theories[0]["x"]))
for theory in theories.values():
    cv_theory +=theory["cv"]

cv_theory /= len(theories.keys())

for theory in theories.values():
    sd_theory += np.power(theory["cv"]-cv_theory,2)
sd_theory /= len(theories.keys())
sd_theory = np.sqrt(sd_theory)

theory = {}
theory["x"] = theories[0]["x"]
theory["cv"] = cv_theory
data={}
q2_prev=0
for i, line in enumerate(data_contents):
    if i==0:continue
    q2_curr = round(float(line.split()[0]),1)
    if q2_curr != q2_prev:
        data[q2_curr]={'x':[],'cv':[],'sd':[]}
        q2_prev=q2_curr

    data[q2_curr]['x'].append(float(line.split()[1]))
    data[q2_curr]['cv'].append(float(line.split()[2]))
    data[q2_curr]['sd'].append(float(line.split()[3]))

fig, axs = py.subplots(5, 1, sharex=True)
# Remove horizontal space between axes
fig.subplots_adjust(hspace=0)

#colors=['b','r','g','m','c','y']
colors = ['c', 'm', 'y', 'k', 'g']

# these are matplotlib.patch.Patch properties
props = dict(boxstyle='square', facecolor='white', edgecolor='gray', alpha=0.5)

for icol,q2 in enumerate(data.keys()):
    # +cycler('lw', [1.5, 2, 2.5, 3,3.5])) axs[icol].set_prop_cycle(cycler('color', ['c', 'm', 'y', 'k', 'g']))
    #if icol ==0:
    #    axs[icol].plot(data[q2]['x'], theory["cv"][icol*200:(icol+1)*200], ls='-',
    #                       color="red", label="Theory", lw=1)
    #ax.scatter(data[q2]['x'], data[q2]['cv'], s=0.5, marker="o")
    axs[icol].errorbar(data[q2]['x'], theory["cv"][icol*200:(icol+1)*200]/data[q2]['cv'], fmt='o',
                       markersize=1, yerr=np.array(data[q2]['sd'])/np.array(data[q2]['cv']), linestyle='', elinewidth=1., color=colors[icol])
    axs[icol].fill_between(data[q2]['x'], theory["cv"][icol*200:(icol+1)*200]/data[q2]['cv']+sd_theory[icol*200:(icol+1)*200]/np.array(data[q2]['cv']), theory["cv"][icol*200:(icol+1)*200]/data[q2]['cv']-sd_theory[icol*200:(icol+1)*200]/np.array(data[q2]['cv']),facecolor='red', alpha=0.45, edgecolor=None, lw=1)
    #axs[icol].plot(data[q2]['x'], theory["cv"][icol*200:(icol+1)*200], ls='-',
    #              color="red", lw=1)

    #ax.text(0.72, 0.78, A_ref[A], fontsize=40, transform=ax.transAxes)
    axs[icol].set_xlabel(r'$x$', fontsize=12)
    axs[icol].legend(loc='upper right')

    axs[icol].text(0.72, 0.85-icol*1, r'$Q^2=$ '+str(q2)+" GeV$^2$",
                transform=axs[0].transAxes, fontsize=12, verticalalignment='top', bbox=props)

    axs[icol].set_xlim(1e-3, 1.0)
    axs[icol].set_xscale('log')
    #axs[icol].set_yscale('log')
    axs[icol].set_xticks([0.001, 0.01, 0.1, 1])
    axs[icol].set_xticklabels(
        [r'$10^{-3}$', r'$0.01$', r'$0.1$', r'$1$'])

    # place a text box in upper left in axes coords
axs[2].set_ylabel(r'$R$(theory/experiment)', fontsize=12)
axs[0].text(0.05, 0.85, r"$5\% \leq $ $\sigma \leq 7\%$", transform=axs[0].transAxes, fontsize=12,verticalalignment='top', bbox=props)

print('produced results/F2p_theory_vs_dataCT0.pdf ...')
py.savefig('results/F2p_theory_vs_dataCT0.pdf')
py.cla()
py.clf()
