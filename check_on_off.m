function value = check_on_off(value)
%CHECK_ON_OFF(VALUE)
%   Check whether variable contains a value of "on" or 'off'. Returns an
%   error if neither.
%
%   INPUTS:
%   value : string to check
%
%   OUTPUTS:
%   None.

switch lower(value)
    case 'off'
        return;
    case 'on'
        return;
    case false
        value = 'off';
    case true
        value = 'on';
    otherwise
        error(['Invalid value: ' value]);
end

end %function check_on_off
