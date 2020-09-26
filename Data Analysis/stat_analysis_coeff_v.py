import pandas as pd
import statistics
from matplotlib import pyplot
import matplotlib.pyplot as plt
from scipy.stats import anderson
import math

######### Normalize Denoise ######

nd = pd.read_csv('Normalize_denoise.txt')
#print()
#print(nd['Values'].to_csv(index=False))
#print(nd["Values"].iloc[0])

counter = 0
nd_mean = []
nd_median = []
val_list = []
for i in range(1280):

    val = nd["Values"].iloc[i]
    counter+=1
    if (counter%40 != 0):
        val_list.append(math.log10(val))
    else:
        val_list.append(math.log10(val))
        nd_mean.append(statistics.mean(val_list))
        nd_median.append(statistics.median(val_list))
        #print ('length of val_list is', len(val_list))
        val_list.clear()
        counter = 0


print('ND_MEAN',nd_mean)
print(statistics.mean(nd_mean))
print('ND_MEDIAN',nd_median)


######### Denoise Normalize ######

dn = pd.read_csv('Denoise_normalize.txt')

dn_counter = 0
dn_mean = []
dn_median = []
dn_val_list = []
for i in range(1280):

    val = dn["Values"].iloc[i]
    dn_counter+=1
    if (dn_counter%40 != 0):
        dn_val_list.append(math.log10(val))
    else:
        dn_val_list.append(math.log10(val))
        dn_mean.append(statistics.mean(dn_val_list))
        dn_median.append(statistics.median(dn_val_list))
        #print ('length of val_list is', len(val_list))
        dn_val_list.clear()
        dn_counter = 0


print('DN_MEAN',dn_mean)

print('DN_MEDIAN',dn_median)



######## Analysis  ########

print("Analysis")
print()
import scipy.stats as stats
print(stats.mannwhitneyu(nd_mean, dn_mean, alternative='two-sided'))
print(stats.mannwhitneyu(nd_median, dn_median, alternative='two-sided'))
