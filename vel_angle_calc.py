#Trackmate, trackpy, unil and sim vel and turning angle calculation
import statsmodels.api as sm
import numpy as np
import pandas as pd
import os
import matplotlib  as mpl 
import matplotlib.pyplot as plt 
import glob
import os
import cv2
import warnings
warnings.filterwarnings("ignore", category=RuntimeWarning) 
#directory should contain the UNIL and simulated trajectories
directory='C:/Users/marcb/Desktop/Filippo_new/'
#Change paths to the directory where you will save the results
os.chdir('C:/Users/marcb/Desktop/ParticleTrackingComparison_results_test/vel_angle/')
substring='z'
subc='xc'
suby='yc'
for filename in os.listdir(directory):
    print ('Working on ' + str(filename))
    if subc in filename:
        traj_stats=[]
        xc = pd.read_csv(os.path.join(directory,filename),header=None)
        new_fname='yc'+filename[2:]
        yc = pd.read_csv(os.path.join(directory,new_fname),header=None)
        xc[xc==0]=np.nan
        yc[yc==0]=np.nan
        frame_diff = 1
        for n in range(xc.shape[1]):
            x_diff = xc[n].diff()
            y_diff = yc[n].diff()
            vel=np.sqrt(x_diff**2+y_diff**2)
            angles=np.zeros((len(x_diff),1))
            for i in range(len(x_diff)-1):
                theta_1=np.arctan(y_diff.iloc[i]/x_diff.iloc[i])
                theta_2=np.arctan(y_diff.iloc[i+1]/x_diff.iloc[i+1])
                angles[i]=(theta_2-theta_1)*(180/np.pi)

            for count, val in enumerate (angles):
                if val==0:
                    angles[count]=np.nan
            vel=vel[0:len(angles)]

            traj_stats.append([n, angles,vel])
        angle_array=[]
        vel_array=[]
        for i in range(len(traj_stats)):
            section1=traj_stats[i][1]
            section1=np.reshape(section1,(len(section1),))
            section2=traj_stats[i][2]
            section2=np.reshape(section2,(len(section2),))
            angle_array=np.hstack([section1,angle_array])
            vel_array=np.hstack([section2,vel_array])
            final_array=np.vstack([np.transpose(angle_array)[0:len(vel_array)],np.transpose(vel_array)])
        pd.DataFrame(np.transpose(final_array)).to_csv('vel'+str(filename))

    elif suby in filename:
        break

    elif 'unil' in filename:
        traj_stats=[]
        xc = pd.read_csv(os.path.join(directory,filename),header=None)
        new_fname='yc'+filename[2:]
        yc = pd.read_csv(os.path.join(directory,new_fname),header=None)
        frame_diff = 1
        for n in range(xc.shape[0]):
            x_diff = xc.iloc[n].diff()
            y_diff = yc.iloc[n].diff()
            vel=np.sqrt(x_diff**2+y_diff**2)
            angles=np.zeros((len(x_diff),1))
            for i in range(len(x_diff)-1):
                theta_1=np.arctan(y_diff.iloc[i]/x_diff.iloc[i])
                theta_2=np.arctan(y_diff.iloc[i+1]/x_diff.iloc[i+1])
                angles[i]=(theta_2-theta_1)*(180/np.pi)
            for count, val in enumerate (angles):
                if val==0:
                    angles[count]=np.nan
            vel=vel[0:len(angles)]
            traj_stats.append([n, angles,vel])
        angle_array=[]
        vel_array=[]
        for i in range(len(traj_stats)):
            section1=traj_stats[i][1]
            section1=np.reshape(section1,(len(section1),))
            section2=traj_stats[i][2]
            section2=np.reshape(section2,(len(section2),))
            angle_array=np.hstack([section1,angle_array])
            vel_array=np.hstack([section2,vel_array])
            final_array=np.vstack([np.transpose(angle_array)[0:len(vel_array)],np.transpose(vel_array)])            
        pd.DataFrame(np.transpose(final_array)).to_csv('vel'+str(filename))

    else:
        continue
        # t1 = pd.read_csv(os.path.join(directory,filename))
        # unique_part=[]
        # for i in t1.particle.unique():
            # unique_part.append(i)
        # unique_part = [x for x in unique_part if str(x) != 'nan']
        # traj_stats=[]
        # dist=[]
        # count=0
        # for n in range(len(unique_part)):
            # tslice=t1.particle==unique_part[n]
            # traj_x=t1[tslice].sort_values(['frame']).x
            # traj_y=t1[tslice].sort_values(['frame']).y
            # frame=t1[tslice].sort_values(['frame']).frame
            # frame_diff=frame.diff()
            # x_diff=traj_x.diff()
            # y_diff=traj_y.diff()
            # vel_dist=np.sqrt(x_diff**2+y_diff**2)
            # vel=np.reshape(vel_dist.values,[len(vel_dist),1])/np.reshape(frame_diff.values,[len(vel_dist),1])
            # angles=np.zeros((len(x_diff),1))
            # for i in range(len(x_diff)-1):
                # theta_1=np.arctan(y_diff.iloc[i]/x_diff.iloc[i])
                # theta_2=np.arctan(y_diff.iloc[i+1]/x_diff.iloc[i+1])
                # angles[i]=(theta_2-theta_1)*(180/np.pi)
            # for count, val in enumerate (angles):
                # if val==0:
                    # angles[count]=np.nan
            # vel=vel[0:len(angles)]
            # traj_stats.append([n, angles,vel])
        # angle_array=[]
        # vel_array=[]
        # for i in range(len(traj_stats)):
            # section1=traj_stats[i][1]
            # section1=np.reshape(section1,(len(section1),))
            # section2=traj_stats[i][2]
            # section2=np.reshape(section2,(len(section2),))
            # angle_array=np.hstack([section1,angle_array])
            # vel_array=np.hstack([section2,vel_array])
            # final_array=np.vstack([np.transpose(angle_array)[0:len(vel_array)],np.transpose(vel_array)])
        # pd.DataFrame(np.transpose(final_array)).to_csv('vel'+str(filename))

