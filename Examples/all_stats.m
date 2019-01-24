% How to obtain all the statistical metrics within the skill metrics toolbox.
%
% This is a simple program that provides examples of how to calculate the 
% various skill metrics used or available in the toolbox. All the 
% calculated skill metrics are written to an Excel file for easy viewing
% and manipulation. The Matlab code is kept to a minimum.
%
% All functions in the Skill Metrics Toolbox are designed to only work with 
% one-dimensional arrays, e.g. time series of observations at a selected 
% location. The one-dimensional data are read in as data structures via a 
% mat file. The latter are stored in data structures in the format: ref.data,
% pred1.data, pred2.data, and pred3.data. The statistics are displayed to the 
% screen as well as written to an Excel file named all_stats.xls.
%
% The reference data used in this example are cell concentrations of a
% phytoplankton collected from cruise surveys at selected locations and 
% time. The model predictions are from three different simulations that
% have been space-time interpolated to the location and time of the sample
% collection. Details on the contents of the data structures (once loaded)
% can be obtained by simply entering the data structure variable name at 
% the command prompt, e.g. for Matlab
% >> ref
% ref = 
%          data: [57x1 double]
%          date: {57x1 cell}
%         depth: [57x1 double]
%      latitude: [57x1 double]
%     longitude: [57x1 double]
%       station: [57x1 double]
%          time: {57x1 cell}
%         units: 'cell/L'
%          jday: [57x1 double]
%
% while for Octave
%
% >> fieldnames(ref)
% ans =
% {
%   [1,1] = data
%   [2,1] = date
%   [3,1] = depth
%   [4,1] = latitude
%   [5,1] = longitude
%   [6,1] = station
%   [7,1] = time
%   [8,1] = units
%   [9,1] = jday
% }

% Author: Peter A. Rochford
%         Symplectic, LLC
%         www.thesymplectic.com
%         prochford@thesymplectic.com

% Read in data from a mat file
load('target_data.mat');

clear stats;

% Calculate various skill metrics, writing results to screen and file

% Get bias
stats.bias = bias_skill(pred1.data,ref.data);
disp(['Bias = ' num2str(stats.bias)])

% Get Root-Mean-Square-Deviation (RMSD)
stats.rmsd = rms_dev(pred1.data,ref.data);
disp(['RMSD = ' num2str(stats.rmsd)])

% Get Centered Root-Mean-Square-Deviation (CRMSD)
stats.crmsd = centered_rms_dev(pred1.data,ref.data);
disp(['CRMSD = ' num2str(stats.crmsd)])

% Get Standard Deviation (SDEV)
stats.sdev = std(pred1.data,1);
disp(['SDEV = ' num2str(stats.sdev)])

% Get correlation coefficient (r)
if (is_octave)
  % Use Octave function
  stats.ccoef = corr(pred1.data,ref.data); % Octave
else
  % Use Matlab function
  cc = corrcoef(pred1.data,ref.data);
  stats.ccoef = cc(1,2);
end
disp(['r = ' num2str(stats.ccoef)])

% Get Non-Dimensional Skill Score (SS)
stats.ss = skill_score_murphy(pred1.data,ref.data);
disp(['SS (Murphy) = ' num2str(stats.ss)])

% Get Brier Score (BS)
forecast = [0.7 0.9 0.8 0.4 0.2 0 0 0 0 0.1];
reference = [0.9 0.7 0.6 0.4 0.2 0 0 0 0 0.1];
observed = [1 1 1 1 1 0 0 0 0 1];
stats.bs = brier_score(forecast,observed);
disp(['BS (Brier) = ' num2str(stats.bs)])

% Get Brier Skill Score (BSS)
stats.bss = skill_score_brier(forecast,reference,observed);
disp(['BSS (Brier) = ' num2str(stats.bss)])

% Get Nash-Sutcliffe efficiency (NSE)
stats.nse = nash_sutcliffe_efficiency(pred1.data,ref.data);
disp(['NSE (Nash-Sutcliffe eff.) = ' num2str(stats.nse)])

% Write statistics to Excel file. Note that this is slow in Octave.
directory = pwd;
filename = [pwd '/all_stats.xlsx'];
if ispc
    write_stats(filename,stats,'overwrite',true);
else
    disp('Writing statistics in CSV format')
    write_stats_table(filename,stats,'overwrite',true);
end

% Calculate statistics for target diagram
target_stats1 = target_statistics(pred1,ref,'data');

% Write statistics to Excel file
filename = [pwd '/target_stats.xlsx'];
data = {target_stats1};
if ispc
    write_target_stats(filename,data,'overwrite','on');
else
    disp('Writing target statistics in CSV format')
    write_target_stats_table(filename,data,'overwrite','on');
end

% Calculate statistics for Taylor diagram
taylor_stats1 = taylor_statistics(pred1,ref,'data');
taylor_stats2 = taylor_statistics(pred2,ref,'data');
taylor_stats3 = taylor_statistics(pred3,ref,'data');

% Write statistics to Excel file
filename = [pwd '/taylor_stats.xlsx'];
data = {taylor_stats1, taylor_stats2, taylor_stats3};
title = {'Expt. 1', 'Expt. 2', 'Expt. 3'};
label = {'Observed', 'M1'};
if ispc
    write_taylor_stats(filename,data,'title',title,'label', label, ...
      'overwrite',true);
else
    disp('Writing Taylor statistics in CSV format');
    write_taylor_stats_table(filename,data,'title',title,'label', label, ...
        'overwrite','on');
end

% Check statistics for Taylor diagram
diff = check_taylor_stats(taylor_stats1.sdev, taylor_stats1.crmsd, ...
                          taylor_stats1.ccoef);
disp(['Difference in Taylor statistics = ' num2str(diff)]);
