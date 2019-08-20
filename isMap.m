function answer = isMap(A)
%isMap Checks if object A is a Map container.
%
%   isMap(A)
%   Checks if the object A is a AMp container and returns
%     0 = false
%     1 = true

answer = strcmp(class(A),'containers.Map');

end %function isMap