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
    
DataNamesList=[ "RModelTable1,1.csv",    "RModelTable2,1.csv",   "RModelTable3,1.csv",    "RModelTable4,1.csv",   "RModelTable5,1.csv",
    "RModelTable1,2.csv",   "RModelTable2,2.csv",    "RModelTable3,2.csv",    "RModelTable4,2.csv",    "RModelTable5,2.csv",
    "RModelTable1,3.csv",    "RModelTable2,3.csv",   "RModelTable3,3.csv",    "RModelTable4,3.csv",   "RModelTable5,3.csv",
    "RModelTable1,4.csv",    "RModelTable2,4.csv",    "RModelTable3,4.csv",    "RModelTable4,4.csv",    "RModelTable5,4.csv",
    "RModelTable1,5.csv",    "RModelTable2,5.csv",    "RModelTable3,5.csv",    "RModelTable4,5.csv",    "RModelTable5,5.csv"]

k12v=[0.10,1.33,2.55,3.78,5.00]
kapv=[0.01,0.50,1.00,1.50,2.00]
ScreenShotNameList=list()
for x in range(0,len(kapv)):
    for y in range(0,len(k12v)):
        ScreenShotNameList.append("3 MPI "+"k12="+str(k12v[y])+", K="+str(kapv[x]));
        ScreenShotNameList.append("6 MPI "+"k12="+str(k12v[y])+", K="+str(kapv[x]));
        
        

                    
for x in range(0,len(ScreenShotNameList)):
        d=False
        SSFromFile(DataNamesList[int(np.floor(x/2))],ScreenShotNameList[x],1+np.mod(x,2),d,ScreenShotNameList[x]) 