clear; clc; close all;
load('cellLR_Unperturbed.mat');
disp_ind = [1,3,2];
camera_angle = [-180, 0];
fps = 60;
num_points = 5; %number of points in the walker. 
qpoints = (0:0.05:2*pi);
amp_of_lm = 0.06*(1:1:4)';
phase_scale = pi/2;
freq_range = [5 7;
              7 9;
              9 11;
              11 13];
% amp_of_lm = 0.2;
min_freq = 5;
max_freq = 12;
num_trials = 200;
num_templates = 96;
%adj_matrix is used to look up the link connections of each dot in the
%figure. THis is need to detect the moemtary direction in which the local
%motion perturbation should take place. 
adj_matrix = [ 0 0 0 1 0;
               1 0 0 0 0;
               0 1 0 0 0;
               1 0 0 0 0;
               0 0 0 1 0
               ];
% adj_matrix = [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0;
%               0,0,0,0,0,1,0,0,0,0,0,0,0,0,0;
%               0,1,0,0,0,0,0,0,0,0,0,0,0,0,0;
%               0,0,1,0,0,0,0,0,0,0,0,0,0,0,0;
%               0,0,0,1,0,0,0,0,0,0,0,0,0,0,0;
%               0,1,0,0,0,0,0,0,0,0,0,0,0,0,0;
%               0,0,0,0,0,1,0,0,0,0,0,0,0,0,0;
%               0,0,0,0,0,0,1,0,0,0,0,0,0,0,0;
%               0,1,0,0,0,0,0,0,0,0,0,0,0,0,0;
%               0,0,0,0,0,0,0,0,1,0,0,0,0,0,0;
%               0,0,0,0,0,0,0,0,0,1,0,0,0,0,0;
%               0,0,0,0,0,0,0,0,0,0,1,0,0,0,0;
%               0,0,0,0,0,0,0,0,1,0,0,0,0,0,0;
%               0,0,0,0,0,0,0,0,0,0,0,0,1,0,0;
%               0,0,0,0,0,0,0,0,0,0,0,0,0,1,0;
%               ];
[I,J] = ind2sub(size(adj_matrix'),find(adj_matrix' == 1));
links = [J I]; %indices of connected links for each point. 
link_dirs = zeros(num_points, 3); 

cellL_LM = cell(num_trials, 1);
cellR_LM = cell(num_trials, 1);
num_frames = length(qpoints);
amp_for_trials_L = zeros(num_trials, 1); %to keep track of the amplitudes of the trials. 
template_for_trials_L = zeros(num_trials, 1); %waht template was perturbed for each trial.
amp_for_trials_R = zeros(num_trials, 1); %to keep track of the amplitudes of the trials. 
template_for_trials_R = zeros(num_trials, 1); %waht template was perturbed for each trial.

% for amps = 1:length(amp_of_lm)
%     rand_amp = amp_of_lm(amps);
%     cellL_LM = cell(num_trials, 1);
%     cellR_LM = cell(num_trials, 1);
for i=1:num_trials
    rand_template = randi(num_templates); % one of the 96 "templates" to alter; 
    rand_ind = randsample(length(amp_of_lm),1); %select the random amplitude. 
    rand_amp = amp_of_lm(rand_ind);
    rand_freq = freq_range(rand_ind, 1) + (freq_range(rand_ind, 2) - freq_range(rand_ind, 1))*rand;
%         rand_amp = amp_of_lm; %fix amplitude 
%     rand_freq_vec = max_freq*rand(num_points, 1); %diferent frequencies of modulation for 5 points. 
    rand_freq_vec = rand_freq*ones(num_points, 1); %same frequency for all points. 
    rand_phase = phase_scale*(2*rand(num_points, 1) - 1); %different phase fo each 5 points
%     rand_phase = 0; %zero phase for all sinusoids. 
    modulator = rand_amp*sin(rand_freq_vec.*qpoints + rand_phase);

    amp_for_trials_L(i) = rand_amp;
    template_for_trials_L(i) = rand_template;
    traj = cellL{rand_template};
