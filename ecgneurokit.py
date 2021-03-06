# -*- coding: utf-8 -*-
"""ECGNeurokit

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1OopLyumV9T9j2XOm11On-hQhYWuaSh-8
"""

from google.colab import drive
drive.mount('/content/drive')

!pip install neurokit2

import neurokit2 as nk
import pandas as pd
import csv

data = pd.read_csv('/content/drive/My Drive/Anxiety Spider Dataset/ECG/ECG_Combined.csv',header=None)

data.head

len(data)

ecg=data.iloc[256]
nk.signal_plot(ecg)

signals, info = nk.ecg_process(ecg,sampling_rate=100)
signals

peaks, info = nk.ecg_peaks(ecg, sampling_rate=100)
nk.hrv(peaks, sampling_rate=100, show=True)

ecg_features=nk.hrv(peaks, sampling_rate=100)

# X=ecg_features[["HRV_RMSSD","HRV_MeanNN","HRV_SDNN", "HRV_SDSD", "HRV_CVNN", "HRV_CVSD", "HRV_MedianNN", "HRV_MadNN", "HRV_MCVNN", "HRV_IQRNN", "HRV_pNN50", "HRV_pNN20"]]
# X

data_features=[]
for i in range(0,len(data)):
  ecg=data.iloc[i]
  peaks, info = nk.ecg_peaks(ecg, sampling_rate=100)
  ecg_features=nk.hrv(peaks, sampling_rate=100)
  X=ecg_features[["HRV_RMSSD","HRV_MeanNN","HRV_SDNN", "HRV_SDSD", "HRV_CVNN", "HRV_CVSD", "HRV_MedianNN", "HRV_MadNN", "HRV_MCVNN", "HRV_IQRNN", "HRV_pNN50", "HRV_pNN20", "HRV_TINN",	"HRV_HTI",	"HRV_ULF",	"HRV_VLF",	"HRV_LF",	"HRV_HF",	"HRV_VHF",	"HRV_LFHF", "HRV_LFn",	"HRV_HFn",	"HRV_LnHF",	"HRV_SD1",	"HRV_SD2",	"HRV_SD1SD2",	"HRV_S",	"HRV_CSI",	"HRV_CVI", "HRV_CSI_Modified", "HRV_PIP",	"HRV_IALS",	"HRV_PSS",	"HRV_PAS",	"HRV_GI",	"HRV_SI",	"HRV_AI",	"HRV_PI",	"HRV_C1d",	"HRV_C1a",	"HRV_SD1d", "HRV_SD1a",	"HRV_C2d",	"HRV_C2a",	"HRV_SD2d",	"HRV_SD2a",	"HRV_Cd",	"HRV_Ca",	"HRV_SDNNd",	"HRV_SDNNa",	"HRV_ApEn",	"HRV_SampEn"]]
  data_features.append(X)

