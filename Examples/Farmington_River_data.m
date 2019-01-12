% Program to create a mat file of statistics on water temperatures 
% in the Farmington River basin of Connecticut.
% 
% This program was written to write data that is hard-coded into 
% the script to a mat file that could easily be read into Matlab. 
% 
% The data are stored in arrays named: sdev, crmsd, ccoef and gageID. Each 
% of these contain 1 reference value (first position) and 22 prediction 
% values, for a total of 23 values.
% 
% The source data is an observation set at each location as well as a 
% simulation set. The reference value is chosen that more or less represents 
% the consensus on acceptable values of the root-mean square error.
% 
% Author: Peter A. Rochford
%         Symplectic, LLC
%         www.thesymplectic.com
% 
% Created on Jan 6, 2019
% 
% @author: prochford@thesymplectic.com


disp('Storing statistics in arrays')

% Store statistics in arrays
sdev = [2., 3.14553461, 1.70174681, 2.05461789, 3.44820728, 3.331247, ...
  2.18986289, 1.97757902, 2.49535221, 1.93398277, 2.48857169, 3.94088987, ... 
  3.05299077, 1.73629794, 1.65421186, 1.97949903, 1.67482769, 2.34824349, ...
  3.00062646, 2.02561728, 2.82079116, 3.90890371, 2.89717094];

crmsd = [0., 3.03400143, 1.6354011, 1.89540252, 2.94991379, 3.26069125, ...
  1.82712869, 1.94384506, 1.93774371, 1.63024346, 2.36485667, 3.79410965, ...
  2.73408101, 1.71367031, 1.52986428, 1.43703818, 1.67181766, 2.27450201, ...
  2.85756379, 1.87334582, 2.74755423, 3.02473108, 0.7749413];

ccoef = [1., 0.92744094, 0.97859578, 0.9710517, 0.44332298, 0.91796932, ...
  0.96274239, 0.90789301, 0.76994947, 0.92060021, 0.81360916, 0.8042565, ...
  0.88938967, 0.97571, 0.90955152, 0.9103302, 0.92293029, 0.96556277, ...
  0.5011478, 0.91645338, 0.95567553, 0.62854216, 0.92057723];

% Specify gage identifiers (IDs) as a list
% Note that a label needs to be specified for the reference even
% though it is not used.
gageID = {'Obs', '14197', '14442', '14713', '14484', '14841', '15240', '15320', ... 
         '15516', '15571', '15790', '15792', '15825', '15844', '16058', '16059', ...
         '16060', '16066', '16091', '17338', '17364', '17365', '17437'};

% Save data to mat file
save Farmington_River_data sdev crmsd ccoef gageID

% Print summary

% Read in data from a mat file
clear all;
load('Farmington_River_data.mat');
ngage = length(gageID);
disp(['Number of gauges = ' num2str(ngage-1)])

disp('Finished')
