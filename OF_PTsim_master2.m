% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
filename='C:\Users\marcb\Desktop\OF_experimental_simulation\OF_401020_1ulh_2dcorrected\8113\U';
opt = detectImportOptions(filename);
opt = setvartype(opt, [1 3], 'double');
opt = setvaropts(opt, 'Prefixes', {'('}, 'Suffixes', {')'});
D = readmatrix(filename, opt);
l=length(D)-29;
ux=D(1:l,1);
uz=D(1:l,3);
U=sqrt(ux.^2+uz.^2);
% Load binary image of geometry
load('C:\Users\marcb\Downloads\Marc\Marc\Matlab\MarcGeom.mat')
binsX = 4096;
binsZ=4096;
% Geometry
G = abs(Geometry(:)-1);
% Create a mask
CAx = zeros(length(G),1);
CAz = zeros(length(G),1);
% use .raw instead - if you don't you will have to fix by hand as I'm doing here
mm = numel(U); bb = CAx(G>0);
r = length(bb)-mm;
% where there is no grain put the value in it
G(end-(r-1):end) = [];
CAx(G>0) = ux;
CAz(G>0) = uz;
% Vel Map
vMapz = reshape(CAz,binsZ,[]);
vMapx = reshape(CAx,binsX,[]);
% 
% im_4020=readmatrix('OF_slices\402020_1ulh_vel.csv');
% im=readmatrix('OF_slices\802020_1ulh_vel.csv');
%%%% Parameters for Simulation
a1=20; %sx
a2=20; %sy
a3=400000; %iverts dt
a4=250; %iverts thresh
a5=200; %Number of timesteps
[xg1,yg1]=meshgrid(1:1:4116,1:1:4096);
[sx, sy]= meshgrid(yg1(200:a1:1840,1),xg1(1,200:a2:1840));
for i=1:size(sx,1)
    if mod(i,2)==0
        sx(i,:)=sx(i,:)+10;
    end
end

verts=stream2(xg1,yg1,vMapx,vMapz, sx, sy);

for i = 1:length(verts)
    verts{i} = verts{i}(~isnan(verts{i}(:,1)),:) ;
end
addpath('C:\Users\marcb\Desktop\other_matlab_code')
verts2 = verts(cellfun('length',verts)>=5000);
verts3=verts2(1:3:end);
iverts=interpstreamspeed2(xg1,yg1,vMapx,vMapz,verts3,a3);

hold on
for i=1:length(iverts)-1
    plot(iverts{i}(:,1),iverts{i}(:,2))
end

ivert_thresh=a4;
iverts = iverts(cellfun(@(x) length(x) <= ivert_thresh, iverts));
xc=[];
yc=[];
tc=[];

for i = 1:length(iverts)
    x = iverts{1,i}(:,1);
    xc=[xc;{x}];
    y = iverts{1,i}(:,2);
    yc=[yc;{y}];
    t=[1:length(iverts{1,i}(:,2))];
    tc=[tc;{t}];
end

% figure;
% imshow(imcomplement(Geometry')); 
% hAxes = gca;

% hAxes.XAxis.Limits=[0 2000];%[0 4096];
% hAxes.YAxis.Limits=[0 2000];%[0 4116];
% hAxes.ZAxis.Limits=[-.0001 .0001];
% set(hAxes, 'XLim', [0 2000]);%[0 4096]);
% set(hAxes, 'YLim', [0 2000]);%[0 4116]);


% %create new position cells with randomly dropped particles
xc_new=xc;
yc_new=yc;


% 
idcell=find(cellfun('length',xc_new)>=10);
xc_long=[];
yc_long=[];
tc_long=[];

for i=1:length(idcell) 
    xc_long{i,1}=xc_new{idcell(i),1};
    yc_long{i,1}=yc_new{idcell(i),1};
    tc_long{i,1}=tc{idcell(i),1};
end

n=10;
new_xc=0;
new_yc=0;
x1=0;
y1=0;
new_traj=[];
xc_long=cellfun(@(x) x*n,xc_long,'un',0);
yc_long=cellfun(@(x) x*n,yc_long,'un',0);
idx_last=2;
% new_geo=imcomplement(Geometry);
% new_geo=new_geo(1:3000,1:2000);
% imshow(new_geo)
% hold on
% new_geo=ones(size(Geometry));
% new_geo=imresize(new_geo,n);
% [s,d] = cellfun(@size,xc_long);
% max_len = max([s,d]);
k=1;

folder='C:\Users\marcb\Desktop\OF_PTsim\500part_8x_speed_dropped\';
intermittent = 1;
for t = 1:a5
    new_geo=ones(2000,2000);
    new_geo=imresize(new_geo,n);
    for i=1:length(xc_long)
        idx = find(tc_long{i,1}==t,1,'first');
        if t>2
            idx_last = find(tc_long{i,1}==t-1,1,'first');
        end
        if ~isempty(idx)
            if idx<=length(xc_long{i,1})
