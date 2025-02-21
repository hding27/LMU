import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import fft, ifft, fftshift
from scipy.misc import imread
from statsmodels.nonparametric.smoothers_lowess import lowess


class Shot(object):
    
    def __init__(self, Path, Date, Run, Number):
        self.path = Path
        self.date = Date
        self.run = Run
        self.number = Number
        
    def __str__(self):
        return "This is shot %s from run %s on %s, saved in %s." %(self.number, self.run, self.date, self.path)
        
    def nameDirectory(self, Item):
        Directory = self.path + "/" + self.date + "/" + Item + "/"
        if Item in ["probe","ProbeCamX", "Delay", "CamX", "Y", "Z"]:
            Directory = self.path + "/" + self.date + "/" + "Probe" + "/"  
        return Directory

    def nameFile(self, Item, Surfix = ".txt", withPrefix=False):
        FileName = Item + Surfix
        if withPrefix:
            FileName = self.date + "_" + self.run + "_" + self.number + "_" + Item + Surfix
        return FileName
        
    def getAttribute(self, AttributeName):
        Attribute = []
        fileName = self.nameDirectory(AttributeName) + self.nameFile(AttributeName)
        myFile = open(fileName, "r")
        for line in myFile:
            if line[0:4] == self.number:
                temp = line.split()
                Attribute = temp[self.Index(AttributeName)]
                break
            continue
        myFile.close()
        return Attribute
    
    def Index(self, Name):
        return 3

class Probe(Shot):
    imageRaw = []
    imageROI = []
    imageOut = []
    ROI = []
    
    def readRaw(self,Display=True):
        fileName = self.nameDirectory("probe") + self.nameFile("probe",".png", withPrefix=True)
        self.imageRaw = np.uint16(imread(fileName))
        if Display:
            figRaw = plt.figure(figsize=(18, 18))
            plt.imshow(self.imageRaw, cmap="gray")
            plt.show()
        return True
        
