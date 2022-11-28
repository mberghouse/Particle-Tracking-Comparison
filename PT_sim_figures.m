clear all

% cell2mat(len_pdf(1,1)) gives the length pdf for 1000 part, 4x speed Trackpy sim
% len_pdf(42,1) for unil
% len_pdf(5,1) and len(6,1) for TM
% change TM 1 to kalman and TM2 to LAP





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%  False positive + False Negative %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold off
directory='C:/Users/marcb/Desktop/ParticleTrackingComparison_results/spurious/';
addpath('C:/Users/marcb/Desktop/ParticleTrackingComparison_results/spurious/')
filenames=dir(directory);
spur_pdf=[]
count=0
for i=3:length(filenames)
    filename=filenames(i).name;
    lpdf=readmatrix(filename);    

    %%% Conditional for # of particles %%%
    if contains(filename,'1000')
        num=1000;
    elseif contains(filename,'2000')
        num=2000;
    else 
        num=500;
    end

    %%% Conditional for speed %%%
    if contains(filename,'4xspeed')
        s=4;
    elseif contains(filename,'8xspeed')
        s=16;
    else 
        s=1;
    end

    %%% Conditional for dropped %%%
    if contains(filename,'dropped')
        d=1;
    else 
        d=0;
    end

        %%% Conditional for true/spurious %%%
    if contains(filename,'count_true')
        t=1;
    else 
        t=0;
    end


    %%% Conditional for code %%%
    if contains(filename,'TP')
        code=1;
    elseif contains(filename,'TM')
        if contains(filename, 'kalman')
            code=2;
        else
            code=4;
        end        
    elseif contains(filename,'sim')
        code=3;
    else
        code=0;
    end

    if isnan(lpdf)
        count=count+1;
    else
        spur_pdf{i-count-2,1}=readmatrix(filename);
        spur_pdf{i-count-2,2}=num;
        spur_pdf{i-count-2,3}=s;
        spur_pdf{i-count-2,4}=d;
        spur_pdf{i-count-2,5}=code;
        spur_pdf{i-count-2,6}=t;
        spur_pdf{i-count-2,7}=mean(spur_pdf{i-count-2,1}(:,3));
    end   
end

c=cell2mat(spur_pdf(:,2:end));
%id_drop=find((c(:,4)==1)&(c(:,5)~=3));
id_true_unil=find((c(:,5)==1)&(c(:,4)==0)&(c(:,3)==0));
id_true_TP=find((c(:,5)==1)&(c(:,4)==1)&(c(:,3)==0));
id_true_TM=find((c(:,5)==1)&(c(:,4)==2)&(c(:,3)==0));
id_true_lap=find((c(:,5)==1)&(c(:,4)==4)&(c(:,3)==0));
id_false_unil=find((c(:,5)==0)&(c(:,4)==0)&(c(:,3)==0));
id_false_TP=find((c(:,5)==0)&(c(:,4)==1)&(c(:,3)==0));
id_false_TM=find((c(:,5)==0)&(c(:,4)==2)&(c(:,3)==0));
id_false_lap=find((c(:,5)==0)&(c(:,4)==4)&(c(:,3)==0));

id_true_unil_drop=find((c(:,5)==1)&(c(:,4)==0)&(c(:,3)==1));
id_true_TP_drop=find((c(:,5)==1)&(c(:,4)==1)&(c(:,3)==1));
id_true_TM_drop=find((c(:,5)==1)&(c(:,4)==2)&(c(:,3)==1));
id_true_lap_drop=find((c(:,5)==1)&(c(:,4)==4)&(c(:,3)==1));
id_false_unil_drop=find((c(:,5)==0)&(c(:,4)==0)&(c(:,3)==1));
id_false_TP_drop=find((c(:,5)==0)&(c(:,4)==1)&(c(:,3)==1));
id_false_TM_drop=find((c(:,5)==0)&(c(:,4)==2)&(c(:,3)==1));
id_false_lap_drop=find((c(:,5)==0)&(c(:,4)==4)&(c(:,3)==1));

speed_unil=c(id_false_unil,2);
true_unil=c(id_true_unil,6);
false_unil=c(id_false_unil,6);
particles_unil=c(id_false_unil,1);
speed_unil_drop=c(id_false_unil_drop,2);
true_unil_drop=c(id_true_unil_drop,6);
false_unil_drop=c(id_false_unil_drop,6);
particles_unil_drop=c(id_false_unil_drop,1);
%dropped_unil=c(id_false_unil,3);

