function [p,r] = error_check_stats(predicted,reference,field)
%ERROR_CHECK_STATS Checks the arguments provided to the statistics functions for the target and Taylor diagrams.
%
%   [P,R] = ERROR_CHECK_STATS(PREDICTED,REFERENCE,FIELD)
%   Checks the arguments provided to the statistics functions for the
%   target and Taylor diagrams. The data is provided in the predicted 
%   field (PREDICTED) and the reference field (REFERENCE).
%     
%   If a dictionary is provided for PREDICTED or REFERENCE, then 
%   the name of the field must be supplied in FIELD.
%
%   The function currently supports only data structures for the PREDICTED 
%   and REFERENCE variables.
%
%   Output:
%   P : predicted field values
%   R : reference field values  

% Author: Peter A. Rochford
%         Symplectic, LLC
%         www.thesymplectic.com
%         prochford@thesymplectic.com

% Check for valid arguments
if isstruct(predicted)
    if ~exist('field')
        error('FIELD argument not supplied.');
    end
    if ~isfield(predicted, field)
        error(['Field is not in predicted data structure: ' field]);
    else
        p = getfield(predicted,field);
    end
elseif isnumeric(predicted)
    p = predicted;
else
    error('PREDICTED argument must be a data structure.');
end

if isstruct(reference)
    if ~exist('field')
        error('FIELD argument not supplied.');
    end
    if ~isfield(reference, field)
        error(['Field is not in reference data structure: ' field]);
    else
        r = getfield(reference,field);
    end
elseif isnumeric(reference)
    r = reference;
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

% Check that all values are finite
test = isfinite(p);
if ~all(test)
    error('PREDICTED field has non-finite values');
end

test = isfinite(r);
if ~all(test)
    error('REFERENCE field has non-finite values');
end

return;

end

