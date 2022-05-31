% tracking2

% match - total number of selected matched points
% treshold - treshold for SURF, usually 0.0005
% temp - picture name string
% vid - video file name string

% xvel = velocity vector in x direction for each frame, pixel/s
% yvel = velocity vector in y direction for each frame
% angvel = angular velocity vector for each frame
% xpos = x position for each frame
% ypos = y position for each frame
% ang = angle of object for each frame
% xave = x position for each second
% yave = y position for each second
% xvave = velocity vector in x direction for each second, pixel/s
% yvave = velocity vector in y direction for each second
% angvave = angular velocity for each second

function [xvel,yvel,angvel,xpos,ypos,ang,xvave,yvave,xave,yave...
    angvave]=tracking2(match,treshold,temp,vid)

jump = 0;   % parameter for testing only

ImTemp=im2double(imread(temp));

obj=mmreader(vid);
a=read(obj);
frames=get(obj,'numberOfFrames');


% Get the Key Points
Options.upright=false;
Options.tresh=treshold;
IptsTemp=OpenSurf(ImTemp,Options);

D2 = reshape([IptsTemp.descriptor],64,[]);

xpos = [];
ypos = [];
% scalet = [];
% orient = [];
% descrpt = [];
ang = [];


for cnt=1:frames
    
    ImMes.input = im2double(a(:,:,:,cnt));
    Ipts1 = OpenSurf(ImMes.input);
    
    D1 = reshape([Ipts1.descriptor],64,[]);
    % Find the best matches
    err=zeros(1,length(Ipts1));
    cor1=1:length(Ipts1);
    cor2=zeros(1,length(Ipts1));
    for i=1:length(Ipts1),
        distance=sum((D2-repmat(D1(:,i),[1 length(IptsTemp)])).^2,1);
        [err(i),cor2(i)]=min(distance);
    end
    
    % Sort matches on vector distance
    [err, ind]=sort(err);
    cor1=cor1(ind);
    cor2=cor2(ind);
    
    %%% maybe insert a for loop here saying if enough points are found
    
    % Make vectors with the coordinates of the best matches
    Pos1=[[Ipts1(cor1).y]',[Ipts1(cor1).x]'];
    Pos2=[[IptsTemp(cor2).y]',[IptsTemp(cor2).x]'];
    Pos1=Pos1(1:match,:);
    Pos2=Pos2(1:match,:);
    
    % Find the center point of the tracked points
    Pave1x = sum(Pos1(:,2))/size(Pos1,1);
    Pave1y = sum(Pos1(:,1))/size(Pos1,1);
    Pave2x = sum(Pos2(:,2))/size(Pos2,1);
    Pave2y = sum(Pos2(:,1))/size(Pos2,1);
    
    % Can maybe improve the position of center by also utilize Pave2x/y
    
    xpos = [xpos Pave1x];
    ypos = [ypos Pave1y];
    
    % Calculate affine matrix
    Pos1(:,3)=1; Pos2(:,3)=1;
    M=Pos1'/Pos2';    % Pos2 is the template
    
    tang = M(1,2)/M(2,2);
    ang = [ang atan(tang)];

    if cnt ==1+jump
        xvel = 0;
        yvel = 0;
        angvel = 0;
    else
        xvel = [xvel (xpos(cnt-jump)-xpos(cnt-1-jump))*30];  % im pixel/s
        yvel = [yvel (ypos(cnt-jump)-ypos(cnt-1-jump))*30];
        angvel = [angvel (ang(cnt-jump)-ang(cnt-1-jump))*30];
    end
end

sec = floor(length(xvel)/30);
xvave = zeros(1,sec);
yvave = zeros(1,sec);
xave = zeros(1,sec);
yave = zeros(1,sec);
angvave = zeros(1,sec);
% angave = zeros(1,sec);

for cnt = 1:sec
    xvave(cnt) = sum(xvel((cnt-1)*30+1:cnt*30))/30;
    yvave(cnt) = sum(yvel((cnt-1)*30+1:cnt*30))/30;
    xave(cnt) = sum(xpos((cnt-1)*30+1:cnt*30))/30;
    yave(cnt) = sum(ypos((cnt-1)*30+1:cnt*30))/30;
    angvave(cnt) = sum(angvel((cnt-1)*30+1:cnt*30))/30;
    %angave(cnt) = sum(ang((cnt-1)*30+1:cnt*30))/30;
end

%%% Full range mapping
minx = min(xave);
maxx = max(xave);
miny = min(yave);
maxy = max(yave);
xave = (xave-minx)/(maxx-minx)*180;
yave = (yave-miny)/(maxy-miny)*180;

% %%% Relative Mapping
% minx = size(ImMes.input,2)/10;
% maxx = 9*minx;
% miny = size(ImMes.input,1)/10;
% maxy = 9*miny;
% xave = (xave-minx)/(maxx-minx)*180;
% yave = (yave-miny)/(maxy-miny)*180;





return