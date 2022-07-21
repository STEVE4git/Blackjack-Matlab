function [mousePos] = get_mouse_position(mainAxis)
%get_mouse_position gets the current mouse position
%Input arguments:
%   mainAxis - axes object
%Output arguments
%   mousePos - 2 element vector containing: [x y]

tempMousePos = get(mainAxis,'CurrentPoint');
mousePos = [tempMousePos(1), tempMousePos(3)];
