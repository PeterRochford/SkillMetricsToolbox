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
%   and REFERENCE variables.
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

if ~exist('field','var')
    [p, r] = error_check_stats(predicted,reference);
else
    [p, r] = error_check_stats(predicted,reference,field);
end

if ~exist('norm','var')
    norm = false;
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