with open('output.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["HRV_RMSSD","HRV_MeanNN","HRV_SDNN", "HRV_SDSD", "HRV_CVNN", "HRV_CVSD", "HRV_MedianNN", "HRV_MadNN", "HRV_MCVNN", "HRV_IQRNN", "HRV_pNN50", "HRV_pNN20", "HRV_TINN",	"HRV_HTI",	"HRV_ULF",	"HRV_VLF",	"HRV_LF",	"HRV_HF",	"HRV_VHF",	"HRV_LFHF", "HRV_LFn",	"HRV_HFn",	"HRV_LnHF",	"HRV_SD1",	"HRV_SD2",	"HRV_SD1SD2",	"HRV_S",	"HRV_CSI",	"HRV_CVI", "HRV_CSI_Modified", "HRV_PIP",	"HRV_IALS",	"HRV_PSS",	"HRV_PAS",	"HRV_GI",	"HRV_SI",	"HRV_AI",	"HRV_PI",	"HRV_C1d",	"HRV_C1a",	"HRV_SD1d", "HRV_SD1a",	"HRV_C2d",	"HRV_C2a",	"HRV_SD2d",	"HRV_SD2a",	"HRV_Cd",	"HRV_Ca",	"HRV_SDNNd",	"HRV_SDNNa",	"HRV_ApEn",	"HRV_SampEn"])

with open('output.csv', 'a', newline='') as file:
    writer = csv.writer(file)
    for val in data_features:
      writer.writerow([val["HRV_RMSSD"].to_string(index=False), val["HRV_MeanNN"].to_string(index=False), val["HRV_SDNN"].to_string(index=False), val["HRV_SDSD"].to_string(index=False), val["HRV_CVNN"].to_string(index=False), val["HRV_CVSD"].to_string(index=False), val["HRV_MedianNN"].to_string(index=False), val["HRV_MadNN"].to_string(index=False), val["HRV_MCVNN"].to_string(index=False), val["HRV_IQRNN"].to_string(index=False), val["HRV_pNN50"].to_string(index=False), val["HRV_pNN20"].to_string(index=False), val["HRV_TINN"].to_string(index=False),	val["HRV_HTI"].to_string(index=False),	val["HRV_ULF"].to_string(index=False),	val["HRV_VLF"].to_string(index=False),	val["HRV_LF"].to_string(index=False),	val["HRV_HF"].to_string(index=False),	val["HRV_VHF"].to_string(index=False),	val["HRV_LFHF"].to_string(index=False), val["HRV_LFn"].to_string(index=False),	val["HRV_HFn"].to_string(index=False),	val["HRV_LnHF"].to_string(index=False),	val["HRV_SD1"].to_string(index=False),	val["HRV_SD2"].to_string(index=False),	val["HRV_SD1SD2"].to_string(index=False),	val["HRV_S"].to_string(index=False),	val["HRV_CSI"].to_string(index=False),	val["HRV_CVI"].to_string(index=False), val["HRV_CSI_Modified"].to_string(index=False), val["HRV_PIP"].to_string(index=False),	val["HRV_IALS"].to_string(index=False),	val["HRV_PSS"].to_string(index=False),	val["HRV_PAS"].to_string(index=False),	val["HRV_GI"].to_string(index=False),	val["HRV_SI"].to_string(index=False),	val["HRV_AI"].to_string(index=False),	val["HRV_PI"].to_string(index=False),	val["HRV_C1d"].to_string(index=False),	val["HRV_C1a"].to_string(index=False),	val["HRV_SD1d"].to_string(index=False), val["HRV_SD1a"].to_string(index=False),	val["HRV_C2d"].to_string(index=False),	val["HRV_C2a"].to_string(index=False),	val["HRV_SD2d"].to_string(index=False),	val["HRV_SD2a"].to_string(index=False),	val["HRV_Cd"].to_string(index=False),	val["HRV_Ca"].to_string(index=False),	val["HRV_SDNNd"].to_string(index=False),	val["HRV_SDNNa"].to_string(index=False),	val["HRV_ApEn"].to_string(index=False),	val["HRV_SampEn"].to_string(index=False)])

# with open('output.csv', 'a', newline='') as file:
#     writer = csv.writer(file)
#     writer.writerow(["NaN", "NaN", "NaN", "NaN", "NaN", "NaN", "NaN", "NaN", "NaN", "NaN", "NaN", "NaN"]) 

# data_features_cont=[]
# for i in range(589,len(data)):
#   ecg=data.iloc[i]
#   peaks, info = nk.ecg_peaks(ecg, sampling_rate=100)
#   ecg_features=nk.hrv(peaks, sampling_rate=100)
#   X=ecg_features[["HRV_RMSSD","HRV_MeanNN","HRV_SDNN", "HRV_SDSD", "HRV_CVNN", "HRV_CVSD", "HRV_MedianNN", "HRV_MadNN", "HRV_MCVNN", "HRV_IQRNN", "HRV_pNN50", "HRV_pNN20"]]
#   data_features_cont.append(X)

# with open('output.csv', 'a', newline='') as file:
#     writer = csv.writer(file)
#     for val in data_features_cont:
#       writer.writerow([val["HRV_RMSSD"].to_string(index=False), val["HRV_MeanNN"].to_string(index=False), val["HRV_SDNN"].to_string(index=False), val["HRV_SDSD"].to_string(index=False), val["HRV_CVNN"].to_string(index=False), val["HRV_CVSD"].to_string(index=False), val["HRV_MedianNN"].to_string(index=False), val["HRV_MadNN"].to_string(index=False), val["HRV_MCVNN"].to_string(index=False), val["HRV_IQRNN"].to_string(index=False), val["HRV_pNN50"].to_string(index=False), val["HRV_pNN20"].to_string(index=False)])