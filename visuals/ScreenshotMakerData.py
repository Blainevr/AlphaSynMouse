# Import Scene
import brainrender  # Scene handles the creation of your rendering!
import numpy as np 

import csv
def SSFromFile(file1,filename,timepoint,data,imgtitle):
    scene = brainrender.Scene(title=imgtitle) 
    with open(file1,'rt') as f:
        reader = csv.reader(f, delimiter=',', skipinitialspace=True)
        cols = next(reader)
        MPI3 = [float(i) for i in next(reader)]
        MPI6 = [float(i) for i in next(reader)]


        
        if not data:
            if timepoint==1:
                for i in range(0,len(cols)):
                    if MPI6[i]>0.05:
                        a=scene.add_brain_region(cols[i], alpha=MPI3[i],color='blue')
            elif timepoint==2:
                for i in range(0,len(cols)):
                    if MPI6[i]>0.05:
                        a=scene.add_brain_region(cols[i], alpha=MPI6[i],color='blue')
        else:
            if timepoint==1:
                for i in range(0,len(cols)):
                    a=scene.add_brain_region(cols[i], alpha=0.25*MPI3[i],color='blue')
            elif timepoint==2:
                for i in range(0,len(cols)):
                    a=scene.add_brain_region(cols[i], alpha=0.25*MPI6[i],color='blue')
            
    custom_cam= {
        'pos': (6392, -38377, -6043),
        'viewup': (0, 0, -1),
        'clippingRange': (33973, 52685),
        'focalPoint': (7454, 3628, -6425),
        'distance': 42020,
        }    
   
    scene.render(camera=custom_cam, zoom=1.7)
    scene.screenshot(name=filename)
    return;
brainrender.settings.SHOW_AXES = (
    False  # no axes
)    
    
SSFromFile('ModelTableF-91.csv','Test1',1,False,'F-91 Simulations 3 MPI')   
    
DataNamesList=[ "ReyTableF-65.csv",    "ReyTableF-91.csv",   "ReyTableFibrils.csv",    "ReyTableRibbons.csv"]

k12v=[0.10,1.33,2.55,3.78,5.00]
kapv=[0.01,0.50,1.00,1.50,2.00]
ScreenShotNameList=['Data F-65','Data F-91','Data Fibrils','Data Ribbons']
        
        

                    
for x in range(0,len(ScreenShotNameList)):
        d=True
        SSFromFile(DataNamesList[x],ScreenShotNameList[x],2,d,ScreenShotNameList[x]) 