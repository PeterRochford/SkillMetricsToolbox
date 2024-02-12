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
for k=1:n
    data = duplicates{k};
    i = data{1}; j = data{2};
    message = ['(' num2str(i) ', ' num2str(j) ', (' ...
        num2str(data{3}(1)) ', ' num2str(data{3}(2)) '), (' ...
        num2str(data{4}(1)) ', ' num2str(data{4}(2)) '))'];
    disp(message);
end
 
end % report_duplicate_stats
