function bs = brier_score(forecast,observed)
%BRIER_SCORE Calculate Brier score (BS) between two variables
%
%   BS = BRIER_SCORE(PREDICTED,REFERENCE) calculates the Brier score (BS),
%   a measure of the mean-square error of probability forecasts for a 
%   dichotomous (two-category) event, such as the occurrence/non-occurrence 
%   of precipitation. The score is calculated using the formula:
%
%   BS = sum_(n=1)^N (f_n - o_n)^2/N
%
%   where f is the forecast probabilites, o is the observed probabilites 
%   (0 or 1), and N is the total number of values in f & o. Note that f & o 
%   must have the same number of values, and those values must be in the 
%   range [0,1].
%
%   Input:
%   FORECAST : forecast probabilites
%   OBSERVED  : observed probabilites
%
%   Output:
%   BS : Brier score
%
%   Reference:
%   Glenn W. Brier, 1950: Verification of forecasts expressed in terms 
%   of probabilities. Mon. Wea. Rev., 78, 1–23. 
%   doi: http://dx.doi.org/10.1175/1520-0493(1950)078%3C0001:VOFEIT%3E2.0.CO;2
%
%   D. S. Wilks, 1995: Statistical Methods in the Atmospheric Sciences. 
%   Cambridge Press. 547 pp.

% Validate input args
narginchk(2,2);

% Check that dimensions of forecast and observed fields match
fdims= size(forecast);
odims= size(observed);
if length(fdims) ~= length(odims)
    error(['Number of forecast and observed field dimensions do not' ...
        ' match.\n' ...
        'length(forecast)= ' num2str(length(size(forecast))) ...
        ', length(observed)= ' num2str(length(size(observed))) ...
        ],class(fdims));
end
for i=1:length(fdims)
    if fdims(i) ~= odims(i)
        error(['Predicted and observed field dimensions do not' ...
            ' match.\n' ...
            'size(forecast)= ' num2str(size(forecast)) ...
            ', size(observed)= ' num2str(size(observed)) ...
            ],class(fdims));
    end
end

% Check for valid values
index = ~(forecast >= 0 & forecast <= 1);
if sum(index) > 0
    error(['Forecast has values outside interval [0,1].']);
end
index = ~(observed == 1 | observed == 0);
if sum(index) > 0
    error(['Observed has values not equal to 0 or 1.']);
end

% Calculate score
bs = sum((forecast-observed).^2)/length(forecast);

end
