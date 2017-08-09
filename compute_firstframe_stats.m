clear; clc; close all;
load('cellLR.mat');
num_stimuli = 96;
frame_stack = zeros(num_stimuli, 3);
for i=1:num_stimuli
    frame_stack(i, :) = cellL{i}(1,:,end); %first frame for first point (point, dims, time_frame)
end