%                 if i>1
%                     if done_list(i)==1
%                         xc_long{count+345,1}=xc_long{i,1};
%                         yc_long{count+345,1}=yc_long{i,1};
%                         i=count+345;
%                     end
%                 end
                x = xc_long{i,1}(idx);
                y = yc_long{i,1}(idx);
                if intermittent == 1

                    rand=randi(10);
                    if mod(rand,7)==0
                        newx=x;
                        newy=y;
                        x=NaN;
                        y=NaN;
                    end
                end
%         xc_new{i,1}(rowIndex(j),1)    = nan;
%         yc_new{i,1}(rowIndex(j),1)    = nan;
                xlast = xc_long{i,1}(idx_last);
                ylast = yc_long{i,1}(idx_last);
                if t>2
                    if abs(x-xlast)+abs(y-ylast)<.01
                        x=NaN;
                        y=NaN;
                    end
                end
                if y>2000*n-5*k*n||x>2000*n-4*k*n
                    x=NaN;
                    y=NaN;
                else
                    try
                        %Somewhat Gausian Particle
%                         % Bottom Section
                        new_geo(round(y)-4*k*n:round(y)-2*n*k,round(x)-2*n*k:round(x)+2*n*k)=.3;
                        new_geo(round(y)-5*n*k:round(y)-4*n*k,round(x)-1*n*k:round(x)+1*n*k)=.5;
                        % Middle Section
                        new_geo(round(y)-2*n*k:round(y)+2*n*k,round(x)-2*n*k:round(x)+2*n*k)=.2;
                        new_geo(round(y)-1*n*k:round(y)+1*n*k,round(x)-1*n*k:round(x)+1*n*k)=0;
                        new_geo(round(y)-3*n*k:round(y)+3*n*k,round(x)-3*n*k:round(x)-2*n*k)=.3;
                        new_geo(round(y)-3*n*k:round(y)+3*n*k,round(x)+2*n*k:round(x)+3*n*k)=.3;
                        new_geo(round(y)-2*n*k:round(y)+2*n*k,round(x)+3*n*k:round(x)+4*n*k)=.5;
                        new_geo(round(y)-2*n*k:round(y)+2*n*k,round(x)-4*n*k:round(x)-3*n*k)=.5;
                        % Top Section
                        new_geo(round(y)+4*n*k:round(y)+5*n*k,round(x)-1*n*k:round(x)+1*n*k)=.5;
                        new_geo(round(y)+2*n*k:round(y)+4*n*k,round(x)-2*n*k:round(x)+2*n*k)=.3;
                        %Brightfield Particle
%                         new_geo(round(y)-4*k*n:round(y)-2*n*k,round(x)-2*n*k:round(x)+2*n*k)=.7;
%                         new_geo(round(y)-5*n*k:round(y)-4*n*k,round(x)-1*n*k:round(x)+1*n*k)=.1;
%                         % Middle Section
%                         new_geo(round(y)-2*n*k:round(y)+2*n*k,round(x)-2*n*k:round(x)+2*n*k)=.2;
%                         new_geo(round(y)-1*n*k:round(y)+1*n*k,round(x)-1*n*k:round(x)+1*n*k)=0;
%                         new_geo(round(y)-3*n*k:round(y)+3*n*k,round(x)-3*n*k:round(x)-2*n*k)=.7;
%                         new_geo(round(y)-3*n*k:round(y)+3*n*k,round(x)+2*n*k:round(x)+3*n*k)=.7;
%                         new_geo(round(y)-2*n*k:round(y)+2*n*k,round(x)+3*n*k:round(x)+4*n*k)=.1;
%                         new_geo(round(y)-2*n*k:round(y)+2*n*k,round(x)-4*n*k:round(x)-3*n*k)=.1;
%                         % Top Section
%                         new_geo(round(y)+4*n*k:round(y)+5*n*k,round(x)-1*n*k:round(x)+1*n*k)=.1;
%                         new_geo(round(y)+2*n*k:round(y)+4*n*k,round(x)-2*n*k:round(x)+2*n*k)=.7;
%                         new_geo(round(y)+3*n*k:round(y)+4*n*k,round(x)-3*n*k:round(x)-3.5*n*k)=.1;

                    catch
                        x=NaN;
                        y=NaN;
                    end
                end
%                 if isnan(x)||isnan(y)
%                     new_xc(t:end,i)=NaN;
%                     new_yc(t:end,i)=NaN;
%                     done_list(i)=1;
%                     count=count+1;
%                 end
                if intermittent == 1
                    if mod(rand,7)==0
                        new_xc(t,i)=round(newx)/n;
                        new_yc(t,i)=round(newy)/n;
                    end
                else
                    new_xc(t,i)=round(x)/n;
                    new_yc(t,i)=round(y)/n;
                end
            end
        end
    end
    new_geo_resize=imresize(new_geo,1/n,'bicubic');
    imwrite(new_geo_resize, [folder,sprintf('Fig_%d.jpg', t)])
end
hold off
% 
writematrix(new_yc, 'C:\Users\marcb\Desktop\OF_PTsim\new\yc_500part_8xspeed_dropped.csv')
writematrix(new_xc, 'C:\Users\marcb\Desktop\OF_PTsim\new\xc_500part_8xspeed_dropped.csv')