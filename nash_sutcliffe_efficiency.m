function nse = nash_sutcliffe_efficiency(predicted,reference)
%NASH_SUTCLIFFE_EFF Calculate the Nash-Sutcliffe efficiency
%
%   Calculates the Nash-Sutcliffe efficiency between two variables
%   PREDICTED and REFERENCE. The NSE is calculated using the
%   formula:
% 
%   NSE = 1 - sum_(n=1)^N (p_n - r_n)^2 / sum_(n=1)^N (r_n - mean(r))^2
% 
%   where p is the predicted values, r is the reference values, and
%   N is the total number of values in p & r. Note that p & r must
%   have the same number of values.
% 
%   Nash-Sutcliffe efficiency can range from -infinity to 1. An efficiency of
%   1 (E = 1) corresponds to a perfect match of modeled discharge to the
%   observed data. An efficiency of 0 (E = 0) indicates that the model
%   predictions are as accurate as the mean of the observed data, whereas an
%   efficiency less than zero (E < 0) occurs when the observed mean is a better
%   predictor than the model or, in other words, when the residual variance
%   (described by the numerator in the expression above), is larger than the
%   data variance (described by the denominator). Essentially, the closer the
%   model efficiency is to 1, the more accurate the model is.
% 
%   The efficiency coefficient is sensitive to extreme values and might yield
%   sub-optimal results when the dataset contains large outliers in it.
% 
%   Nash-Sutcliffe efficiency can be used to quantitatively describe the
%   accuracy of model outputs other than discharge. This method can be used to
%   describe the predictive accuracy of other models as long as there is
%   observed data to compare the model results to. For example, Nash-Sutcliffe
%   efficiency has been reported in scientific literature for model simulations
%   of discharge, and water quality constituents such as sediment, nitrogen,
%   and phosphorus loading.
% 
%   Input:
%   PREDICTED : predicted values
%   REFERENCE : reference values
% 
%   Output:
%   NSE : Nash-Sutcliffe Efficiency
%
%   Reference:
%   Nash, J. E.; Sutcliffe, J. V. 1970: River flow forecasting through 
%   conceptual models part I ? A discussion of principles. Journal of 
%   Hydrology. 10 (3): 282?290. 
%   doi:10.1016/0022-1694(70)90255-6

% Validate input args
narginchk(2,2);

% Check that dimensions of predicted and reference fields match
fdims= size(predicted);
odims= size(reference);
if length(fdims) ~= length(odims)
    error(['Number of predicted and reference field dimensions do not' ...
        ' match.\n' ...
        'length(predicted)= ' num2str(length(size(predicted))) ...
        ', length(reference)= ' num2str(length(size(reference))) ...
        ],class(fdims));
end
for i=1:length(fdims)
    if fdims(i) ~= odims(i)
        error(['Predicted and reference field dimensions do not' ...
            ' match.\n' ...
            'size(predicted)= ' num2str(size(predicted)) ...
            ', size(reference)= ' num2str(size(reference)) ...
            ],class(fdims));
    end
end

% Delete records with NaNs in both datasets first
I = ~isnan(predicted) & ~isnan(reference); 
predicted = predicted(I); reference = reference(I);

% Calculate the NSE
nse = 1 - (sum((predicted - reference).^2) / ...
           sum((reference - mean(reference)).^2));

end
