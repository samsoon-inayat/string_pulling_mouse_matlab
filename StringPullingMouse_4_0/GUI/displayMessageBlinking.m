function displayMessageBlinking(handles,msg,props,n)

for ii = 1:n
    displayMessage(handles,msg,props);
    pause(0.3);
    displayMessage(handles,'');
    pause(0.01);
end
displayMessage(handles,'',{'ForegroundColor','b'});