speed_TM=c(id_false_TM,2);
true_TM=c(id_true_TM,6);
false_TM=c(id_false_TM,6);
particles_TM=c(id_false_TM,1);
speed_TM_drop=c(id_false_TM_drop,2);
true_TM_drop=c(id_true_TM_drop,6);
false_TM_drop=c(id_false_TM_drop,6);
particles_TM_drop=c(id_false_TM_drop,1);
%dropped_TM=c(id_false_TM,3);

speed_lap=c(id_false_lap,2);
true_lap=c(id_true_lap,6);
false_lap=c(id_false_lap,6);
particles_lap=c(id_false_lap,1);
speed_lap_drop=c(id_false_lap_drop,2);
true_lap_drop=c(id_true_lap_drop,6);
false_lap_drop=c(id_false_lap_drop,6);
particles_lap_drop=c(id_false_lap_drop,1);

speed_TP=c(id_false_TP,2);
true_TP=c(id_true_TP,6);
false_TP=c(id_false_TP,6);
particles_TP=c(id_false_TP,1);
speed_TP_drop=c(id_false_TP_drop,2);
true_TP_drop=c(id_true_TP_drop,6);
false_TP_drop=c(id_false_TP_drop,6);
particles_TP_drop=c(id_false_TP_drop,1);
%dropped_TP=c(id_false_TP,3);


