import matplotlib.pyplot as plt
import numpy as np
import scipy.constants as const
from IPython import display

def wakefield1d(a,param):
    import numpy as np
    nx = param[0]
    dx = param[1]
    kp = param[2]
    phi = np.zeros(nx)
    for i in range(2,nx): 
        	phi[i]= 2*phi[i-1]-phi[i-2] + 0.5*((1+a[i]**2)/(1+phi[i-1])**2-1)*dx**2*kp**2;    

    E = np.gradient(phi,dx*kp)
    n = np.gradient(E,dx*kp)
    
    return(phi, E, n)

def wakefield(a0,tau):

    from ipykernel.pylab.backend_inline import flush_figures

    lambda_0 = 0.8e-6
    I = (a0**2)/7.3*1e19*(lambda_0*1e6)**2
    n_e = 1e19*1e6   # n_e in [m^-3]
    omega_p = np.sqrt((n_e*const.e**2)/(const.m_e*const.epsilon_0))
    lambda_p = 2*np.pi*const.c/omega_p
    kp = 2*np.pi/lambda_p
    # define size of the "simulation box" [m]
    xmin = 0e-6
    xmax = 100e-6

    # number of cells
    nx = 10000
    dx = (xmax-xmin)/nx

    # setup mesh
    x = np.linspace(xmin,xmax,nx)
    phi = np.zeros(np.shape(x))
    
    #define a gaussian laser beam

    # normalized peak potential
    #a0 = 1.

    center = 20e-6

    tau = tau*1e-15
    ctau = const.c*tau

    # calculate envelope and potential
    envelope = a0*np.exp(-(x-center)**2/(2*ctau**2))
    a = envelope * np.sin(x/lambda_0*2*np.pi)
    
    for i in range(2,nx): # note that 2 initial data points are required
        phi[i]= 2*phi[i-1]-phi[i-2] + 0.5*((1+a[i]**2)/(1+phi[i-1])**2-1)*dx**2*kp**2;    

    E = np.gradient(phi,dx*kp)
    n = np.gradient(E,dx*kp)
        
    fig = plt.figure(1)
    
    ax = fig.add_subplot(111)
    ax.plot(x*1e6,a,'r',label='Laser')
    ax.plot(x*1e6,E,'b',label='E-field')
    ax.plot(x*1e6,n,'g',label='Density')
    ax.legend(loc=4)
    ax.set_xlabel('[$\mu m$]')
    ax.set_ylim(-1.2*a0,1.2*a0)
    flush_figures()
    print 'normalized peak intensity a0 =', a0
    print 'laser intensity:', round(I/1e18,2), 'x 1E18 W.cm-2'
    print 'pulse duration tau =', tau, 's'
    print 'electron density:',n_e/1e6, 'cm-3'
    #plt.show


def wakefield2d(a0,tau):

    from ipykernel.pylab.backend_inline import flush_figures

    lambda_0 = 0.8e-6
    I = (a0**2)/7.3*1e19*(lambda_0*1e6)**2
    n_e = 1e19*1e6   # n_e in [m^-3]
    omega_p = np.sqrt((n_e*const.e**2)/(const.m_e*const.epsilon_0))
    lambda_p = 2*np.pi*const.c/omega_p
    kp = 2*np.pi/lambda_p
    # define size of the "simulation box" [m]
    xmin = 0e-6
    xmax = 100e-6
    ymin = -20e-6
    ymax = 20e-6

    # number of cells
    nx = 10000
    dx = (xmax-xmin)/nx

    # setup mesh
    x = np.linspace(xmin,xmax,nx)
    phi = np.zeros(np.shape(x))
    
    #define a gaussian laser beam

    # normalized peak potential
    #a0 = 1.

    center = 20e-6

    tau = tau*1e-15
    ctau = const.c*tau

    # calculate envelope and potential
    envelope = a0*np.exp(-(x-center)**2/(2*ctau**2))
    a = envelope * np.sin(x/lambda_0*2*np.pi)
    
    for i in range(2,nx): # note that 2 initial data points are required
        phi[i]= 2*phi[i-1]-phi[i-2] + 0.5*((1+a[i]**2)/(1+phi[i-1])**2-1)*dx**2*kp**2;    

    E = np.gradient(phi,dx*kp)
    n = np.gradient(E,dx*kp)
        
    fig = plt.figure(1)
    
    ax = fig.add_subplot(111)
    ax.plot(x*1e6,a,'r',label='Laser')
    ax.plot(x*1e6,E,'b',label='E-field')
    ax.plot(x*1e6,n,'g',label='Density')
    ax.legend(loc=4)
    ax.set_xlabel('[$\mu m$]')
    ax.set_ylim(-1.2*a0,1.2*a0)
    flush_figures()
    print 'normalized peak intensity a0 =', a0
    print 'laser intensity:', round(I/1e18,2), 'x 1E18 W.cm-2'
    print 'pulse duration tau =', tau, 's'
    print 'electron density:',n_e/1e6, 'cm-3'
    #plt.show

