import numpy as np
import matplotlib.pyplot as py
import sys
import os
from cycler import cycler
from matplotlib import rc
#rc('font', **{'family': 'sans-serif', 'sans-serif': ['Times']})
rc('text', usetex=True)

meth_txt = open("../results/meth_analytic.dat", "r")
meth_contents = meth_txt.readlines()

path_string = "/Users/rabah/Documents/NNAD-Interface/results/"

chi2s={}
times={}
for i, meth_line in enumerate(meth_contents):
    chi2s[meth_line.split()[0]]=float(meth_line.split()[3])
    times[meth_line.split()[0]] = float(meth_line.split()[4])

accepted=0

chi2_list=[]
time_list=[]
for i,key in enumerate(chi2s.keys()):

    if chi2s[key] > 1.3e-4:
        continue

    chi2_list.append(chi2s[key])
    time_list.append(times[key])
    accepted+=1
    
print "Accepted ",accepted," fits..."
cv_time = 0
cv_chi2 =0
for i in range(len(chi2_list)):
    cv_time +=time_list[i]
    cv_chi2 +=chi2_list[i]

cv_time /= len(chi2_list)
cv_chi2 /= len(chi2_list)

sd_time=0
sd_chi2=0
for i in range(len(chi2_list)):
    sd_time += np.power(time_list[i]-cv_time,2)
    sd_chi2 += np.power(chi2_list[i]-cv_chi2, 2)

sd_time /= len(chi2_list)
sd_time = np.sqrt(sd_time)

sd_chi2 /= len(chi2_list)
sd_chi2 = np.sqrt(sd_chi2)


fig, axs = py.subplots(1, 1, sharey=True)
# Remove horizontal space between axes
fig.subplots_adjust(wspace=0)

#colors=['b','r','g','m','c','y']
colors = ['c', 'm', 'y', 'k', 'g']

# these are matplotlib.patch.Patch properties
props = dict(boxstyle='square', facecolor='white', edgecolor='gray', alpha=0.5)

#axs[0].hist(time_list, 100, facecolor='blue', alpha=0.5,label="Time(s)")
#axs[0].legend(loc='upper right')
#axs[0].set_ylabel("Fits")
axs.hist(chi2_list, 50, facecolor='red', alpha=0.5,label=r"$\chi^2/N_{data}$")
axs.legend(loc='upper right')
axs.set_xticklabels(
    [r'$10^{-6}$', r'$10^{-5}$', r'$10^{-4}$', r'$10^{-3}$', r'$0.01$', r'$0.1$', r'$1$'])

#axs[1].set_xlabel(r"$\chi^2/N_{data}$")

"""
for icol,q2 in enumerate(data.keys()):
    # +cycler('lw', [1.5, 2, 2.5, 3,3.5])) axs[icol].set_prop_cycle(cycler('color', ['c', 'm', 'y', 'k', 'g']))
    #if icol ==0:
    #    axs[icol].plot(data[q2]['x'], theory["cv"][icol*200:(icol+1)*200], ls='-',
    #                       color="red", label="Theory", lw=1)
    #ax.scatter(data[q2]['x'], data[q2]['cv'], s=0.5, marker="o")
    axs[icol].errorbar(data[q2]['x'], theory["cv"][icol*200:(icol+1)*200]/data[q2]['cv'], fmt='o', markersize=1, yerr=data[q2]['sd'], linestyle='', elinewidth=1., color=colors[icol])
    axs[icol].fill_between(data[q2]['x'], theory["cv"][icol*200:(icol+1)*200]/data[q2]['cv']+sd_theory[icol*200:(icol+1)*200], theory["cv"][icol*200:(icol+1)*200]/data[q2]['cv']-sd_theory[icol*200:(icol+1)*200],facecolor='red', alpha=0.45, edgecolor=None, lw=1)
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
"""
    # place a text box in upper left in axes coords
#axs[2].set_ylabel(r'$R$(theory/experiment)', fontsize=12)
#axs[0].text(0.05, 0.85, r"$5\% \leq $ $\sigma \leq 7\%$", transform=axs[0].transAxes, fontsize=12,verticalalignment='top', bbox=props)

py.savefig('chi2_time.pdf')
py.cla()
py.clf()
