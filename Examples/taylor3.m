% How to create a Taylor diagram with with modified axes and data point colors
%
% A third example of how to create a Taylor diagram given one set of
% reference observations and multiple model predictions for the quantity.
%
% This example is a variation on the second example (taylor2) where now the
% maximum scale for the standard deviation axis is increased, color
% properties are modified for the data points, and color & style properties
% are modified for the axes.
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
load('taylor_data.mat');

% Calculate statistics for Taylor diagram
% The first array element corresponds to the reference series for the
% while the second is that for the predicted series.
taylor_stats1 = taylor_statistics(pred1,ref,'data');
taylor_stats2 = taylor_statistics(pred2,ref,'data');
taylor_stats3 = taylor_statistics(pred3,ref,'data');

% Store statistics in arrays
sdev = [taylor_stats1.sdev(1); taylor_stats1.sdev(2); ...
    taylor_stats2.sdev(2); taylor_stats3.sdev(2)];
crmsd = [taylor_stats1.crmsd(1); taylor_stats1.crmsd(2); ...
    taylor_stats2.crmsd(2); taylor_stats3.crmsd(2)];
ccoef = [taylor_stats1.ccoef(1); taylor_stats1.ccoef(2); ...
    taylor_stats2.ccoef(2); taylor_stats3.ccoef(2)];

% Specify labels for points in a cell array (M1 for model prediction 1,
% etc.). Note that a label needs to be specified for the reference even
% though it is not used.
label = {'Non-Dimensional Observation', 'M1', 'M2', 'M3'};

% Produce the Taylor diagram
%
% Label the points and change the axis options for SDEV, CRMSD, and CCOEF.
% Increase the upper limit for the SDEV axis and rotate the CRMSD contour 
% labels (counter-clockwise from x-axis). Exchange color and line style
% choices for SDEV, CRMSD, and CCOEFF variables to show effect. Increase
% the line width of all lines.
%
% For an exhaustive list of options to customize your diagram, please 
% call the function without arguments:
%	>> taylor_diagram
[hp, ht, axl] = taylor_diagram(sdev,crmsd,ccoef, ...
    'markerLabel',label, 'markerLabelColor', 'r', ...
    'tickRMS',0.0:10.0:50.0,'tickRMSangle',110.0, ...
    'colRMS','g', 'styleRMS', ':', 'widthRMS', 2.0, ...
    'tickSTD',0.0:20.0:60.0, 'limSTD',60.0, ...
    'colSTD','b', 'styleSTD', '-.', 'widthSTD', 1.0, ...
    'colCOR','k', 'styleCOR', '--', 'widthCOR', 1.0);

% Write plot to file
writepng(gcf,'taylor3.png');
