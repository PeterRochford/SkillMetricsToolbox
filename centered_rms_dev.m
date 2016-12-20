function [crmsd] = centered_rms_dev(predicted,reference)
%CENTERED_RMS_DEV Calculate centered root-mean-square (RMS) difference 
%   between two variables E'
%
%   [CRMSD] = CENTERED_RMS_DEV(PREDICTED,REFERENCE) calculates the 
%   centered root-mean-square (RMS) difference between two variables 
%   PREDICTED and REFERENCE (E'). The latter is calculated using the
%   formula:
%
%   (E')^2 = sum_(n=1)^N [(p_n - mean(p))(r_n - mean(r))]^2/N
%
%   where p is the predicted values, r is the reference values, and
%   N is the total number of values in p & r. Note that p & r must
%   have the same number of values.
%
%   Input:
%   PREDICTED : predicted field
%   REFERENCE : reference field
%
%   Output:
%   CRMSDIFF : centered root-mean-square (RMS) difference (E')^2

% Validate input args
narginchk(2,2);

% Check that dimensions of predicted and reference fields match
pdims= size(predicted);
rdims= size(reference);
if length(pdims) ~= length(rdims)
    error(['Number of predicted and reference field dimensions do not' ...
        ' match.\n' ...
        'length(predicted)= ' num2str(length(size(predicted))) ...
        ', length(reference)= ' num2str(length(size(reference))) ...
        ],class(pdims));
end
for i=1:length(pdims)
    if pdims(i) ~= rdims(i)
        error(['Predicted and reference field dimensions do not' ...
            ' match.\n' ...
            'size(predicted)= ' num2str(size(predicted)) ...
            ', size(reference)= ' num2str(size(reference)) ...
            ],class(pdims));
    end
end

% Calculate means
pmean = mean(predicted);
rmean = mean(reference);

% Calculate (E')^2
crmsd = ((predicted - pmean) - (reference - rmean)).^2;
crmsd = sum(crmsd)/length(predicted);
crmsd = sqrt(crmsd);

end
