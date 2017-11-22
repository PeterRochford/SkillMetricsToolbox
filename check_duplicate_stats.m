function duplicates = check_duplicate_stats(stats1, stats2, varargin)
%CHECK_DUPLICATE_STATS Checks two lists of paired statistics for duplicates
% and returns a list of the pairs that agree within to <1%.
%
%   INPUT:
%   STATS1 : List of first statistical metric, e.g. Standard Deviations
%   STATS2 : List of second statistical metric, e.g. Centered Root Mean Square Difference 
%
%   OUTPUT:
%   DUPLICATES : List of tuples of paired statistics that are duplicates.
%                The list contains the index locations of the pairs of 
%                statistics followed by their values as Python 2-tuples.

threshold = 0.01; % default
if nargin == 3
    threshold = varargin{1};
end

if threshold < 1e-7
    error(['threshold value must be positive: ' num2str(threshold)]);
end

% Check for non-empty lists
if length(stats1) == 0
   error('Argument stats1 is empty list!');
elseif length(stats2) == 0
   error('Argument stats2 is empty list!');
end

% Check for matching list lengths
if length(stats1) ~= length(stats2)
    error(['Arguments stats1 and stats2 have different list lengths.\n' ...
          'len(stats1) = ' num2str(length(stats1)) ' != len(stats2) = ' ...
          num2str(length(stats2))]);
end
    
% Search for duplicate pairs of statistics
duplicates = {};
n = length(stats1);
nduplicate = 0;
for i=1:n
    for j=i+1:n
        diff1 = abs((stats1(i) - stats1(j))/stats1(i));
        diff2 = abs((stats2(i) - stats2(j))/stats2(i));
        if diff1 < threshold && diff2 < threshold
            nduplicate = nduplicate + 1;
            pair1 = py.tuple({stats1(i), stats2(i)});
            pair2 = py.tuple({stats1(j), stats2(j)});
            duplicates{nduplicate} = py.tuple({i, j, pair1, pair2});
        end
    end
end
 
end % check_duplicate_stats