#    def nameFile(self, Item="probe", Surfix = ".txt", withPrefix=False):
#        if Item in ["probe","Probe"]:
#            FileName = self.date + "_" + self.run + "_" + self.number + "_probe.png"
#            elif Item in ["ProbeROI","Scalogram","Wavelength"] or Surfix in [".ini"]:
#                Prefix = self.date + "_" + self.run + "_" + self.number + "_"
#
#        FileName = Prefix + Item + Surfix    
#        return FileName
            
    def getROI(self):
        if(self.ROI != []):
            print(self.ROI)
        else:
            print("please set ROI first")
    
    def setROI(self,ROI):
        self.ROI = ROI
    
    def cropImage(self, Display=True):
        self.imageROI = np.double(self.imageRaw[self.ROI.top:self.ROI.bottom, self.ROI.left:self.ROI.right])
        if Display:
            figROI = plt.figure(figsize=(18, 4))
            plt.imshow(self.imageROI, cmap='gray')
        return True
    
    def enhanceImage(self,Display=True):
        (height, width) = self.imageROI.shape
        imageBKG = np.ones((height, width))
        for i in range(height):
            line = np.double(self.imageROI[i,:])
            smooth = lowess(line, range(width), is_sorted=True, frac=0.06, it=0)
            imageBKG[i,:] = smooth[:,1]
        if Display:    
            self.imageOut = np.uint16(self.imageROI-imageBKG+32768)
            figBKG = plt.figure(figsize=(18, 4))
            plt.imshow(imageBKG, cmap='gray')
            figOut = plt.figure(figsize=(18, 4))
            plt.imshow(self.imageOut, cmap='gray')
            plt.show()
        return True
    
    def getLineout(self, Index, Mask, Display=True):
        sig = self.imageOut[Index,:]
        sig = sig/np.mean(sig) - 1.
        sig[Mask[0]:Mask[1]] = 0
        self.lineout = sig
        if Display:
            figLine = plt.figure(figsize=(18, 4))
            plt.plot(self.lineout)
            plt.show()
        return True

    def setResolution(self, Resolution):
        self.resolution = Resolution
    
    def plotEnhance(self):
        figOut = plt.figure(figsize=(18, 4))
        plt.imshow(self.imageOut, cmap='gray',interpolation='none', extent=[0,self.resolution*self.imageOut.shape[1],self.resolution*self.imageOut.shape[0],0])
        plt.ylabel("position [um]")
        plt.xlabel("position [um]")
        plt.show()
        return figOut        
    
    def getScalogram(self, w0=10, M_octaves=3):
        self.scalogram = CWT(self.lineout, w0, M_octaves)
        self.scale = self.lineout.shape[0]*self.resolution/(NaturalSample(M_octaves)*w0)/2
        self.shift = np.arange(self.lineout.shape[0])*self.resolution
    
    def plotScalogram(self):
        Z, A = np.meshgrid(self.shift, self.scale)
        figSCA = plt.figure(figsize=(18, 4))
        plt.pcolormesh(Z, A, abs(self.scalogram)**2)
        plt.axis("tight")
        plt.ylabel("wavelength [um]")
        plt.xlabel("position [um]")
        plt.show()        
        return figSCA
    
    def getWavelength(self):
        idx = np.argmax(abs(self.scalogram),0)
        wavelength = np.zeros(len(idx))
        for i in range(len(idx)):
            wavelength[i] = self.scale[idx[i]]
        self.wavelength = wavelength
        return True

    def plotWavelength(self, nbins=50, Display=False):
        n, _   = np.histogram(self.shift, bins=nbins)
        sy, _  = np.histogram(self.shift, bins=nbins, weights=self.wavelength)
        sy2, _ = np.histogram(self.shift, bins=nbins, weights=self.wavelength**2)
        mean = sy / n
        std = np.sqrt(sy2/n - mean*mean)
        figWL =  plt.figure(figsize=(18, 4))
        plt.errorbar((_[1:] + _[:-1])/2, mean, yerr=std, fmt="none")
        plt.ylabel("wavelength [um]")
        plt.xlabel("position [um]")
        if Display:
            plt.show()
        return figWL
    
    def loadInfo(self):
        self.probeDelay = self.getAttribute("Delay")
        self.probeCamX = self.getAttribute("ProbeCamX")
        self.objFocus = self.getAttribute("Y")
        self.objHeight = self.getAttribute("Z")
        
    def saveConfig(self):
        import pickle
        fileName = self.nameFile("PlasmaWave",".ini",True)
        with open(fileName,'w') as File:
            pickle.dump([path, date, run, shotNo, top, bottom, left, right, lineoutIndex, lineoutMask, resolution], File)        

    def loadConfig(self,FileName):
        import pickle
        with open(FileName) as File:
            a,b,c,d,e,f,g,h,i,j,i,k,l, = pickle.load(File)
        return a, b, c, d, e, f, g, h, i, j, k, l
            
    
        
        
class RegionOfInterest:
    def __init__(self, top, bottom, left, right):
        self.top = top
        self.bottom = bottom
        self.left = left
        self.right = right

        
def Morlet(N, w=5.0, s=1.0, complete=True):
    x = np.linspace(-s*2*np.pi, s*2*np.pi, N)
    output = np.exp(1j * w * x)
    if complete:
        output -= np.exp(-0.5 * (w**2))
        
    output *= np.exp(-0.5 * (x**2) * np.pi**(-0.25))    
    return output

def NaturalSample(M_octaves, N_voices=12):
    return np.exp( np.arange( np.ceil(M_octaves*N_voices) + 1 )/N_voices * np.log(2) )

def CWT(sig, w0=10, M_octaves=3, wavelet = "Morlet"):
    sig = np.asarray(sig, dtype=float)
    N = sig.shape[0]
  
    # equidistant sampling on the shift axis, materialized by a phaseshift of the FFT of the mother wavelet  
    phaseshift =  np.exp(-2j *  np.pi * np.arange(N) / N)
    SIG = fft(sig) * phaseshift
    
    # logorithmic sampling along the scale axis a 
    V_octaves = 12.
    a = NaturalSample(M_octaves) 
    M = a.shape[0]
    
    OUT = np.zeros((M,N), dtype = complex)
    if wavelet == "Morlet":
        for i in range(M):
            wlt = Morlet(N, w=w0, s=1.*a[i], complete=False) 

            OUT[i,:] = fftshift(ifft(SIG * fft(wlt) * a[i])) 
    return OUT