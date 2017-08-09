function [ cov_distL , cov_distR, distri_velL, distri_velR, distri_envL, distri_envR] = compute_stats( cellL, cellR, num_trials)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

num_points = 5;
num_frames = 126;
cov_distL = [];
cov_distR = [];

for i=1:length(cellL) % over all walkers
    traj = cellL{i};
    [~, cm] = compute_cov_across_time(traj);
    cov_distL = [cov_distL cm];
end

for i=1:length(cellR) % over all walkers
    traj = cellR{i};
    [~, cm] = compute_cov_across_time(traj);
    cov_distR = [cov_distR cm];
%     cov_distR = [cov_distR compute_cov_across_time(traj)];
end

distri_velL = zeros((num_points*3), num_trials, size(traj,1) - 1);
for i=1:size(traj, 1)-1
%     data_across_subs = zeros(num_points*3, num_subjects);
    for j=1:num_trials
        traj = cellL{j};
        traj = diff(traj, 1); %compute velocity
        pos_at_frame_i = permute(traj(i,:,:), [2,3,1])';
        pos_at_frame_i = pos_at_frame_i(:);
        distri_velL(:, j, i) = pos_at_frame_i;
    end
end

distri_velR = zeros((num_points*3), num_trials, size(traj,1) - 1);
for i=1:size(traj, 1)
    for j=1:num_trials
        traj = cellR{j};
        traj = diff(traj, 1);
        pos_at_frame_i = permute(traj(i,:,:), [2,3,1])';
        pos_at_frame_i = pos_at_frame_i(:);
        distri_velR(:, j, i) = pos_at_frame_i;
    end
end

traj = cellL{1};
distri_envL = zeros(num_trials, size(traj, 1));
for i=1:size(traj, 1) %number of frames
    for j=1:num_trials
        traj = cellL{j};
        pos_at_frame_i = permute(traj(i,:,:), [2,3,1]);
        [~, v] = convhull(pos_at_frame_i);
        distri_envL(j, i) = v;
    end
end

traj = cellR{1};
distri_envR = zeros(num_trials, size(traj, 1));
for i=1:size(traj, 1) %number of frames
    for j=1:num_trials
        traj = cellR{j};
        pos_at_frame_i = permute(traj(i,:,:), [2,3,1]);
        [~, v] = convhull(pos_at_frame_i);
        distri_envR(j, i) = v;
    end
end


end

