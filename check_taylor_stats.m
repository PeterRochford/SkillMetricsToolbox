function diff = check_taylor_stats(STDs, CRMSDs, CORs, threshold)
%CHECK_TAYLOR_STATS Checks input statistics satisfy Taylor diagram relation to <1%.
%
%   Function terminates with an error if not satisfied. The threshold is
%   the ratio of the difference between the statistical metrics and the
%   centered root mean square difference:
%
%   abs(CRMSDs^2 - (STDs^2 + STDs(1)^2 - 2*STDs*STDs(1)*CORs))/CRMSDs^2
%
%   Note that the first element of the statistics vectors must contain
%   the value for the reference field.
%
%   INPUTS:
%	  STDs      : Standard deviations
%	  CRMSDs    : Centered Root Mean Square Difference s
%	  CORs      : Correlation
%   threshold : limit for acceptance, e.g. 0.1 for 10% (default 0.01)
%
%   OUTPUTS:
%   diff      : ratio of difference between the statistical metrics and 
%               the CRMSD

narginchk(3,4);
if nargin == 3
   threshold = 0.01;
elseif threshold < 1e-7
    error(['threshold value must be positive: ' num2str(threshold)]);
end

diff = CRMSDs(2:end).^2 - (STDs(2:end).^2 + STDs(1)^2 - ...
       2*STDs(2:end)*STDs(1).*CORs(2:end));
diff = abs(diff./CRMSDs(2:end).^2);
if find(diff > threshold)
    ii = find(diff > threshold)
    if length(ii) == length(diff)
        error(['Incompatible data\nYou must have:' ...
            '\nCRMSDs - sqrt(STDs.^2 + STDs(1)^2 - ' ...
            '2*STDs*STDs(1).*CORs) = 0 !'])
    else
        index = sprintf('% d',ii);
        disp(['Incompatible data indices: ' index])
        disp('You must have:')
        disp(['CRMSDs^2 - sqrt(STDs.^2 + STDs(1)^2 - ' ...
            '2*STDs*STDs(1).*CORs) = 0 !']);
        error('CHECK_TAYLOR_STATS');
    end
end

end % function check_taylor_stats
