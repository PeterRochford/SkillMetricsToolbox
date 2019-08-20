% How to create a Taylor diagram with a large number of symbols of
% different color along with a legend.
% 
% A tenth example of how to create a Taylor diagram given one set of
% reference observations and multiple model predictions for the quantity.
% 
% Produces a Taylor diagram showing how data available from public sources 
% can be used to populate an acceptable model of water temperatures in the 
% Farmington River basin of Connecticut.
% 
% The data are stored in arrays named: sdev, crmsd, and ccoef. Each of these 
% contain 1 reference value (first position) and 22 prediction values, for a 
% total of 23 values. These arrays are stored in a container which is then written
% to a pickle file. A different file suffix is used depending upon whether the 
% file is created using Python 2 (.pkl) or Python 3 (.pkl3) because the pickle 
% package is not cross version compatible for pickle files containing containers 
% of dictionaries.
% 
% The source data is an observation set at each location as well as a 
% simulation set. The reference value is chosen that more or less represents 
% the consensus on acceptable values of the root-mean square error.
% 
% This data was provide courtesy of John Yearsley, Affiliate Professor,
% UW-Hydro|Computational Hydrology, University of Washington (Yearsley et al., 
% 2019).
%
% References:
% 
% Yearsley, J. R., Sun, N., Baptiste, M., and Nijssen, B. (2019) Assessing the 
%   Impacts of Hydrologic and Land Use Alterations on Water Temperature in the 
%   Farmington River Basin in Connecticut, Hydrol. Earth Syst. Sci. Discuss., 
%   https://doi.org/10.5194/hess-2019-94, 
%   https://www.hydrol-earth-syst-sci-discuss.net/hess-2019-94/hess-2019-94.pdf

% Author: Peter A. Rochford
%         Symplectic, LLC
%         www.thesymplectic.com
%         prochford@thesymplectic.com

% Close any previously open graphics windows
close all;

% Set the figure properties (optional)
set(gcf,'units','inches','position',[0,10.0,14.0,10.0]);
% set(gcf,'DefaultLineLineWidth',1.5); % linewidth for plots
set(gcf,'DefaultAxesFontSize',18); % font size of axes text

% Read in data from a mat file: sdev, crmsd, ccoef, and gageID
load('Farmington_River_data.mat');
    
% Change number of data points to illustrate effect of changing number 
% of columns
ncol = 2;
if ncol == 1
    sdev = sdev(1:12);
    crmsd = crmsd(1:12);
    ccoef = ccoef(1:12);
    gageID = gageID(1:12);
elseif ncol == 2
    % Use existing data
else
    sdev = [sdev sdev(2:12)];
    crmsd = [crmsd crmsd(2:12)];
    ccoef = [ccoef ccoef(2:12)];
    gageID = [gageID gageID(2:12)];
end

% Specify labels for points in a cell array using gage ID.
label = gageID;

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
    'markerLabel',label, 'markerLegend', 'on', ...
    'styleSTD', '-', 'colOBS','r', 'markerObs','o', ...
    'markerSize',12, 'tickRMS',0.0:1.0:3.0, ...
    'tickRMSangle', 115, 'showlabelsRMS', 'on', ...
    'titleRMS','on', 'titleOBS','Ref');

% Write plot to file
writepng(gcf,'taylor10.png');

