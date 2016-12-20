%IS_OCTAVE Function to check if running in Octave
%
%   r = IS_OCTAVE() returns a boolean value of True if called by
%   Octave and false otherwise.

function r = is_octave ()
  persistent x;
  if (isempty (x))
    x = exist ('OCTAVE_VERSION', 'builtin');
  end
  r = x;
end