figure(1)
scatter(speed_unil,false_unil./(false_unil+true_unil),particles_unil./4,[0 1 0],'filled','o','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
hold on
scatter(speed_TP,false_TP./(false_TP+true_TP),particles_TP./4,[0 0 1],'filled','s','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(speed_TM,false_TM./(false_TM+true_TM),particles_TM./4,[1 0 0],'filled','d','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(speed_lap,false_lap./(false_lap+true_lap),particles_lap./4,[1 1 0],'filled','^','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')

scatter(speed_unil_drop,false_unil_drop./(false_unil_drop+true_unil_drop),particles_unil_drop./4,[0 1 0],'filled','o','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(speed_TP_drop,false_TP_drop./(false_TP_drop+true_TP_drop),particles_TP_drop./4,[0 0 1],'filled','s','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(speed_TM_drop,false_TM_drop./(false_TM_drop+true_TM_drop),particles_TM_drop./4,[1 0 0],'filled','d','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(speed_lap_drop,false_lap_drop./(false_lap_drop+true_lap_drop),particles_lap_drop./4,[1 1 0],'filled','^','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')

%clim([0,3])
legend('UNIL','Trackpy','Trackmate (kalman)', 'Trackmate (LAP)')
%colorbar 
ax=gca;
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
xlabel('Relative Particle Speed')
ylabel('False Detection Rate')
title('Speed vs False Detection Rate (size represents number of particles)')
xlim([9e-1,20])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%  Euclidean Distance  %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hold off
directory='C:/Users/marcb/Desktop/ParticleTrackingComparison_results/distance/';
addpath('C:/Users/marcb/Desktop/ParticleTrackingComparison_results/distance/')
filenames=dir(directory);
dist_pdf=[]
count=0
for i=3:length(filenames)
    filename=filenames(i).name;
    lpdf=readmatrix(filename);    

    %%% Conditional for # of particles %%%
    if contains(filename,'1000')
        num=1000;
    elseif contains(filename,'2000')
        num=2000;
    else 
        num=500;
    end

    %%% Conditional for speed %%%
    if contains(filename,'4xspeed')
        s=4;
    elseif contains(filename,'8xspeed')
        s=16;
    else 
        s=1;
    end

    %%% Conditional for dropped %%%
    if contains(filename,'dropped')
        d=1;
    else 
        d=0;
    end



    %%% Conditional for code %%%
    if contains(filename,'TP')
        code=1;
    elseif contains(filename,'TM')
        if contains(filename, 'kalman')
            code=2;
        else
            code=4;
        end
    elseif contains(filename,'sim')
        code=3;
    else
        code=0;
    end

    if isnan(lpdf)
        count=count+1;
    else
        dist_pdf{i-count-2,1}=readmatrix(filename);
        dist_pdf{i-count-2,2}=num;
        dist_pdf{i-count-2,3}=s;
        dist_pdf{i-count-2,4}=d;
        dist_pdf{i-count-2,5}=code;
        if size(dist_pdf{i-count-2,1},2) > 3
            dist_pdf{i-count-2,7}=mean(mean(dist_pdf{i-count-2,1}(2:end,2:end),'omitnan'));
        else
            dist_pdf{i-count-2,7}=mean(dist_pdf{i-count-2,1}(1:end,3),'omitnan');
        end
        
    end   
end

c=cell2mat(dist_pdf(:,2:end));
id_unil=find((c(:,4)==0)&(c(:,3)==0));
id_TP=find((c(:,4)==1)&(c(:,3)==0));
id_TM=find((c(:,4)==2)&(c(:,3)==0));
id_lap=find((c(:,4)==4)&(c(:,3)==0));
id_unil_drop=find((c(:,4)==0)&(c(:,3)==1));
id_TP_drop=find((c(:,4)==1)&(c(:,3)==1));
id_TM_drop=find((c(:,4)==2)&(c(:,3)==1));
id_lap_drop=find((c(:,4)==4)&(c(:,3)==1));

speed_unil=c(id_unil,2);
particles_unil=c(id_unil,1);
dist_unil=c(id_unil,5);
speed_unil_drop=c(id_unil_drop,2);
particles_unil_drop=c(id_unil_drop,1);
dist_unil_drop=c(id_unil_drop,5);

speed_TM=c(id_TM,2);
particles_TM=c(id_TM,1);
dist_TM=c(id_TM,5);
speed_TM_drop=c(id_TM_drop,2);
particles_TM_drop=c(id_TM_drop,1);
dist_TM_drop=c(id_TM_drop,5);

speed_lap=c(id_lap,2);
particles_lap=c(id_lap,1);
dist_lap=c(id_lap,5);
speed_lap_drop=c(id_lap_drop,2);
particles_lap_drop=c(id_lap_drop,1);
dist_lap_drop=c(id_lap_drop,5);

speed_TP=c(id_TP,2);
particles_TP=c(id_TP,1);
dist_TP=c(id_TP,5);
speed_TP_drop=c(id_TP_drop,2);
particles_TP_drop=c(id_TP_drop,1);
dist_TP_drop=c(id_TP_drop,5);

figure(2)
scatter(speed_unil,dist_unil,particles_unil./4,[0 1 0],'filled','o','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
hold on
scatter(speed_TP,dist_TP,particles_TP./4,[0 0 1],'filled','s','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(speed_TM,dist_TM,particles_TM./4,[1 0 0],'filled','d','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(speed_lap,dist_lap,particles_lap./4,[1 1 0],'filled','^','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')

scatter(speed_unil_drop,dist_unil_drop,particles_unil_drop./4,[0 1 0],'filled','o','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(speed_TP_drop,dist_TP_drop,particles_TP_drop./4,[0 0 1],'filled','s','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(speed_TM_drop,dist_TM_drop,particles_TM_drop./4,[1 0 0],'filled','d','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(speed_lap_drop,dist_lap_drop,particles_lap_drop./4,[1 1 0],'filled','^','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')

%clim([0,3])
legend('UNIL','Trackpy','Trackmate (kalman)', 'Trackmate (LAP)')
%colorbar 
ax=gca;
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
xlabel('Relative Particle Speed')
ylabel('Distance (pixels)')
title('Euclidean Distance')
xlim([9e-1,20])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%   Velocity Angle Plots   %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hold off
directory='C:/Users/marcb/Desktop/ParticleTrackingComparison_results/vel_angle/';
addpath('C:/Users/marcb/Desktop/ParticleTrackingComparison_results/vel_angle/')
filenames=dir(directory);
vel_angle=[]
count=0
for i=3:length(filenames)
    filename=filenames(i).name;
    lpdf=readmatrix(filename);    

    %%% Conditional for # of particles %%%
    if contains(filename,'1000')
        num=1000;
    elseif contains(filename,'2000')
        num=2000;
    else 
        num=500;
    end

    %%% Conditional for speed %%%
    if contains(filename,'4xspeed')
        s=4;
    elseif contains(filename,'8xspeed')
        s=16;
    else 
        s=1;
    end

    %%% Conditional for dropped %%%
    if contains(filename,'dropped')
        d=1;
    else 
        d=0;
    end



    %%% Conditional for code %%%
    if contains(filename,'TP')
        code=1;
    elseif contains(filename,'TM')
        if contains(filename, 'kalman')
            code=2;
        else
            code=4;
        end
    elseif contains(filename,'velxc_unil')
        code=0;
    else
        code=3;
    end

    if isnan(lpdf)
        count=count+1;
    else
        vel_angle{i-count-2,1}=readmatrix(filename);
        vel_angle{i-count-2,2}=num;
        vel_angle{i-count-2,3}=s;
        vel_angle{i-count-2,4}=d;
        vel_angle{i-count-2,5}=code;
        angle=vel_angle{i-count-2,1}(:,2);
        angle(isnan(angle))=[];
        angle=mean(angle);
        vel=vel_angle{i-count-2,1}(:,3);
        vel(isnan(vel))=[];        
        vel(isinf(vel))=[];
        vel=vel(vel<1e3);
        vel=median(vel);
        vel_angle{i-count-2,7}=angle;
        vel_angle{i-count-2,8}=vel;

    end   
end

c=cell2mat(vel_angle(:,2:end));

% id_unil=find((c(:,4)==0)&(c(:,3)==0));
% id_TP=find((c(:,4)==1)&(c(:,3)==0));
% id_TM=find((c(:,4)==2)&(c(:,3)==0));
% id_lap=find((c(:,4)==4)&(c(:,3)==0));
id_unil_drop=find((c(:,4)==0)&(c(:,3)==1));
id_TP_drop=find((c(:,4)==1)&(c(:,3)==1));
id_TM_drop=find((c(:,4)==2)&(c(:,3)==1));
id_lap_drop=find((c(:,4)==4)&(c(:,3)==1));
id_sim=find(c(:,4)==3);

speed_unil=c(id_unil,2);
particles_unil=c(id_unil,1);
ang_unil=c(id_unil,5);
ang_unil_drop=c(id_unil_drop,5);
vel_unil=c(id_unil,6);
vel_unil_drop=c(id_unil_drop,6);
speed_unil_drop=c(id_unil_drop,2);
particles_unil_drop=c(id_unil_drop,1);
dist_unil_drop=c(id_unil_drop,5);

speed_TM=c(id_TM,2);
particles_TM=c(id_TM,1);
ang_TM=c(id_TM,5);
ang_TM_drop=c(id_TM_drop,5);
vel_TM=c(id_TM,6);
vel_TM_drop=c(id_TM_drop,6);
speed_TM_drop=c(id_TM_drop,2);
particles_TM_drop=c(id_TM_drop,1);

speed_lap=c(id_lap,2);
particles_lap=c(id_lap,1);
ang_lap=c(id_lap,5);
ang_lap_drop=c(id_lap_drop,5);
vel_lap=c(id_lap,6);
vel_lap_drop=c(id_lap_drop,6);
speed_lap_drop=c(id_lap_drop,2);
particles_lap_drop=c(id_lap_drop,1);

speed_TP=c(id_TP,2);
particles_TP=c(id_TP,1);
ang_TP=c(id_TP,5);
ang_TP_drop=c(id_TP_drop,5);
vel_TP=c(id_TP,6);
vel_TP_drop=c(id_TP_drop,6);
speed_TP_drop=c(id_TP_drop,2);
particles_TP_drop=c(id_TP_drop,1);

speed_sim=c(id_sim,2);
particles_lap=c(id_sim,1);
ang_sim=c(id_sim,5);
vel_sim=c(id_sim,6);


figure(2)
% scatter(ang_unil,vel_unil,particles_unil./4,[0 1 0],'filled','o','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
% hold on
% scatter(ang_TP,vel_TP,particles_TP./4,[0 0 1],'filled','s','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
% scatter(ang_TM,vel_TM,particles_TM./4,[1 0 0],'filled','d','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
% scatter(ang_lap,vel_lap,particles_lap./4,[1 1 0],'filled','^','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')

scatter(ang_unil_drop,vel_unil_drop,particles_unil_drop./4,[0 1 0],'filled','o','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
hold on
scatter(ang_TP_drop,vel_TP_drop,particles_TP_drop./4,[0 0 1],'filled','s','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(ang_TM_drop,vel_TM_drop,particles_TM_drop./4,[1 0 0],'filled','d','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(ang_lap_drop,vel_lap_drop,particles_lap_drop./4,[1 1 0],'filled','^','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(ang_sim,vel_sim,particles_sim./2,[0 0 0],'x',LineWidth=2)

%clim([0,3])
legend('UNIL','Trackpy','Trackmate (kalman)', 'Trackmate (LAP)', 'simulation')
%colorbar 
ax=gca;
set(gca, 'YScale', 'log')
xlabel('Turning Angle')
ylabel('Speed (pixels/frame)')
%title('Speed-Turning Angle PLot')
ylim([6e-1,20])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%   Path Length   %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hold off
directory='C:/Users/marcb/Desktop/ParticleTrackingComparison_results/length_pdf/';
addpath('C:/Users/marcb/Desktop/ParticleTrackingComparison_results/length_pdf/')
filenames=dir(directory);
len_pdf=[]
count=0
for i=3:length(filenames)
    filename=filenames(i).name;
    lpdf=readmatrix(filename);    

    %%% Conditional for # of particles %%%
    if contains(filename,'1000')
        num=1000;
    elseif contains(filename,'2000')
        num=2000;
    else 
        num=500;
    end

    %%% Conditional for speed %%%
    if contains(filename,'4xspeed')
        s=4;
    elseif contains(filename,'8xspeed')
        s=16;
    else 
        s=1;
    end

    %%% Conditional for dropped %%%
    if contains(filename,'dropped')
        d=1;
    else 
        d=0;
    end



    %%% Conditional for code %%%
    if contains(filename,'TP')
        code=1;
    elseif contains(filename,'TM')
        if contains(filename, 'kalman')
            code=2;
        else
            code=4;
        end
    elseif contains(filename,'sim')
        code=3;
    else
        code=0;
    end

    if isnan(lpdf)
        count=count+1;
    else
        len_pdf{i-count-2,1}=readmatrix(filename);
        len_pdf{i-count-2,2}=num;
        len_pdf{i-count-2,3}=s;
        len_pdf{i-count-2,4}=d;
        len_pdf{i-count-2,5}=code;
        len_pdf{i-count-2,7}=mean(len_pdf{i-count-2,1}(:,2));
    end   
end

c=cell2mat(len_pdf(:,2:end));

id_unil=find((c(:,4)==0)&(c(:,3)==0));
id_TP=find((c(:,4)==1)&(c(:,3)==0));
id_TM=find((c(:,4)==2)&(c(:,3)==0));
id_lap=find((c(:,4)==4)&(c(:,3)==0));
id_unil_drop=find((c(:,4)==0)&(c(:,3)==1));
id_TP_drop=find((c(:,4)==1)&(c(:,3)==1));
id_TM_drop=find((c(:,4)==2)&(c(:,3)==1));
id_lap_drop=find((c(:,4)==4)&(c(:,3)==1));
id_sim=find(c(:,4)==3);

speed_unil=c(id_unil,2);
particles_unil=c(id_unil,1);
dist_unil=c(id_unil,5);
speed_unil_drop=c(id_unil_drop,2);
particles_unil_drop=c(id_unil_drop,1);
dist_unil_drop=c(id_unil_drop,5);

speed_TM=c(id_TM,2);
particles_TM=c(id_TM,1);
dist_TM=c(id_TM,5);
speed_TM_drop=c(id_TM_drop,2);
particles_TM_drop=c(id_TM_drop,1);
dist_TM_drop=c(id_TM_drop,5);

speed_lap=c(id_lap,2);
particles_lap=c(id_lap,1);
dist_lap=c(id_lap,5);
speed_lap_drop=c(id_lap_drop,2);
particles_lap_drop=c(id_lap_drop,1);
dist_lap_drop=c(id_lap_drop,5);

speed_TP=c(id_TP,2);
particles_TP=c(id_TP,1);
dist_TP=c(id_TP,5);
speed_TP_drop=c(id_TP_drop,2);
particles_TP_drop=c(id_TP_drop,1);
dist_TP_drop=c(id_TP_drop,5);


figure(3)
n=5;
scatter(speed_unil,dist_unil,particles_unil./n,[0 1 0],'filled','o','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
hold on
scatter(speed_TP,dist_TP,particles_TP./n,[0 0 1],'filled','s','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(speed_TM,dist_TM,particles_TM./n,[1 0 0],'filled','d','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(speed_lap,dist_lap,particles_lap./n,[1 1 0],'filled','^','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(c(id_sim,2),c(id_sim,5),c(id_sim,1),'k','x',LineWidth=2)
scatter(speed_unil_drop,dist_unil_drop,particles_unil_drop./n,[0 1 0],'filled','o','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(speed_TP_drop,dist_TP_drop,particles_TP_drop./n,[0 0 1],'filled','s','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(speed_TM_drop,dist_TM_drop,particles_TM_drop./n,[1 0 0],'filled','d','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')
scatter(speed_lap_drop,dist_lap_drop,particles_lap_drop./n,[1 1 0],'filled','^','MarkerFaceAlpha',.4,'MarkerEdgeColor','k')

%clim([0,3])
legend('UNIL','Trackpy','Trackmate (kalman)', 'Trackmate (LAP)', 'Simulation')
%colorbar 
ax=gca;
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
xlabel('Relative Particle Speed')
ylabel('Mean Path Length (pixels)')
title('Speed vs Path Length')
xlim([9e-1,20])
ylim([4e-1,1.3e3])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Path Length PDFs %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%
%%%% Sim  %%%%%
%%%%%%%%%%%%%%%
p1000_1x_sim=cell2mat(len_pdf(50,1));
p1000_4x_sim=cell2mat(len_pdf(51,1));
p1000_16x_sim=cell2mat(len_pdf(53,1));
p2000_1x_sim=cell2mat(len_pdf(56,1));
% p2000_4x_sim=cell2mat(len_pdf(51,1));
% p2000_16x_sim=cell2mat(len_pdf(53,1));
p500_1x_sim=cell2mat(len_pdf(57,1));
p500_4x_sim=cell2mat(len_pdf(58,1));
p500_16x_sim=cell2mat(len_pdf(61,1));

%%%%%%%%%%%%%%%
%%% Trackpy %%%
%%%%%%%%%%%%%%%
%%% 1000 particles %%%
% 1000 particles, 1x speed, no drop
p1000_1x_drop0_TP=cell2mat(len_pdf(13,1));
% 1000 particles, 1x speed, drop
p1000_1x_drop1_TP=cell2mat(len_pdf(14,1));
% 1000 particles, 4x speed, no drop
p1000_4x_drop0_TP=cell2mat(len_pdf(1,1));
% 1000 particles, 4x speed, drop
p1000_4x_drop1_TP=cell2mat(len_pdf(2,1));
% 1000 particles, 16x speed, no drop
p1000_16x_drop0_TP=cell2mat(len_pdf(7,1));
% 1000 particles, 16x speed, drop
p1000_16x_drop1_TP=cell2mat(len_pdf(8,1));
%%% 2000 particles %%%
% 2000 particles, 1x speed, no drop
p2000_1x_drop0_TP=cell2mat(len_pdf(26,1));
% 2000 particles, 1x speed, drop
p2000_1x_drop1_TP=cell2mat(len_pdf(27,1));
% 2000 particles, 4x speed, no drop
%%p2000_4x_drop0_TP=cell2mat(len_pdf(1,1));
% 2000 particles, 4x speed, drop
%%p2000_4x_drop1_TP=cell2mat(len_pdf(2,1));
% 2000 particles, 16x speed, no drop
p2000_16x_drop0_TP=cell2mat(len_pdf(21,1));
% 2000 particles, 16x speed, drop
p2000_16x_drop1_TP=cell2mat(len_pdf(22,1));
input_vec={p1000_1x_drop0_TP;...
    p1000_4x_drop0_TP;p1000_16x_drop0_TP;...
    p1000_1x_sim;p1000_4x_sim;p1000_16x_sim};

b=logspace(0,4);
str = ["-";"-";"-";
       "--";"--";"--"];
colors=[[0 0 0];[0 .6 0];[.2 0 .5];...
    [.12 .12 .12];[0 1 0];[.4 0 1]];
figure(4)
for i=1:length(input_vec)
    [val,edges] = histcounts(cell2mat(input_vec(i,1)),b,'Normalization','pdf');
    plot(movmean(edges(2:end),5),movmean(val,5),str(i),'Color',[colors(i,:)] , LineWidth=2)
    hold on    
end

legend('1000 Particles 1x Trackpy',...
    '1000 Particles 4x Trackpy','1000 Particles 16x Trackpy',...
    '1000 Particles 1x Simulation','1000 Particles 4x Simulation','1000 Particles 16x Simulation')
%colorbar 
ax=gca;
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
% acid_axis4020_1ulh = h.BinEdges; acid_vel4020_1ulh = h.Values;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Spur PDFs %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Trackpy  %%%
p1000_1x_drop0_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p1000_1x_drop1_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p1000_4x_drop0_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p1000_4x_drop1_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p1000_16x_drop0_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p1000_16x_drop1_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));

p500_1x_drop0_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p500_1x_drop1_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p500_4x_drop0_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p500_4x_drop1_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p500_16x_drop0_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p500_16x_drop1_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));

p2000_1x_drop0_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p2000_1x_drop1_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p2000_4x_drop0_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p2000_4x_drop1_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p2000_16x_drop0_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p2000_16x_drop1_TP_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));

p1000_1x_drop0_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==1)));
p1000_1x_drop1_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==1)));
p1000_4x_drop0_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==1)));
p1000_4x_drop1_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==1)));
p1000_16x_drop0_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==1)));
p1000_16x_drop1_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==1)));

