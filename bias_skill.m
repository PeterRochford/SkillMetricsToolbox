function b = bias_skill(predicted,reference)
%BIAS Calculate the bias between two variables (B)
%
%   B = BIAS_SKILL(PREDICTED,REFERENCE) calculates the bias between two variables 
%   PREDICTED and REFERENCE. The bias is calculated using the
%   formula:
%
%   B = mean(p) - mean(r)
%
%   where p is the predicted values, and r is the reference values. Note 
%   that p & r must have the same number of values.
%
%   Input:
%   PREDICTED : predicted field
%   REFERENCE : reference field
%
%   Output:
%   B : bias between predicted and reference

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
b = mean(predicted) - mean(reference);

end
