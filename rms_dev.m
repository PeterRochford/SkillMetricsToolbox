function rmsd = rms_dev(predicted,reference)
%RMS_DEV Calculate the root-mean-square deviation between two variables
%
%   RMSD = RMS_DEV(PREDICTED,REFERENCE) calculates the root-mean-square
%   deviation between two variables PREDICTED and REFERENCE. The RMSD is 
%   calculated using the formula:
%
%   RMSD^2 = sum_(n=1)^N [(p_n - r_n)^2]/N
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
%   RMSD : root-mean-square deviation between predicted and reference

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
rmsd = sqrt(sum((predicted-reference).^2)/length(predicted));

end
