# SkillMetricsToolbox
This toolbox contains a collection of Matlab functions for calculating the skill of model predictions against observations. It includes metrics such as root-mean-square-error (RMSE) difference, centered root-mean-square (RMS) difference, and skill score (SS), as well as a collection of functions for producing target and Taylor diagrams. The more valuable feature of the toolbox are the plotting functions for target and Taylor diagrams and the ability to easily customize the diagrams.

The toolbox contains a primer on Taylor diagrams as well as an "Examples" folder that contains a collection of example Matlab scripts showing how to produce target and Taylor diagrams in a variety of formats. There are 6 examples for target diagrams and 7 examples for Taylor diagrams that successively progress from very simple to more customized figures. These series of examples provide an easy tutorial on how to use the various options of the target_diagram and taylor_diagram functions. They also provide a quick reference in future for how to produce the diagrams with specific features.The diagrams produced by each script are in Portable Network Graphics (PNG) format and have the same file name as the script with a "png" suffix. Examples of the diagrams produced can be found in the Examples folder with the same file name as the script and ending in '_example.png'. For example the diagram produced by target1.m is named target1_example.png.

There is also a simple program "Examples/all_stats.m" that provides examples of how to calculate the various skill metrics used or available in the toolbox. All the calculated skill metrics are written to an Excel file for easy viewing and manipulation. The Matlab code is kept to a minimum.

A help window that provides a summary of the example scripts can be called up within Matlab after the toolbox has been added to the Matlab path by using the commands:

doc 'SkillMetricsToolbox'

doc 'SkillMetricsToolbox/Examples'
