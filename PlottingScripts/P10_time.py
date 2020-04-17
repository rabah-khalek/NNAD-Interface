#!/usr/bin/env python
import numpy as nump
import matplotlib.pyplot as py
import sys,os
import pickle
from matplotlib import rc
#rc('font', **{'family': 'sans-serif', 'sans-serif': ['Times']})
rc('text', usetex=True)

strategies=["Analytic","Automatic","Numeric"]
colors={}
colors["Analytic"]="blue"
colors["Automatic"]="red"
colors["Numeric"]="green"

output={}

#loading
for strategy in strategies:
    output[strategy]={}
    strategy_path = "data/output1/"+strategy
    if not os.path.isdir(strategy_path): 
        continue
    
    all_txts=[f for f in os.listdir(strategy_path) if os.path.isfile(os.path.join(strategy_path,f))]
    all_txts.sort()
    for np_str in all_txts:
        np = int(np_str.split("__")[0])
        output[strategy][np]={}
        np_txt = open("data/output1/"+strategy+"/"+np_str, "r")
        np_contents = np_txt.readlines()

        for i, np_line in enumerate(np_contents):
            if i==0: continue
            Seed = float(np_line.split()[0])
            output[strategy][np][Seed] = {}
            output[strategy][np][Seed]["hid1"]=int(np_line.split()[2])
            output[strategy][np][Seed]["chi2"]=float(np_line.split()[3])
            output[strategy][np][Seed]["time"]=float(np_line.split()[4])

#py.figure(figsize=(20, 10))
ax = py.subplot(111)
ax2 = ax.twiny()
texts=r""
DictOutput={}
for strategy in strategies:
    
    strategy_path = "data/output1/"+strategy
    if not os.path.isdir(strategy_path):
        continue

    nps = []
    neurones = []
    BestTimes = []

    for i, np in enumerate(sorted(output[strategy].keys())):
        times = []
        BestChi2 = 9999
        BestSeed = 0
        for Seed in output[strategy][np].keys():
            if output[strategy][np][Seed]["chi2"] < BestChi2 and output[strategy][np][Seed]["chi2"]<1.0:
                BestSeed = Seed
                BestChi2 = output[strategy][np][Seed]["chi2"]

        if BestChi2 == 9999:
            continue
        
        BestTimes.append(output[strategy][np][BestSeed]["time"])
        nps.append(np)
        neurones.append(output[strategy][np][BestSeed]["hid1"])


        if np==22 or i == len(output[strategy].keys())-1:
            xp = nump.linspace(0,np,100)
            yp = nump.zeros(100)+output[strategy][np][BestSeed]["time"]
            ax.plot(xp, yp, ls='--', color=colors[strategy], lw=1, alpha=0.5)

    ax.plot(nps, BestTimes, ls='-', color=colors[strategy],label=strategy, lw=3)

    #a, b = nump.polyfit(nps, BestTimes, 1)  # , w=nump.sqrt(BestTimes))
    #linreg = a*nump.array(nps)+b
    #ax.plot(nps, linreg, ls='--',
    #        color='black', lw=1)
    #
    #if strategy != "Analytic":
    #    texts += "\n"
    #
    #if b<0:
    #    texts += "$t^{"+strategy+"}= " + \
    #            str(round(a, 3))+"p "+str(round(b, 1))+"$"
    #else:
    #    texts += "$t^{"+strategy+"}= " + \
    #        str(round(a, 3))+"p + "+str(round(b, 1))+"$"

    DictOutput[strategy] = {}
    DictOutput[strategy]["nps"] = nps
    DictOutput[strategy]["BestTimes"] = BestTimes

with open('data/output1/BestTimes.pickle', 'wb') as handle:
    pickle.dump(DictOutput, handle, protocol=pickle.HIGHEST_PROTOCOL)


props = dict(boxstyle='square', facecolor='white', edgecolor='gray', alpha=0.5)
ax.text(0.62, 0.48, texts, transform=ax.transAxes, fontsize=12,
        verticalalignment='top', bbox=props)

ax.set_xlabel('Parameters', fontsize=12)
ax.set_ylabel(r'Time$(s)$ [1k\,\,iterations]', fontsize=12)
ax.set_xlim(left=10)
#ax.set_ylim(bottom=1, top=400)

xticks = []
new_xticks = []

prev_np=0
for i,np in enumerate(nps):
    if i==0 or np-prev_np>6:
        xticks.append(np)
        new_xticks.append(neurones[i])
        prev_np=np

ax.set_xticks(xticks)
ax.tick_params(which='both', direction='in', labelsize=12)
ax.set_xticklabels(xticks, rotation=45)

ax2.set_xlim(ax.get_xlim())
ax2.set_xticks(xticks)
ax2.set_xticklabels(new_xticks)
ax2.tick_params(which='both', direction='in', labelsize=12)
ax2.set_xlabel(r"Middle neurones", fontsize=12)

# these are matplotlib.patch.Patch properties
props = dict(boxstyle='square', facecolor='white', edgecolor='gray', alpha=0.5)

# place a text box in upper left in axes coords
text = r"$N_{data} = 1000$"
ax.text(0.035, 0.78, text, transform=ax.transAxes, fontsize=12,
        verticalalignment='top', bbox=props)

ax.set_yscale('log')

ax.legend(loc='upper left')

print("produced results/P10_time.pdf ...")
py.savefig('results/P10_time.pdf')
py.cla()
py.clf()
