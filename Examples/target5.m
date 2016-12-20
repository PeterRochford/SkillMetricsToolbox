% How to create a target diagram with a color bar
%
% A fifth example of how to create a target diagram given one set of
% reference observations and multiple model predictions for the quantity.
%
% This example is a variation on the third example (target3) where now the
% markers are displayed in a color spectrum corresponding to their RMSD. A
% color bar is automatically displayed showing the correspondence with the
% RMSD values. The x-axis label for uRMSD = 30 is also suppressed so the
% markers appear more clearly.
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
%         CSS-Dynamac (Contractor)
%         NOAA/NOS/NCCOS/CCMA/COAST
%         peter.rochford@noaa.gov

% Close any previously open graphics windows
close all;

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
% Label the points and change the axis options. Increase the upper limit
% for the axes, change color and line style of circles. Increase
% the line width of circles. Change color of labels and points. Add a
% legend. Suppress x-axis label for uRMSD = 30 so the markers appear more
% clearly.
%
% For an exhaustive list of options to customize your diagram, please 
% call the function without arguments:
%	>> target_diagram
[hp, ht, axl] = target_diagram(bias,crmsd,rmsd, ...
    'MarkerDisplayed','colorBar', 'titleColorbar', 'RMSD', ...
    'nonRMSDz', 'on', ...
    'markerLabel',label, 'markerLabelColor', 'b', 'markerColor', 'b', ...
    'markerLegend', 'on', ...
    'ticks',-50.0:10.0:50.0,'limitAxis',50.0, ...
    'xtickLabelPos',[-50:10:20 40 50], ...
    'circles',[20.0 40.0 50.0], 'circleLineSpec','-.b','circleLineWidth',1.0);

% Write plot to file
writepng(gcf,'target5.png');
