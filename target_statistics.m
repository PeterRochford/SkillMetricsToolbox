function [stats] = target_statistics(predicted,reference,field,norm)
%TARGET_STATISTICS Calculate statistics needed to produce a target diagram
%
%   [STATS] = TARGET_STATISTICS(PREDICTED,REFERENCE,FIELD,NORM)
%   calculates the statistics needed to create a target diagram as 
%   described in Jolliff et al. (2009) using the data provided in the 
%   predicted field (PREDICTED) and the reference field (REFERENCE).
%
%   The statistics are returned in the STATS data structure.
%
%   If a data structure is provided for PREDICTED or REFERENCE, then 
%   the name of the field must be supplied in FIELD.
%
%   The function currently supports only data structures for the PREDICTED 
%   and REFERENCE variables, but will be extended to other variable types 
%   in future.
%
%   Input:
%   PREDICTED : predicted field
%   REFERENCE : reference field
%   FIELD     : name of field to use in PREDICTED and REFERENCE data 
%               structures (optional)
%   NORM      : logical flag specifying statistics are to be normalized 
%               with respect to standard deviaiton of reference field
%               = true,  statistics are normalized
%               = false, statistics are not normalized
%
%   Output:
%   STATS       : data structure containing statistics
%   STATS.BIAS  : bias (B)
%   STATS.CRMSD : centered root-mean-square (RMS) differences (E')
%   STATS.RMSD  : total RMS difference (RMSD)
%
%	Each of these outputs are one-dimensional with the same length.
%
%   Reference:
%
%   Jolliff, J. K., J. C. Kindle, I. Shulman, B. Penta, M. Friedrichs, 
%     R. Helber, and R. Arnone (2009), Skill assessment for coupled 
%     biological/physical models of marine systems, J. Mar. Sys., 76(1-2),
%     64-82, doi:10.1016/j.jmarsys.2008.05.014

% Validate input args
narginchk(2,4);

% Check for valid arguments
if isstruct(predicted)
    if ~exist('field')
        error('FIELD argument not supplied.');
    end
    if ~isfield(predicted, field)
        error(['Field is not in predicted data structure: ' field]);
    else
        p = getfield(predicted,field);
    end
else
    error('PREDICTED argument must be a data structure.');
end
if isstruct(reference)
    if ~exist('field')
        error('FIELD argument not supplied.');
    end
    if ~isfield(reference, field)
        error(['Field is not in reference data structure: ' field]);
    else
        r = getfield(reference,field);
    end
else
    error('REFERENCE argument must be a data structure.');
end

if ~exist('norm','var')
    norm = false;
end

% Check that dimensions of predicted and reference fields match
pdims= size(p);
rdims= size(r);
if length(pdims) ~= length(rdims)
    error(['Number of predicted and reference field dimensions do not' ...
        ' match.\n' ...
        'length(predicted)= ' num2str(length(size(p))) ...
        ', length(reference)= ' num2str(length(size(r))) ...
        ],class(pdims));
end
for i=1:length(pdims)
    if pdims(i) ~= rdims(i)
        error(['Predicted and reference field dimensions do not' ...
            ' match.\n' ...
            'size(predicted)= ' num2str(size(p)) ...
            ', size(reference)= ' num2str(size(r)) ...
            ],class(pdims));
    end
end

% Calculate bias (B)
bias = mean(p) - mean(r);

% Calculate centered root-mean-square (RMS) difference (E')
crmsd = centered_rms_dev(p,r);

% Calculate RMS difference (RMSD)
rmsd = sqrt(sum((p-r).^2)/length(p));

% Normalize if requested
if norm == true
    sigma_ref = std(r,1);
    bias = bias/sigma_ref;
    crmsd = crmsd/sigma_ref;
    rmsd = rmsd/sigma_ref;
end

% Store statistics in a data structure
stats.bias  = bias;
stats.crmsd = crmsd;
stats.rmsd = rmsd;
if norm == true
    stats.type = 'normalized';
else
    stats.type = 'unnormalized';
end

end
