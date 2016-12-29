% SKILL METRICS TOOLBOX
%
% A collection of functions for calculating the skill of model predictions
% against observations.
%
% A help window showing this file's contents can be called up by using the
% command:
%
% >> doc 'Skill Metrics Toolbox'
%
% Author: Peter A. Rochford
%         Symplectic, LLC
%         prochford@thesymplectic.com
%
% Files
%   bias_skill                     - Calculate the bias between two variables (B) 
%   brier_score                    - Calculate Brier score (BS) between two variables
%   centered_rms_dev               - Calculate centered root-mean-square (RMS) difference 
%   check_on_off                   - Check whether variable contains a value of "on" or 'off'.
%   check_taylor_stats             - Checks input statistics satisfy Taylor diagram relation to <1%.
%   get_target_diagram_axes        - Get axes value for target_diagram function.
%   get_target_diagram_options     - Get optional arguments for target_diagram function.
%   get_taylor_diagram_axes        - Get axes value for taylor_diagram function.
%   get_taylor_diagram_options     - Get optional arguments for target_diagram function.
%   is_octave                      - Check if running in Octave
%   overlay_target_diagram_circles - Overlays circle contours on a target diagram.
%   overlay_taylor_diagram_circles - Overlays circle contours on a Taylor diagram.
%   overlay_taylor_diagram_lines   - Overlay lines emanating from origin on a Taylor diagram.
%   plot_pattern_diagram_colorbar  - Plots color markers on a pattern diagram shaded according to a supplied value.
%   plot_pattern_diagram_markers   - Plots color markers on a pattern diagram.
%   plot_target_axes               - Plot axes for target diagram.
%   plot_taylor_axes               - Plot axes for Taylor diagram.
%   rms_dev                        - Calculate the root-mean-square deviation between two variables
%   skill_score_brier              - Calculate Brier skill score (BSS) between two variables
%   skill_score_murphy             - Calculate nondimensional skill score (SS) between two variables
%   target_diagram                 - Plot a target diagram from statistics of different series.
%   target_statistics              - Calculate statistics needed to produce a target diagram
%   taylor_diagram                 - Plot a Taylor Diagram from statistics of different series.
%   taylor_statistics              - Calculate statistics needed to produce a Taylor diagram.
%   write_stats                    - Write statistics to an Excel file.
%   write_target_stats             - Write statistics used in a target diagram to an Excel file.
%   write_taylor_stats             - Write statistics used in a Taylor diagram to an Excel file.
