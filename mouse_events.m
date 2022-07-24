%file for reading mouse movements and getting the mouse position
%controls ALL mouse events up/down
function [mousePos] = mouse_events(mainAxis)
%mouse_events gets the current mouse position
%Input arguments:
%   mainAxis - axes object
%Output arguments
%   mousePos - 2 element vector containing: [x y]
tempMousePos = get(mainAxis,'CurrentPoint');
mousePos = [tempMousePos(1), tempMousePos(3)];
