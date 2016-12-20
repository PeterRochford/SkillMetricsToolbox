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
%   and REFERENCE variables, but will be extended to other variable types 
%   in future.
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

% Check for valid arguments
if isstruct(predicted)
    if ~isfield(predicted, field)
        error(['Field is not in predicted data structure: ' field]);
    else
        p = getfield(predicted,field);
    end
else
    error('PREDICTED argument must be a data structure.');
end
if isstruct(reference)
    if ~isfield(reference, field)
        error(['Field is not in reference data structure: ' field]);
    else
        r = getfield(reference,field);
    end
else
    error('REFERENCE argument must be a data structure.');
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

% Calculate correlation coefficient
ccoef = corrcoef(p,r);
ccoef = [1.0 ccoef(1,2)];

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
