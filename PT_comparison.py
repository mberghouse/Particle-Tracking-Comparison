#This code will loop through a set of trajectory files from the UNIL code and calculates particle tracking comparison 
# statistics for UNIL. These statistics include the False Detection Rate (FN+FP)/TP, 
# the Euclidean distance between trajectories, and the path lengths of each trajectory.
import numpy as np
import pandas as pd
from pandas import DataFrame
from numpy import insert
import pims
import trackpy as tp
import os
import matplotlib  as mpl 
import matplotlib.pyplot as plt 

def euclidean_distance_unil(xc_unil,yc_unil,xc,yc,filename):
    index_unil=[]
    euclidean_dist_unil=[]

    unique_unil=[]
    yc_interp=yc
    xc_interp=xc
    for i in range(xc_unil.shape[0]):
        if '4xspeed' in filename:
            traj_len = 160
        elif '8xspeed' in filename:
            traj_len = 40
        else:
            traj_len = 640
        if xc_unil.iloc[i].count()>traj_len:
            unique_unil.append(i)
    #print (len(unique_TP), len(unique_unil))

    for i in unique_unil:
        y_unil=yc_unil.iloc[i]
        x_unil=xc_unil.iloc[i]
        unil_count=x_unil.count()
        idx=y_unil[y_unil.notnull()].index
        #if unil_c:
        for j in range(len(yc_interp.iloc[0])):
            y_sim=yc_interp[j].loc[idx]
            x_sim=xc_interp[j].loc[idx]
            sim_count=xc_interp[j].count()
            dist=np.sqrt((x_unil-x_sim)**2+(y_unil-y_sim)**2)
            if np.mean(dist)<2:
                euclidean_dist_unil.append([np.mean(dist), np.std(dist)])
                index_unil.append([i,j])
                #print (i,j)
        pd.DataFrame(euclidean_dist_unil).to_csv('distance/dist_'+filename)
    return euclidean_dist_unil
    
def calc_spurious_unil(x_sim,x_code, filename):
    count_spur=0
    count_true=0
    count_frame=0
    count_frame_true=0
    count_spur_list=[]
    count_true_list=[]
    count_spur_frame=[]
    count_true_frame=[]
    minimum=np.minimum(x_sim.shape[0],x_code.shape[1])
    for n in range(minimum):
        count_spur=count_spur+abs(x_sim.iloc[n].count()-x_code[n].count())
        count_true=count_true+x_sim.iloc[n].count()
        count_spur_list.append([n, count_spur])
        count_true_list.append([n, count_true])
        if n>1:
            count_frame=count_spur_list[n][1]-count_spur_list[n-1][1]
            count_frame_true=count_true_list[n][1]-count_true_list[n-1][1]
        count_true_frame.append([n,count_frame_true])
        count_spur_frame.append([n,count_frame])
        count_spur_frame_arr=pd.DataFrame(count_spur_frame)
        count_true_frame_arr=pd.DataFrame(count_true_frame)
    count_spur_frame_arr.to_csv('spurious/count_spur_'+filename)
    count_true_frame_arr.to_csv('spurious/count_true_'+filename)
    print (count_spur/count_true,minimum)
    return count_spur/count_true
    
def length_pdf_unil(xc,yc,xc_unil,yc_unil,filename):
    np_xc=np.array(xc_unil)
    np_yc=np.array(yc_unil)
    npx=np.array(xc)
    npy=np.array(yc)
    length_list_unil=[]
    for i in range(np_xc.shape[1]):
        length = np.sqrt(np.diff((np_xc[i]), axis=0)**2+np.diff((np_yc[i]), axis=0)**2)
        length_list_unil.append(np.nansum(length))
    DataFrame(length_list_unil).to_csv('length_pdf/length_unil_'+filename)
    length_list_sim=[]
    for i in range(len(npx[:,0])):
        length = np.sqrt(np.diff((npx[:,i]), axis=0)**2+np.diff((npy[:,i]), axis=0)**2)
        length_list_sim.append(np.nansum(length))
    DataFrame(length_list_sim).to_csv('length_pdf/length_sim_'+filename)
    return [np.mean(length_list_sim), np.std(length_list_sim),np.mean(length_list_unil), np.std(length_list_unil)]
    
# directory is where your UNIL trajectories and simulated tracjectories should be stored
directory='C:/Users/marcb/Desktop/ParticleTrackingComparison_FinalTrajectories/'
# Change your path to a directory that will store the results. In this directory, you must have the folders "spurious", "length_pdf", and "distance"
os.chdir('C:/Users/marcb/Desktop/ParticleTrackingComparison_results_test/')
percent_spurious_unil=[]
length_list_unil=[]
distance_unil=[]
for filename in os.listdir(directory)[:]:
    if 'xc_unil' in filename:
        x_code=pd.read_csv(os.path.join(directory,filename),header=None)
        new_fname='yc'+filename[2:]
        y_code = pd.read_csv(os.path.join(directory,new_fname),header=None)
        if 'dropped' in filename:
            x_sim_fname = filename[0:2]+filename[7:-12]+filename[-4:]
            y_sim_fname = new_fname[0:2]+new_fname[7:-12]+new_fname[-4:]
        elif 'glued' in filename:
            x_sim_fname = filename[0:2]+filename[7:-10]+filename[-4:]
            y_sim_fname = new_fname[0:2]+new_fname[7:-10]+new_fname[-4:]
        else:
            x_sim_fname = filename[0:2]+filename[7:-4]+filename[-4:]
            y_sim_fname = new_fname[0:2]+new_fname[7:-4]+new_fname[-4:]
        x_sim=pd.read_csv(os.path.join(directory,x_sim_fname),header=None)
        y_sim=pd.read_csv(os.path.join(directory,y_sim_fname),header=None)
        x_sim[x_sim==0]=np.nan
        y_sim[y_sim==0]=np.nan
        print (filename)
        #print ('Simulation filenames: ',x_sim_fname, y_sim_fname)
        percent_spurious_unil.append([calc_spurious_unil(x_sim,x_code,filename),filename])
        print ('spurious calculated')
        length_list_unil.append(length_pdf_unil(x_sim,y_sim,x_code,y_code,filename))
        print ('length pdfs calculated')
        distance_unil.append(euclidean_distance_unil(x_code,y_code,x_sim,y_sim,filename))
        print ('distances calculated')
