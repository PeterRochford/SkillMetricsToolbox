% How to create a Target diagram with multiple sets of data overlaid
% 
% An eighth example of how to create a target diagram given one set of
% reference observations and two sets of model predictions for the quantity.
% 
% This example shows how to display multiple data sets on the same target 
% diagram where a different color marker is used for each data set to
% identify its source. This is accomplished by overlaying the points from
% the second data set onto the target diagram created using the first data 
% set. Three data sets are used in this example where one is the reference
% and the other two are model predictions. This example also shows how to
% specify the legend using a map instead of a cell array.
% 
% The data sets are yearly time series for years 2001-2014 comprised of an 
% observation data set and two model predictions. The statistics needed for
% the target diagram have been precomputed and are stored in a data 
% structure. Details on the contents of the data structures (once loaded)
% can be obtained by simply entering the data structure variable name at 
% the command prompt, e.g. 
% >> target_stats1 = 
% 
%   struct with fields:
% 
%      bias: [14×1 double]
%     crmsd: [14×1 double]
%      rmsd: [14×1 double]
%      type: 'unnormalized'
%
% The data in these files are statistics calculated from yearly time series of 
% Standard Precipitation Index value over the Mekong basin, a trans-boundary 
% river in Southeast Asia that originates in the Tibetan Plateau and runs 
% through China's Yunnan Province, Myanmar, Laos, Thailand, Cambodia, and Vietnam. 
% The data sources are the ERA5 climate reanalysis dataset from the European 
% Centre for Medium-Range Weather Forecasts (ECMWF) and the Tropical Rainfall 
% Measuring Mission (TRMM 3B42 v7) satellite data, whilst the observation data is 
% the Asian Precipitation - Highly-Resolved Observational Data Integration 
% Towards Evaluation (APHRODITE V1801R1) rain-gauge data. All the statistics for 
% the yearly time series are calculated using the observations for 2001 as the 
% reference.
% 
% This data was provide courtesy of Iacopo Ferrario, Resources Scientist, 
% HR Wallingford, Flood and Water Resources group, Wallingford Oxfordshire,
% United Kingdom

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

% Read target statistics for ERA Interim (stats1) and TRMM (stats2) 
% data with respect to APHRODITE observations for each of years 2001 to 
% 2014 from a mat file
load('Mekong_Basin_data.mat'); % observations

% Specify labels for points in a map because only desire labels
% for each data set.
label = containers.Map({'ERA-5', 'TRMM'}, {'r', 'b'});

% Produce the target diagram for the first dataset
alpha = 0.0;
[hp, ht, axl] = target_diagram(target_stats1.bias,target_stats1.crmsd, ...
    target_stats1.rmsd, ...
    'alpha', alpha, ...
    'ticks',-2.0:0.5:2.0, 'limitAxis',2.0, ...
    'circles',0.5:0.5:2.0, 'circleLineSpec','--k', ...
    'circleLineWidth',1.0,'markerLabel',label,'markerKey', 'ERA-5');

% Overlay the second dataset
target_diagram(target_stats2.bias,target_stats2.crmsd, ...
    target_stats2.rmsd, ...
    'overlay','on', 'markerColor','b', 'alpha', alpha, ...
    'markerLabel',label,'markerKey', 'TRMM');

% Write plot to file
writepng(gcf,'target8.png');
