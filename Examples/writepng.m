function writepng(figurenumber,filename)
%WRITEPNG Write a figure to a Portable Network Graphics (PNG) file 
%
%   WRITEPNG(FIGURENUMBER,FILENAME) writes the figure identified
%   by FIGURENUMBER as a graphic to a file named FILENAME in PNG format.
%
%   Input:
%   FIGURENUMBER : number of figure
%   FILENAME     : name for graphics file

figure(figurenumber); pause(2)
[X,MAP]=frame2im(getframe(gcf));
imwrite(X,filename,'png' );

if nargin==3
 eval(['!/usr/bin/convert ',filename,'.png ',filename,'.gif '])
end

end %function
