% How to create a target diagram with labeled data points
%
% A second example of how to create a target diagram given one set of
% reference observations and multiple model predictions for the quantity.
%
% This example is a variation on the first example (target1) where now the
% data points are labeled and axes properties are specified.
%
% All functions in the Skill Metrics Toolbox are designed to only work with
% one-dimensional arrays, e.g. time series of observations at a selected
% location. The one-dimensional data are read in as data structures via a
% mat file. The latter are stored in data structures in the format:
% ref.data, pred1.data, pred2.data, and pred3.data. The plot is written to a
% file in Portable Network Graphics (PNG) format.
%
% The reference data used in this example are cell concentrations of a
% phytoplankton collected from cruise surveys at selected locations and 
% time. The model predictions are from three different simulations that
% have been space-time interpolated to the location and time of the sample
% collection. Details on the contents of the data structures (once loaded)
% can be obtained by simply entering the data structure variable name at 
% the command prompt, e.g. 
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

% Author: Peter A. Rochford
%         Symplectic, LLC
%         www.thesymplectic.com
%         prochford@thesymplectic.com

% Close any previously open graphics windows
close all;

% Set the figure properties (optional)
set(gcf,'units','inches','position',[0,10.0,12.0,10.0]);
set(gcf, 'DefaultLineLineWidth', 1.5); % linewidth for plots
set(gcf,'DefaultAxesFontSize',18); % font size of axes text

% Read in data from a mat file
load('target_data.mat');

% Calculate statistics for target diagram
target_stats1 = target_statistics(pred1,ref,'data');
target_stats2 = target_statistics(pred2,ref,'data');
target_stats3 = target_statistics(pred3,ref,'data');

% Store statistics in arrays
bias = [target_stats1.bias; target_stats2.bias; target_stats3.bias];
crmsd = [target_stats1.crmsd; target_stats2.crmsd; target_stats3.crmsd];
rmsd = [target_stats1.rmsd; target_stats2.rmsd; target_stats3.rmsd];

% Specify labels for points in a cell array (M1 for model prediction 1,
% etc.).
label = {'M1', 'M2', 'M3'};

% Produce the target diagram
%
% Label the points and change the axis options for BIAS and CRMSD.
%
% For an exhaustive list of options to customize your diagram, please 
% call the function without arguments:
%	>> target_diagram
[hp, ht, axl] = target_diagram(bias,crmsd,rmsd, ...
    'markerLabel',label, ...
    'ticks',-50.0:10.0:50.0);

% Change fontsize of marker labels
% FontSize = 10;
% for i = 1:length(ht)
%     ht(i).FontSize = FontSize;
% end

% Write plot to file
writepng(gcf,'target2.png');