p500_1x_drop0_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==1)));
p500_1x_drop1_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==1)));
p500_4x_drop0_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==1)));
p500_4x_drop1_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==1)));
p500_16x_drop0_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==1)));
p500_16x_drop1_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==1)));

p2000_1x_drop0_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==1)));
p2000_1x_drop1_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==1)));
p2000_4x_drop0_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==1)));
p2000_4x_drop1_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==1)));
p2000_16x_drop0_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==1)));
p2000_16x_drop1_TP_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==1)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==1)));

%%% Kalman %%%
p1000_1x_drop0_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p1000_1x_drop1_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p1000_4x_drop0_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p1000_4x_drop1_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p1000_16x_drop0_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p1000_16x_drop1_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p1000_16x_drop0_kalman_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==1)));
p1000_1x_drop0_kalman_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==1)));

p500_1x_drop0_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p500_1x_drop1_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p500_4x_drop0_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p500_4x_drop1_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p500_16x_drop0_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p500_16x_drop1_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));

p2000_1x_drop0_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p2000_1x_drop1_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p2000_4x_drop0_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p2000_4x_drop1_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p2000_16x_drop0_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p2000_16x_drop1_kalman_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==2)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));

%%% LAP %%%
p1000_1x_drop0_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p1000_1x_drop1_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p1000_4x_drop0_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p1000_4x_drop1_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p1000_16x_drop0_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p1000_16x_drop1_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p1000_16x_drop0_lap_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==1)));

