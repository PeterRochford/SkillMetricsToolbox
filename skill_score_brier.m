function bss = skill_score_brier(forecast,reference,observed)
%SKILL_SCORE_BRIER Calculate Brier skill score (BSS) between two variables
%
%   BSS = SKILL_SCORE_BRIER(FORECAST,REFERENCE,OBSERVED) calculates the 
%   non-dimensional skill score (SS) difference between two probabilities 
%   FORECAST and REFERENCE relative to OBSERVED outcomes. The skill 
%   score is calculated using the formula:
%
%   BSS = 1 - BS/BSref
%
%   where BS & BSref are the Brier scores for the forecast and reference
%   probability of event occurrence
%
%   BS    = sum_(n=1)^N (f_n - o_n)^2/N
%   BSref = sum_(n=1)^N (r_n - o_n)^2/N
%
%   where f is the forecast probabilities, r is the reference 
%   probabilities, o is the observed probabilities (0 or 1), and N is 
%   the total number of values in f, r, & o. Note that f, r, & o must 
%   have the same number of values.
%
%   Input:
%   FORECAST  : forecast probabilities
%   REFERENCE : reference probabilities
%   OBSERVED  : observed probabilities
%
%   Output:
%   BSS : Brier skill score
%
%   Reference:
%   Glenn W. Brier, 1950: Verification of forecasts expressed in terms 
%   of probabilities. Mon. Wea. Rev., 78, 1–23. 
%   doi: http://dx.doi.org/10.1175/1520-0493(1950)078%3C0001:VOFEIT%3E2.0.CO;2
%
%   D. S. Wilks, 1995: Statistical Methods in the Atmospheric Sciences. 
%   Cambridge Press. 547 pp.

% Validate input args
narginchk(3,3);

% Check that dimensions of forecast and reference fields match
fdims= size(forecast);
rdims= size(reference);
odims= size(observed);
if length(fdims) ~= length(rdims)
    error(['Number of forecast and reference field dimensions do not' ...
        ' match.\n' ...
        'length(forecast)= ' num2str(length(size(forecast))) ...
        ', length(reference)= ' num2str(length(size(reference))) ...
        ],class(fdims));
end
if length(fdims) ~= length(odims)
    error(['Number of forecast and observed field dimensions do not' ...
        ' match.\n' ...
        'length(forecast)= ' num2str(length(size(forecast))) ...
        ', length(observed)= ' num2str(length(size(observed))) ...
        ],class(fdims));
end

for i=1:length(fdims)
    if fdims(i) ~= rdims(i)
        error(['Predicted and reference field dimensions do not' ...
            ' match.\n' ...
            'size(forecast)= ' num2str(size(forecast)) ...
            ', size(reference)= ' num2str(size(reference)) ...
            ],class(fdims));
    end
end

% Calculate skill score
bss = 1 - brier_score(forecast,observed)/brier_score(reference,observed);

end
