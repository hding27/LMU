""" 
This module provides python functions for the analyses of electron spectra
written by H.Ding during his PhD thesis.
contact Hao.Ding@outlook.de for more information
"""
import mahotas as mh
import numpy as np
import matplotlib.pyplot as plt

def build_Names(path, date, GTLS, source, shot):
    extension = ".tiff"
    if (int(date)<20160200):
        extension = ".png"
    name_bkg = path + "\Calib" + str(date) + "_" + GTLS + "\\" + source + "-Images\\"\
    + "BG_" + source + "_" + "1" + extension
    name_raw = path + "\Calib" + str(date) + "_" + GTLS + "\\" + source + "-Images\\"\
    + source + "_" + str(shot) + extension
    if(int(date)<20170000):
        name_bkg = path + "\Calib" + str(date) + "\\" + source + "-Images\\"\
        + "BG_" + source + "_" + "1" + extension
        name_raw = path + "\Calib" + str(date) + "\\" + source + "-Images\\"\
        + source + "_" + str(shot) + extension
    return (name_bkg, name_raw)

def Intensity(path, date, GTLS, source, shot, enable_plot):
    (name_bkg, name_raw) = build_Names(path, date, GTLS, source, shot)
       
    img_bkg = mh.imread(name_bkg)
    img_raw = mh.imread(name_raw)
    I_bkg = np.sum(img_bkg)/4.
    I_raw = np.sum(img_raw)/4.
    I_pic = (I_raw - I_bkg)
    
    if(enable_plot):
        fig = plt.figure()  
        ax1 = fig.add_subplot(121)
        plt.imshow(img_bkg)    
        ax2 = fig.add_subplot(122)
        plt.imshow(img_raw)
        plt.show()
        print(I_pic)
    return I_pic
    
def get_CalibrationFactor(path, date, GTLS, shot, screen, enable_plot):
    const = 6.61e-3
    if (str(date)=="20160119" or str(date)=="20160122"):
        const = 0.1
    I_LED = Intensity(path, date, GTLS, "LED", shot, enable_plot)
    I_sample = Intensity(path, date, GTLS, "SAMPLE", shot, enable_plot)
    factor = I_LED/I_sample*const
    return (factor, I_LED, I_sample)

def get_Age(date):
# calculate the age in months since 23-March-2017, 
# a month is considered as 30.5 days
    date = int(date)
    days = date%1e2 - 23
    months = date//1e2%1e2 - 3
    years = date//1e4 - 2017
    Age = years*12 + months + days/30.5
    return Age