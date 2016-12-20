function check_taylor_stats(STDs, RMSs, CORs,threshold)
%CHECK_TAYLOR_STATS Checks input statistics satisfy Taylor diagram relation to <1%.
%
%   Function terminates with an error if not satisfied. The threshold is
%   the ratio of the difference between the statistical metrics and the
%   centered root mean square difference:
%
%     abs(RMSs^2 - (STDs^2 + STDs(1)^2 - 2*STDs*STDs(1)*CORs))/RMSs^2
%
%   Note that the first element of the statistics vectors must contain
%   the value for the reference field.
%
%   INPUTS:
%	STDs      : Standard deviations
%	RMSs      : Centered Root Mean Square Difference 
%	CORs      : Correlation
%   threshold : limit for acceptance, e.g. 0.1 for 10% (default 0.01)
%
%   OUTPUTS:
%   None.

narginchk(3,4);
if nargin == 3
   threshold = 0.01;
elseif threshold < 1e-7
    error(['threshold value must be positive: ' num2str(threshold)]);
end

diff = RMSs.^2 - (STDs.^2 + STDs(1)^2 - 2*STDs*STDs(1).*CORs);
diff = abs(diff./RMSs.^2);
if find(diff > threshold)
    ii = find(diff~=0);
    if length(ii) == length(diff)
        error(sprintf(['Incompatible data\nYou must have:' ...
            '\nRMSs - sqrt(STDs.^2 + STDs(1)^2 - ' ...
            '2*STDs*STDs(1).*CORs) = 0 !']))
    else
        error(sprintf(['Incompatible data indices: [%i]\nYou must ' ...
            'have:\nRMSs - sqrt(STDs.^2 + STDs(1)^2 - ' ...
            '2*STDs*STDs(1).*CORs) = 0 !'],ii))
    end
end

end % function overlay_target_diagram_circles
