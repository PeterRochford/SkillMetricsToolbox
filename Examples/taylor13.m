% How to create a Taylor diagram with with no centered RMSD contours
%
% A thirteenth example of how to create a Taylor diagram given one set of
% reference observations and two sets of model predictions for the 
% quantity. This is a variant of example 12, but where the centered RMSD 
% contours are suppressed.
%
% This example shows how to display multiple data sets on the same Taylor 
% diagram where a different color marker is used for each data set to
% identify its source. This is accomplished by overlaying the points from
% the second data set onto the Taylor diagram created using the first data 
% set. Three data sets are used in this example where one is the reference
% and the other two are model predictions. This example also shows how to
% specify the legend using a dictionary instead of a list.
% 
% The data sets are yearly time series for years 2001-2014 comprised of an 
% observation data set and two model predictions. The statistics needed for
% the target diagram have been precomputed and are stored in a data 
% structure. Details on the contents of the data structures (once loaded)
% can be obtained by simply entering the data structure variable name at 
% the command prompt, e.g. 
% >> taylor_stats1 = 
% 
%   struct with fields:
% 
%      sdev: [15×1 double]
%     crmsd: [15×1 double]
%     ccoef: [15×1 double]
%
% The data in these files are statistics calculated from yearly time series
% of Standard Precipitation Index value over the Mekong basin, a 
% trans-boundary river in Southeast Asia that originates in the Tibetan 
% Plateau and runs through China's Yunnan Province, Myanmar, Laos, 
% Thailand, Cambodia, and Vietnam. The data sources are the ERA5 climate 
% reanalysis dataset from the European Centre for Medium-Range Weather 
% Forecasts (ECMWF) and the Tropical Rainfall Measuring Mission (TRMM 3B42 
% v7) satellite data, whilst the observation data is the Asian 
% Precipitation - Highly-Resolved Observational Data Integration Towards 
% Evaluation (APHRODITE V1801R1) rain-gauge data. All the statistics for 
% the yearly time series are calculated using the observations for 2001 as 
% the reference.
% 
% This data was provide courtesy of Iacopo Ferrario, Resources Scientist, 
% HR Wallingford, Flood and Water Resources group, Wallingford Oxfordshire,
% United Kingdom

% Author: Peter A. Rochford
%         Symplectic, LLC
%         www.thesymplectic.com
%         prochford@thesymplectic.com
%
% Created on Aug 18, 2019

% Close any previously open graphics windows
close all;

% Set the figure properties (optional)
set(gcf,'units','inches','position',[0,10.0,14.0,10.0]);
set(gcf,'DefaultLineLineWidth', 1.5); % linewidth for plots
set(gcf,'DefaultAxesFontSize',18); % font size of axes text

% Read target statistics for ERA Interim (stats1) and TRMM (stats2) 
% data with respect to APHRODITE observations for each of years 2001 to 
% 2014 from a mat file
load('Mekong_Basin_data_interannual.mat'); % observations

% Specify labels for points in a map because only desire labels
% for each data set.
label = containers.Map({'ERA-5', 'TRMM'}, {'r', 'b'});

% Produce the Taylor diagram for the first dataset
%
% For an exhaustive list of options to customize your diagram, please 
% call the function without arguments:
%	>> taylor_diagram
alpha = 0.0;
[hp, ht, axl] = taylor_diagram(taylor_stats1.sdev,taylor_stats1.crmsd, ...
    taylor_stats1.ccoef, 'titleRMS', 'off', 'showlabelsRMS', 'off', ...
    'tickRMS',0.0, 'alpha', alpha, 'markerLabel', label, ...
    'markerKey', 'ERA-5');

% Overlay the second dataset
[hp, ht, axl] = taylor_diagram(taylor_stats2.sdev,taylor_stats2.crmsd, ...
    taylor_stats2.ccoef, 'markerColor','b', ...
    'alpha', alpha, 'markerLabel', label, 'markerKey', 'TRMM', 'overlay','on');

% Write plot to file
writepng(gcf,'taylor13.png');