p500_1x_drop0_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p500_1x_drop1_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p500_4x_drop0_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p500_4x_drop1_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p500_16x_drop0_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p500_16x_drop1_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));

p2000_1x_drop0_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p2000_1x_drop1_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p2000_4x_drop0_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p2000_4x_drop1_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p2000_16x_drop0_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p2000_16x_drop1_lap_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==4)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));

%%% UNIL %%%
p1000_1x_drop0_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p1000_1x_drop1_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p1000_4x_drop0_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p1000_4x_drop1_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p1000_16x_drop0_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p1000_16x_drop1_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p1000_16x_drop0_unil_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==1000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==1)));

p500_1x_drop0_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p500_1x_drop1_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p500_4x_drop0_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p500_4x_drop1_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p500_16x_drop0_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p500_16x_drop1_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p500_16x_drop0_unil_true=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==500)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==1)));

p2000_1x_drop0_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p2000_1x_drop1_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==1)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p2000_4x_drop0_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p2000_4x_drop1_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==4)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));
p2000_16x_drop0_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==0)&(cell2mat(spur_pdf(:,6))==0)));
p2000_16x_drop1_unil_spur=cell2mat(spur_pdf((cell2mat(spur_pdf(:,5))==0)&(cell2mat(spur_pdf(:,2))==2000)&(cell2mat(spur_pdf(:,3))==16)&(cell2mat(spur_pdf(:,4))==1)&(cell2mat(spur_pdf(:,6))==0)));

