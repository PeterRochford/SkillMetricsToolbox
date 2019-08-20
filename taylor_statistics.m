function [stats] = taylor_statistics(predicted,reference,field)
%TAYLOR_STATISTICS Calculate statistics needed to produce a Taylor diagram
%
%   [STATS] = TAYLOR_STATISTICS(PREDICTED,REFERENCE,FIELD) calculates the 
%   statistics needed to create a Taylor diagram as described in Taylor 
%   (2001) using the data provided in the predicted field (PREDICTED) and
%   the reference field (REFERENCE). FIELD is an optional argument
%   specifying the name of the field if PREDICTED or REFERENCE is a data
%   structure.
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
%               structures
%
%   Output:
%   STATS       : data structure containing statistics
%   STATS.CCOEF : correlation coefficients (R)
%   STATS.CRMSD : centered root-mean-square (RMS) differences (E')
%   STATS.SDEV  : standard deviations
%
%	Each of these outputs are one-dimensional with the same length. First
%	index corresponds to the reference series for the diagram. For example
%	SDEV(1) is the standard deviation of the reference series (sigma_r) 
%   and SDEV(2:N) are the standard deviations of the other (predicted) 
%   series.
%
%   Reference:
%
%   Taylor, K. E. (2001), Summarizing multiple aspects of model performance
%     in a single diagram, J. Geophys. Res., 106(D7), 7183–7192, 
%     doi:10.1029/2000JD900719.

% Validate input args
narginchk(2,3);

if ~exist('field','var')
    [p, r] = error_check_stats(predicted,reference);
else
    [p, r] = error_check_stats(predicted,reference,field);
end

% Calculate correlation coefficient
if (is_octave)
  % Use Octave function
  ccoef = corr(p,r); % Octave
  ccoef = [1.0 ccoef];
else
  % Use Matlab function
  ccoef = corrcoef(p,r);
  ccoef = [1.0 ccoef(1,2)];
end

% Calculate centered root-mean-square (RMS) difference (E')^2
crmsd = [0.0 centered_rms_dev(p,r)];

% Calculate standard deviation of predicted field w.r.t N (sigma_p)
sdevp = std(p,1);

% Calculate standard deviation of reference field w.r.t N (sigma_r)
sdevr = std(r,1);
sdev = [sdevr sdevp];

% Store statistics in a data structure
stats.ccoef  = ccoef;
stats.crmsd = crmsd;
stats.sdev = sdev;

end
