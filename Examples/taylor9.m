% How to create a Taylor diagram with modified axes and data point colors
% that show co-located points.
%
% A ninth example of how to create a Taylor diagram given one set of
% reference observations and multiple model predictions for the quantity.
%
% This example is a variation on the fifth example (taylor5) where now a
% legend is added, axes titles are suppressed, and four points are co-located
% (i.e. overly each other). Symbols with transparent faces are used so the
% co-located points can be seen. The list of points are checked for those
% that agree within 1% of each other and reported to the screen.
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
set(gcf,'units','inches','position',[0,10.0,14.0,10.0]);
set(gcf,'DefaultLineLineWidth', 1.5); % linewidth for plots
set(gcf,'DefaultAxesFontSize',18); % font size of axes text

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

% Store statistics in arrays, making the fourth element a repeat of
% the first.
sdev = [taylor_stats1.sdev(1); taylor_stats1.sdev(2); ...
    taylor_stats2.sdev(2); taylor_stats3.sdev(2); ...
    taylor_stats1.sdev(2); 0.991*taylor_stats3.sdev(2)];
crmsd = [taylor_stats1.crmsd(1); taylor_stats1.crmsd(2); ...
    taylor_stats2.crmsd(2); taylor_stats3.crmsd(2); ...
    taylor_stats1.crmsd(2); taylor_stats3.crmsd(2)];
ccoef = [taylor_stats1.ccoef(1); taylor_stats1.ccoef(2); ...
    taylor_stats2.ccoef(2); taylor_stats3.ccoef(2); ...
    taylor_stats1.ccoef(2); taylor_stats3.ccoef(2)];

% Specify labels for points in a cell array (M1 for model prediction 1,
% etc.). Note that a label needs to be specified for the reference even
% though it is not used.
label = {'Non-Dimensional Observation', 'M1', 'M2', 'M3', 'M4', 'M5'};

% Check for duplicate statistics
duplicateStats = check_duplicate_stats(sdev(2:end),crmsd(2:end));

% Report duplicate statistics, if any
report_duplicate_stats(duplicateStats);

% Produce the Taylor diagram.
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
    'markerLabel',label, 'markerColor', 'r', 'markerLegend', 'on', ...
    'tickRMS',0.0:10.0:50.0, ...
    'colRMS','m', 'styleRMS', ':', 'widthRMS', 2.0, 'titleRMS', 'on', ...
    'tickSTD',0.0:20.0:60.0, 'limSTD',60.0, ...
    'colSTD','b', 'styleSTD', '-.', 'widthSTD', 1.0, 'titleSTD', 'on', ...
    'colCOR','k', 'styleCOR', '--', 'widthCOR', 1.0, 'titleCOR', 'on', ...
    'markerSize',14, 'alpha', 0.0);

% Universally change font size of axis tick label, axis label,
% and legend label.
% FontSize = 24;
% set(axl.std,'FontSize',FontSize);

% Change font size of only STD tick labels and axis labels
% axl.std.XAxis.FontSize = FontSize;
% axl.std.YAxis.FontSize = FontSize;

% Change fontsize of only STD axis labels
% xl = get(axl.std,'xlabel');
% yl = get(axl.std,'ylabel');
% xl.FontSize = FontSize; yl.FontSize = FontSize;

% Change font size of RMSD contour labels
% for i = 1:length(axl.rms.tickLabel)
%     axl.rms.tickLabel(i).FontSize = FontSize;
% end

% Change font size of only RMSD label
% for i = 1:length(axl.rms.XLabel)
%     axl.rms.XLabel(i).FontSize = FontSize;
% end

% Change font size of only CC label
% for i = 1:length(axl.cor.XLabel)
%     axl.cor.XLabel(i).FontSize = FontSize;
% end

% Change font size of legend
% hLegend = findobj(gcf, 'Type', 'Legend');
% set(hLegend,'FontSize',FontSize);

% Write plot to file
writepng(gcf,'taylor9.png');

