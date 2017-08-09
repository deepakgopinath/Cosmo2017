clear; clc; close all;

filenames = {'cellLR_Unperturbed.mat','cellLR_LM_Perturbed.mat', 'cellLR_FM_Perturbed.mat'};
trials = [96,200,200,200,200,200];
for i=1:length(filenames)
    load(filenames{i});
    if i==1
       [cov_distL , cov_distR, distri_velL, distri_velR, distri_envL, distri_envR] = compute_stats(cellL, cellR, trials(i));
    elseif i==2
       [cov_distL , cov_distR, distri_velL, distri_velR, distri_envL, distri_envR] = compute_stats(cellL_LM, cellR_LM, trials(i)); 
    else 
       [cov_distL , cov_distR, distri_velL, distri_velR, distri_envL, distri_envR] = compute_stats(cellL_FM, cellR_FM, trials(i));
    end
    figure;
    subplot(1,3,1);
    histogram(distri_velL(3,:, 20), 20, 'Normalization', 'probability'); 
    xlim([-1,1]);
    subplot(1,3,2);
    histogram(cov_distL, 20, 'Normalization', 'probability');
    subplot(1,3,3);
    histogram(mean(distri_envL, 2), 20, 'Normalization', 'probability');
end