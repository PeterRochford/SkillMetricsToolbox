function overlay_target_diagram_circles(option)
%OVERLAY_TARGET_DIAGRAM_CIRCLES Overlays circle contours on a target diagram.
%
%   OVERLAY_TARGET_DIAGRAM_CIRCLES(OPTION)
%   Plots circle contours on a target diagram to indicate standard
%   deviation ranges and observational uncertainty threshold.
%
%   INPUTS:
%   option : data structure containing option values. (Refer to 
%     GET_TARGET_DIAGRAM_OPTIONS function for more information.)
%   option.axismax        : maximum for the X & Y values. Used to set
%     default circles when no contours specified
%   option.circles        : radii of circles to draw to indicate 
%     isopleths of standard deviation
%   option.circleLineSpec : circle line specification (default dashed 
%      black, '--k')
%   option.normalized     : statistics supplied are normalized with 
%     respect to the standard deviation of reference values
%   option.obsUncertainty : Observational Uncertainty (default of 0)
%
%   OUTPUTS:
%   None.

% 1 - reference circle if normalized
if strcmp(option.normalized,'on')
    theta = 0:0.01:2*pi;
    rho(1:length(theta)) = 1;
    [X,Y] = pol2cart(theta,rho);
    plot(X,Y,'k','LineWidth',option.circleLineWidth);
end

% Set range for target circles
if strcmp(option.normalized,'on')
    circles = [.5 1];
else
    if isfield(option,'circles')
        index = find(option.circles <= option.axismax);
        circles = option.circles(index);
    else
        circles = option.axismax*[.7 1];
    end
end

% 2 - secondary circles
for i=1:length(circles)
    theta=0:0.01:2*pi;
    rho(1:length(theta))=circles(i);
    [X,Y] = pol2cart(theta,rho);
    plot(X,Y,option.circleLineSpec,'LineWidth',option.circleLineWidth);
end

% 3 - Observational Uncertainty threshold
if option.obsUncertainty > 0
    theta=0:0.01:2*pi;
    rho(1:length(theta))=option.obsUncertainty;
    [X,Y] = pol2cart(theta,rho);
    plot(X,Y,'--b');
end

end % function overlay_target_diagram_circles
