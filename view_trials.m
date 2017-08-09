clear; clc; close all;
% load('cellLR_Unperturbed.mat');
% num_trials = 96;
load('cellLR_FM_Perturbed.mat');
num_trials = 200;
disp_ind = [1,3,2];
camera_angle = [-180,0];
fps = 60;
speed =  0.35;
for i=1:num_trials
    traj = cellL_FM{i};
%     traj = cellL{i};
%     traj(:,[1,5,3],3) = traj(:,[1,5,3],3) + 2;
%     traj(:,5,3) = traj(:,5,3) + 2;
%     traj(:,3,3) = traj(:,3,3) + 2;
    mdDisplay(camera_angle(1), speed, fps, traj(:,:,disp_ind));
    
%     mdDisplay(camera_angle(1), speed, fps, traj(:,:,disp_ind));
    traj = cellR_FM{i};
% %     traj = cellR{i};
% %     traj(:,[1,5,3],3) = traj(:,[1,5,3],3) + 2;
    mdDisplay(camera_angle(2), speed, fps, traj(:,:,disp_ind));
end