%%% Trackpy  %%%
input_vec_TP={p2000_1x_drop0_TP_spur./p2000_1x_drop0_TP_true;p1000_1x_drop0_TP_spur./p1000_1x_drop0_TP_true;...
    p500_1x_drop0_TP_spur./p500_1x_drop0_TP_true;p1000_4x_drop0_TP_spur./p1000_4x_drop0_TP_true;...
    p500_4x_drop0_TP_spur./p500_4x_drop0_TP_true;p2000_16x_drop0_TP_spur./p2000_16x_drop0_TP_true;p1000_16x_drop0_TP_spur./p1000_16x_drop0_TP_true;...
     p500_16x_drop0_TP_spur./p500_16x_drop0_TP_true;};
%%% Kalman  %%%
input_vec_kalman={p2000_1x_drop0_kalman_spur./p2000_1x_drop0_TP_true;p1000_1x_drop0_kalman_spur./p1000_1x_drop0_kalman_true;p500_1x_drop0_kalman_spur./p500_1x_drop0_TP_true;...
    p2000_1x_drop1_kalman_spur./p2000_1x_drop0_TP_true;p1000_1x_drop1_kalman_spur./p1000_1x_drop0_kalman_true;p500_1x_drop1_kalman_spur./p500_1x_drop0_TP_true};
