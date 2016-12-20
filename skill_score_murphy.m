function ss = skill_score_murphy(predicted,reference)
%SKILL_SCORE_MURPHY Calculate nondimensional skill score (SS) between two variables
%
%   SS = SKILL_SCORE_MURPHY(PREDICTED,REFERENCE) calculates the 
%   nondimensional skill score (SS) difference between two variables 
%   PREDICTED and REFERENCE. The skill score is calculated using the
%   formula:
%
%   SS = 1 - RMSE^2/SDEV^2
%
%   where RMSE is the root-mean-squre error between the predicted and
%   reference values
%
%   (RMSE)^2 = sum_(n=1)^N (p_n - r_n)^2/N
%
%   and SDEV is the standard deviation of the reference values
%
%   SDEV^2 = sum_(n=1)^N [r_n - mean(r)]^2/(N-1)
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
%   SS : skill score
%
%   Reference:
%   Allan H. Murphy, 1988: Skill Scores Based on the Mean Square Error and
%   Their Relationships to the Correlation Coefficient. Mon. Wea. Rev.,
%   116, 2417–2424. 
%   doi: http://dx.doi.org/10.1175/1520-0493(1988)116<2417:SSBOTM>2.0.CO;2

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

% Calculate RMSE
rmse2 = rmse(predicted,reference)^2;

% Calculate standard deviation
sdev2 = std(reference)^2;

% Calculate skill score
ss = 1 - rmse2/sdev2;

end
