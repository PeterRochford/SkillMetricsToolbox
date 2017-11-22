function report_duplicate_stats(duplicates)
%REPORT_DUPLICATE_STATS Reports list of pairs of statistics that are duplicates.
%
%   INPUT:
%   DUPLICATES : List of tuples of paired statistics that are duplicates
%                produced by the check_duplicate_stats function.
%
%   OUTPUT:
%   None

n = length(duplicates);
if n == 0
    return;
end

% Report duplicates to screen
disp('Duplicate pairs of statistics:');
for i=1:n
    tuple = duplicates{i};
    i = tuple{1}; j = tuple{2};
    message = ['(' num2str(i) ', ' num2str(j) ', (' ...
        num2str(tuple{3}{1}) ', ' num2str(tuple{3}{2}) '), (' ...
        num2str(tuple{4}{1}) ', ' num2str(tuple{4}{2}) '))'];
    disp(message);
end
 
end % report_duplicate_stats
