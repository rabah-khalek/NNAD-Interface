#!/usr/bin/env python
import numpy as nump
import matplotlib.pyplot as py
import sys
import os
import pickle
from matplotlib import rc
from matplotlib.offsetbox import AnchoredText
#rc('font', **{'family': 'sans-serif', 'sans-serif': ['Times']})
rc('text', usetex=True)

strategies = ["Analytic", "Automatic"]  # , "Numeric"]
colors = {}
colors["Analytic"] = "blue"
colors["Automatic"] = "red"
colors["Numeric"] = "green"

OutputsNames = ["output1","output2","output3","output4"]
indices = {"output1":1, "output2":2, "output3":3, "output4":4}

ls={}
ls["Analytic"]="-"
ls["Automatic"]="-"

colorsoutput={}
colorsoutput["output1"] = {"Analytic": "darkkhaki", "Automatic": "darkkhaki"}
colorsoutput["output2"] = {"Analytic": "teal" ,"Automatic": "teal"}
colorsoutput["output3"] = {"Analytic": "mediumorchid" ,"Automatic": "mediumorchid"}
colorsoutput["output4"] = {"Analytic": "chocolate","Automatic": "chocolate"}

alpha={}
alpha["Analytic"]=0.5
alpha["Automatic"]=1.

outputs={}
for OutputName in OutputsNames:
    with open("data/"+OutputName+'/BestTimes.pickle', 'rb') as handle:
        outputs[OutputName] = pickle.load(handle)

scale_choices = ["linear", "log"]  # str(sys.argv[1])

for scale_choice in scale_choices:
    #loading
    ax = py.subplot(111)

    for strategy in strategies:
        cut_nps = []
        cut_BestTimes = []
        for i,np in enumerate(outputs[OutputName][strategy]["nps"]):
            if np<=325:
                cut_nps.append(np)
                cut_BestTimes.append(outputs[OutputName][strategy]["BestTimes"][i])
        outputs["output4"][strategy]["nps"] = cut_nps
        outputs["output4"][strategy]["BestTimes"] = cut_BestTimes

    k = 0
    Texts={"Analytic":r"", "Automatic":r""}
    for OutputName in OutputsNames:
        texts = r""
        j = 0
        for strategy in strategies:

            if strategy == "Analytic":
                ax.plot(outputs[OutputName][strategy]["nps"], outputs[OutputName][strategy]["BestTimes"], ls=ls[strategy],
                        color=colorsoutput[OutputName][strategy], label=str(indices[OutputName])+" hidden", lw=3)
            else:
                ax.plot(outputs[OutputName][strategy]["nps"], outputs[OutputName][strategy]["BestTimes"], ls=ls[strategy],
                        color=colorsoutput[OutputName][strategy], lw=3)
            
            ##fit

            # , w=nump.sqrt(BestTimes))
            a, b = nump.polyfit(outputs[OutputName][strategy]["nps"],
                                outputs[OutputName][strategy]["BestTimes"], 1)
            linreg = a*nump.array(outputs[OutputName][strategy]["nps"])+b
            ax.plot(outputs[OutputName][strategy]["nps"], linreg, ls='--',
                    color='black', lw=1)

            if k == 0:
                Texts[strategy] += r"$\,\,\,\,\,\,$"+strategy+"\n"
            else:
                Texts[strategy] += "\n"
            if b < 0:
                Texts[strategy] += "$t_{"+str(indices[OutputName])+"}= " + \
                    str(round(a, 3))+"p "+str(round(b, 1))+"$"
            else:
                Texts[strategy] += "$t_{"+str(indices[OutputName])+"}= " + \
                    str(round(a, 3))+"p + "+str(round(b, 1))+"$"
            j+=1
        k+=1

    #xp = nump.linspace(0, 400, 100)
    #yp = 0.14*xp
    #ax.plot(xp, yp, ls='--',color='gray', lw=1, alpha=0.5)

    props = dict(boxstyle='square', facecolor='white',
                    edgecolor="gray", alpha=0.5)

    
    if scale_choice == 'log':
        ax.text(0.85, 0.3, Texts["Analytic"], transform=ax.transAxes, fontsize=12,
                verticalalignment='top',horizontalalignment='center', bbox=props)

        ax.text(0.85, 0.8, Texts["Automatic"], transform=ax.transAxes, fontsize=12,
                verticalalignment='top',horizontalalignment='center', bbox=props)

    if scale_choice == 'linear':
        ax.text(0.85, 0.35, Texts["Analytic"], transform=ax.transAxes, fontsize=12,
                verticalalignment='top', horizontalalignment='center', bbox=props)

        ax.text(0.85, 0.65, Texts["Automatic"], transform=ax.transAxes, fontsize=12,
                verticalalignment='top', horizontalalignment='center', bbox=props)

    #anchored_text1 = AnchoredText(
    #    Texts["Analytic"], loc=4)  # , color=colorsoutput[OutputName][strategy])
    #anchored_text2 = AnchoredText(
    #    Texts["Automatic"], loc=1)  # , color=colorsoutput[OutputName][strategy])
    #ax.add_artist(anchored_text1)
    #ax.add_artist(anchored_text2)

    ax.set_xlabel('Parameters', fontsize=12)
    ax.set_ylabel(r'Time$(s)$ [1k\,\,iterations]', fontsize=12)

    #ax.set_ylim(bottom=1, top=400)
    #ax.set_xlim(left=15, right=300)

    #xticks = []
    #prev_np = 0
    #for i, np in enumerate(nps):
    #    if i == 0 or np-prev_np > 10:
    #        xticks.append(np)
    #        prev_np = np
    #
    #ax.set_xticks(xticks)
    ax.tick_params(which='both', direction='in', labelsize=12)
    #ax.set_xticklabels(xticks, rotation=45)



    ax.set_yscale(scale_choice)
    ax.legend(loc='upper left')

    print('produced results/'+scale_choice+'_time_combination.pdf ...')
    py.savefig('results/'+scale_choice+'_time_combination.pdf')
    py.cla()
    py.clf()
