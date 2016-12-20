function r=rmse(data,estimate)
%RMSE Calculate root-mean-square-error (RMSE) difference between two variables
%
%   R = RMSE(DATA,ESTIMATE) calculates the root-mean-square-error (RMSE)
%   between two variables DATA and ESTIMATE that are data vectors or
%   matrices. The RMSE is calculated using the formula:
%
%   (RMSE)^2 = sum_(n=1)^N (d_n - e_n)^2/N
%
%   where d is the data, e is the estimate, and N is the total number of
%   values in p & r. Note that d & e must have the same number of values.
%
%   Input:
%   DATA     : data values
%   ESTIMATE : estimate values
%
%   Output:
%   R : root-mean-square-error (RMSE)

% Validate input args
narginchk(2,2);

% Check that dimensions of data and estimate fields match
pdims= size(data);
rdims= size(estimate);
if length(pdims) ~= length(rdims)
    error(['Number of data and estimate field dimensions do not' ...
        ' match.\n' ...
        'length(data)= ' num2str(length(size(data))) ...
        ', length(estimate)= ' num2str(length(size(estimate))) ...
        ],class(pdims));
end
for i=1:length(pdims)
    if pdims(i) ~= rdims(i)
        error(['Predicted and estimate field dimensions do not' ...
            ' match.\n' ...
            'size(data)= ' num2str(size(data)) ...
            ', size(estimate)= ' num2str(size(estimate)) ...
            ],class(pdims));
    end
end
    
% Delete records with NaNs in both datasets first
I = ~isnan(data) & ~isnan(estimate); 
data = data(I); estimate = estimate(I);

% Calculate the RMSE
r=sqrt(sum((data(:)-estimate(:)).^2)/numel(data));

end
