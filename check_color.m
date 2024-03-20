function RGBtriplet = check_color(color)
%CHECK_COLOR(COLOR)
%   Checks the input color is valid
%
%   CHECK_COLOR(COLOR) is a support function for the 
%   GET_TAYLOR_DIAGRAM_OPTIONS function. It checks for a valid plot color
%   and returns it as a RGB triplet.

  % Check for 'r+' combination
  if length(color) == 2
      color = color(1);
  end
  try
    % Get RGB triplet from short name for color. Will return input if 
    % valid RGB triplet. 
    RGBtriplet = validatecolor(color);
  catch
    % Invalid color
    error('Invalid color: %s.',num2str(color));
  end
end