def interactive_wakefield():
    from ipywidgets import interact, FloatSlider
    interact(wakefield,a0=FloatSlider(min=0.1,max=10,step=0.1,value=2),tau=FloatSlider(min=1.,max=30,step=0.1,value=15,description='tau [fs]'))



def wakefield2d(a0,tau,w0,plot):

    from scipy.ndimage.filters import gaussian_filter
    from ipykernel.pylab.backend_inline import flush_figures
    tau = tau*1e-15
    w0 = w0*1e-6
    lambda_0 = 0.8e-6
    I = (a0**2)/7.3*1e19*(lambda_0*1e6)**2
    n_e = 1e19*1e6   # n_e in [m^-3]
    omega_p = np.sqrt((n_e*const.e**2)/(const.m_e*const.epsilon_0))
    lambda_p = 2*np.pi*const.c/omega_p
    kp = 2*np.pi/lambda_p
    # define size of the "simulation box" [m]
    xmin = 0e-6
    xmax = 80e-6
    ymin = -20e-6
    ymax = 20e-6

    # number of cells
    nx = 1600
    ny = 50
    dx = (xmax-xmin)/nx

    # setup mesh
    x = np.linspace(xmin,xmax,nx)
    y = np.linspace(ymin,ymax,ny)
    X, Y = np.meshgrid(x[0:-1:10], y)

    phi2 = np.zeros([ny,nx])
    a2 = np.zeros([ny,nx])
    m = 0
    for yi in y:
    
        phi = np.zeros(np.shape(x))


        center = 15e-6
        ctau = const.c*tau

        # calculate envelope and potential
        waist = np.exp(-(yi)**2/(2*w0**2))
        envelope = a0*np.exp(-(x-center)**2/(2*ctau**2))
        a = envelope * waist * np.sin(x/lambda_0*2*np.pi)
        for i in range(2,nx): # note that 2 initial data points are required
            phi[i]= 2*phi[i-1]-phi[i-2] + 0.5*((1+a[i]**2)/(1+phi[i-1])**2-1)*dx**2*kp**2;    
        
        phi2[m,:] = phi
        a2[m,:] = a
        m+=1

        
    phi_small = phi2[:,0:-1:10]
    a_small = np.sqrt(2)*gaussian_filter(np.abs(a2[:,0:-1:10]),5)
    extent = [xmin*1e6,xmax*1e6,ymin*1e6,ymax*1e6]
    if plot == 'Phi':
        cax = plt.imshow(phi_small,aspect = 'auto',cmap='RdBu',interpolation='bilinear',extent=extent)
        plt.contour(X*1e6, Y*1e6, a_small,cmap='Greys')
        #plt.imshow(a_small,aspect = 'auto',cmap='RdBu')
    if plot == 'Ez':
        cax = plt.imshow(np.gradient(phi_small,axis=1),aspect = 'auto',cmap='RdBu',interpolation='bilinear',extent=extent)
        plt.contour(X*1e6, Y*1e6, a_small,cmap='Greys')

    if plot == 'Ex':
        cax = plt.imshow(np.gradient(phi_small,axis=0),aspect = 'auto',cmap='RdBu',interpolation='bilinear',extent=extent)
        plt.contour(X*1e6, Y*1e6, a_small,cmap='Greys')

    if a0 > 1:
        t = plt.text(5, -15, '$a_0>1$ - Model not valid!', fontsize=20,color='r',backgroundcolor='w',alpha=0.9)
        t.set_bbox(dict(facecolor='w', alpha=0.5, edgecolor='red'))

    plt.ylabel('x')
    plt.xlabel('z')

    cbar = plt.colorbar(cax)

    flush_figures();


def interactive_wakefield2d():
    from ipywidgets import interact, FloatSlider, ToggleButtons
    interact(wakefield2d,a0=FloatSlider(min=0.1,max=10,step=0.1,value=1),tau=FloatSlider(min=1.,max=30,step=0.1,value=15,description='tau [fs]'),w0=FloatSlider(min=1.,max=30,step=0.1,value=10,description='w0 [microns]'),plot=ToggleButtons(
    options=['Phi', 'Ez', 'Ex'],description='Plot:'));

