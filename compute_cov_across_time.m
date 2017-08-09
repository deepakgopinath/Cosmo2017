function [ cov_across_time, cov_metric ] = compute_cov_across_time( traj )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%     disp(traj);
    time_bin = [1];
    num_frames = size(traj, 1);
    bin_stamps = floor(num_frames.*time_bin);
    
    %flatten the 3D
    coords = zeros(size(traj,2)*size(traj,3), num_frames);
    for i=1:num_frames
        temp = permute(traj(i,:,:), [2,3,1])';
        coords(:, i) = temp(:);
    end
    cov_across_time = zeros((size(traj,2)*size(traj,3))^2,length(time_bin));
    cov_metric= 0;
    for i=1:length(bin_stamps)
%         c = cov(coords(:,1:bin_stamps(i))');
        c = corr(coords(:,1:bin_stamps(i))');
        cov_metric = sum(c(:).^2) - sum(diag(c).^2);
        cov_across_time(:,i) = c(:);
    end
    
end

