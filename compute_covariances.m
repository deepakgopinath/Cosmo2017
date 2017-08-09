clear; clc; close all;
load('cellLR_Unperturbed.mat');
% load('cellLR_Normalized.mat');

num_subjects = 96;
num_points = 5;
num_frames = 126;

cov_ele_dist_L_Unperturbed = [];
cov_ele_dist_R_Unperturbed = [];

%distributions over elements of covariance matrices. 
for i=1:length(cellL) % over all walkers
    traj = cellL{i};
    cov_ele_dist_L_Unperturbed = [cov_ele_dist_L_Unperturbed compute_cov_across_time(traj)];
end

for i=1:length(cellR) % over all walkers
    traj = cellR{i};
    cov_ele_dist_R_Unperturbed = [cov_ele_dist_R_Unperturbed compute_cov_across_time(traj)];
end

%distribution over velocities at each time frame. 

distri_velL_for_each_frame_Unperturbed = zeros((num_points*3), num_subjects, size(traj,1) - 1);
for i=1:size(traj, 1)-1
%     data_across_subs = zeros(num_points*3, num_subjects);
    for j=1:num_subjects
        traj = cellL{j};
        traj = diff(traj, 1); %compute velocity
        pos_at_frame_i = permute(traj(i,:,:), [2,3,1])';
        pos_at_frame_i = pos_at_frame_i(:);
        distri_velL_for_each_frame_Unperturbed(:, j, i) = pos_at_frame_i;
    end
end

distri_velR_for_each_frame_Unperturbed = zeros((num_points*3), num_subjects, size(traj,1) - 1);
for i=1:size(traj, 1)
    for j=1:num_subjects
        traj = cellR{j};
        traj = diff(traj, 1);
        pos_at_frame_i = permute(traj(i,:,:), [2,3,1])';
        pos_at_frame_i = pos_at_frame_i(:);
        distri_velR_for_each_frame_Unperturbed(:, j, i) = pos_at_frame_i;
    end
end

%distribution of envelop information -  convexhull
traj = cellL{1};
envelopeL_dist_for_frames_Unperturbed = zeros(num_subjects, size(traj, 1));
for i=1:size(traj, 1) %number of frames
    for j=1:num_subjects
        traj = cellL{j};
        pos_at_frame_i = permute(traj(i,:,:), [2,3,1]);
        [~, v] = convhull(pos_at_frame_i);
        envelopeL_dist_for_frames_Unperturbed(j, i) = v;
    end
end

traj = cellR{1};
envelopeR_dist_for_frames_Unperturbed = zeros(num_subjects, size(traj, 1));
for i=1:size(traj, 1) %number of frames
    for j=1:num_subjects
        traj = cellR{j};
        pos_at_frame_i = permute(traj(i,:,:), [2,3,1]);
        [~, v] = convhull(pos_at_frame_i);
        envelopeR_dist_for_frames_Unperturbed(j, i) = v;
    end
end