%%% LAP  %%%
input_vec_lap={p2000_1x_drop0_lap_spur./p2000_1x_drop0_TP_true;p1000_1x_drop0_lap_spur./p1000_1x_drop0_TP_true;p500_1x_drop0_lap_spur./p500_1x_drop0_TP_true;...
    p1000_4x_drop0_lap_spur./p1000_4x_drop0_TP_true;p500_4x_drop0_lap_spur./p500_4x_drop0_TP_true;p2000_16x_drop0_lap_spur./p2000_16x_drop0_TP_true;p1000_16x_drop0_lap_spur./p1000_16x_drop0_lap_true;...
     p500_16x_drop0_lap_spur./p500_16x_drop0_TP_true;};
%%% UNIL  %%%
input_vec_unil={p2000_1x_drop0_unil_spur(2:end,:)./p2000_1x_drop0_TP_true;p1000_1x_drop0_unil_spur(2:end,:)./p1000_1x_drop0_TP_true;p500_1x_drop0_unil_spur(2:end,:)./p500_1x_drop0_TP_true;...
    p1000_4x_drop0_unil_spur(2:end,:)./p1000_4x_drop0_TP_true;p500_4x_drop0_unil_spur(1:472,:)./p500_4x_drop0_TP_true;p1000_16x_drop0_unil_spur./p1000_16x_drop0_unil_true;...
     p500_16x_drop0_unil_spur./p500_16x_drop0_unil_true;};
