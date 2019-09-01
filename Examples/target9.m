% How to create a target diagram with different symbols and colors
%
% A ninth example of how to create a target diagram with different 
% symbols and colors.
%
% This example is a variation on the fourth example (target4) where now the
% user controls the symbols and colors used.
%
% All functions in the Skill Metrics Toolbox are designed to only work with
% one-dimensional arrays, e.g. time series of observations at a selected
% location. The one-dimensional data are read in as data structures via a
% mat file. The latter are stored in data structures in the format:
% ref.data, pred1.data, pred2.dat, and pred3.dat. The plot is written to a
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

% Store statistics in arrays for first point
% bias = [target_stats1.bias; target_stats2.bias; target_stats3.bias];
% crmsd = [target_stats1.crmsd; target_stats2.crmsd; target_stats3.crmsd];
% rmsd = [target_stats1.rmsd; target_stats2.rmsd; target_stats3.rmsd];

% Specify labels for points in a map because only desire labels
% for each data set.
label = containers.Map({'Model 1', 'Model 2', 'Model 3'}, {'r+', 'kx', 'gs'});

% Produce the target diagram
%
% Label the points and change the axis options. Increase the upper limit
% for the axes, change color and line style of circles. Increase
% the line width of circles. Change color of labels and points. Add a
% legend.
%
% For an exhaustive list of options to customize your diagram, please 
% call the function without arguments:
%	>> target_diagram
[hp, ht, axl] = target_diagram(target_stats1.bias,target_stats1.crmsd, ...
    target_stats1.rmsd, ...
    'markerLabel',label,  'markerKey', 'Model 1', ...
    'ticks',-50.0:10.0:50.0,'limitAxis',50.0, ...
    'circles',[20.0 40.0 50.0], 'circleLineSpec','-.b','circleLineWidth',1.0);

% Overlay second data point (black) on existing diagram
target_diagram(target_stats2.bias,target_stats2.crmsd, ...
    target_stats2.rmsd, ...
    'overlay','on', 'alpha', alpha, ...
    'markerLabel',label,  'markerKey', 'Model 2');

% Overlay third data point (green) on existing diagram
target_diagram(target_stats3.bias,target_stats3.crmsd, ...
    target_stats3.rmsd, ...
    'overlay','on', 'alpha', alpha, ...
    'markerLabel',label,  'markerKey', 'Model 3');

% Write plot to file
writepng(gcf,'target9.png');
