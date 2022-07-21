function mouseDownListener(src, event)
    %no body.
    %this handler must be registerd for axis 'CurrentPoint' to be
    %updated when mouse moves.
    global click;
    click = true;
end