% str = ["-";"--";':';"--";
%        ":";"-";"--";":"];
str = ["-";"--";':';
       "-";"--";":";];
% colors=[[0 0 0];[.12 .12 .12];[.24 .24 .24];[0 .6 0];[0 1 0];[.2 0 .4];...
%     [.3 0 .7];[.4 0 1]];
colors=[[0 0 0];[.12 .12 .12];[.24 .24 .24];[0 .4 0];[0 .7 0];[0 1 0]];
figure(4)
for i=1:length(input_vec_kalman)
    l=length(cell2mat(input_vec_kalman(i)));
    x=linspace(1,l,l);
    f=cell2mat(input_vec_kalman(i));
    plot(movmean(x,200),movmean(f(:,3),200),str(i),'Color',[colors(i,:)] , LineWidth=3)
    hold on    
end
% 
% legend('2000 Particles 1x Trackpy','1000 Particles 1x Trackpy','500 Particles 1x Trackpy',...
%     '1000 Particles 4x Trackpy','500 Particles 4x Trackpy','2000 Particles 16x Trackpy','1000 Particles 16x Trackpy',...
%     '500 Particles 16x Trackpy')
% 
legend('2000 Particles 1x Kalman','1000 Particles 1x Kalman','500 Particles 1x Kalman',...
    '2000 Particles Kalman dropped','1000 Particles 1x Kalman dropped','500 Particles Kalman dropped')

% legend('2000 Particles 1x LAP','1000 Particles 1x LAP','500 Particles 1x LAP',...
%     '1000 Particles 4x LAP','500 Particles 4x LAP','2000 Particles 16x LAP','1000 Particles 16x LAP',...
%     '500 Particles 16x LAP')

% legend('2000 Particles 1x UNIL','1000 Particles 1x UNIL','500 Particles 1x UNIL',...
%     '1000 Particles 4x UNIL','500 Particles 4x UNIL','2000 Particles 16x UNIL','1000 Particles 16x UNIL',...
%     '500 Particles 16x UNIL')
% %colorbar 
% ax=gca;
set(gca, 'YScale', 'log')
xlabel('Frame')
ylabel('False Detection Rate')
xlim([100,800])