%     traj(:,5,3) = traj(:,5,3) + 2;
%     traj(:,3,3) = traj(:,3,3) + 2;
    for j=1:num_frames %modulate the points at each time frame. 
        %compute the direction (s) in which the modulation should happen for
        %each point. at time frame (t), perturb the original "position" (r) of the ith point along s by a
        %amount given by the modulator(i, t)
        %grab positions at current frame. 
        curr_frame = permute(traj(j,:,:), [3,2,1])'; %num_points by 3 matrix.
        for k=1:num_points
            link_dirs(k, :) = curr_frame(links(k,2),:) - curr_frame(k, :);
        end
        curr_amp = modulator(:, j);
        curr_frame = curr_frame + repmat(curr_amp, 1, 3).*link_dirs; %apply the shift to the current 
        traj(j, :, :) = curr_frame; %replace the frame with the perturbed frame.
    end
    cellL_LM{i} = traj;
end

%     traj =  cellL_LM{1};
%     mdDisplay(camera_angle(1), 0.4, fps, traj(:,:,[1,3,2]));
%     traj =  cellL_LM{2};
%     mdDisplay(camera_angle(1), 0.4, fps, traj(:,:,[1,3,2]));

for i=1:num_trials
    rand_template = randi(num_templates); % one of the 96 "templates" to alter; 
    rand_ind = randsample(length(amp_of_lm),1); %select the random amplitude. 
    rand_amp = amp_of_lm(rand_ind);
    rand_freq = freq_range(rand_ind, 1) + (freq_range(rand_ind, 2) - freq_range(rand_ind, 1))*rand;
%         rand_amp = amp_of_lm; %same fixed amplitude for each points. 
%     rand_freq_vec = max_freq*rand(num_points, 1); %diferent frequencies of modulation for 5 points.
    rand_freq_vec = rand_freq*ones(num_points, 1);
    rand_phase = phase_scale*(2*rand(num_points, 1) - 1); %different phase fo each 5 points
%     rand_phase = 0;
    modulator = rand_amp*sin(rand_freq_vec.*qpoints + rand_phase);

    amp_for_trials_R(i) = rand_amp;
    template_for_trials_R(i) = rand_template;

    traj = cellR{rand_template};
%     traj(:,5,3) = traj(:,5,3) + 2;
%     traj(:,3,3) = traj(:,3,3) + 2;
    for j=1:num_frames %modulate the points at each time frame. 
        %compute the direction (s) in which the modulation should happen for
        %each point. at time frame (t), perturb the original "position" (r) of the ith point along s by a
        %amount given by the modulator(i, t)
        %grab positions at current frame. 
        curr_frame = permute(traj(j,:,:), [3,2,1])'; %num_points by 3 matrix.
        for k=1:num_points
            link_dirs(k, :) = curr_frame(links(k,2),:) - curr_frame(k, :);
        end
        curr_amp = modulator(:, j);
        curr_frame = curr_frame + repmat(curr_amp, 1, 3).*link_dirs; %apply the shift to the current 
        traj(j, :, :) = curr_frame; %replace the frame with the perturbed frame.
    end
    cellR_LM{i} = traj;
end
filename = strcat('cellLR_LM_Perturbed.mat');
save(filename, 'cellL_LM', 'cellR_LM','amp_for_trials_L', 'amp_for_trials_R', 'template_for_trials_L', 'template_for_trials_R');

% for i=1:num_trials
%     traj = cellL_LM{i};
%     mdDisplay(camera_angle(1), 0.4, 60, traj(:,1:end-2,disp_ind));
% %     traj(:,5,3) = traj(:,5,3) + 2;
% %     traj(:,3,3) = traj(:,3,3) + 2;
% %     mdDisplay(camera_angle(1), 0.4, 60, traj(:,:,disp_ind));
%     traj = cellR_LM{i};
%     mdDisplay(camera_angle(2), 0.4, 60, traj(:,1:end-2,disp_ind));
% end