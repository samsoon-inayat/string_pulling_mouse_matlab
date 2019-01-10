function displayMessageBlinking(handles,msg,props,n)

for ii = 1:n
    displayMessage(handles,msg,props);
    pause(0.1);
    displayMessage(handles,'');
    pause(0.1);
end
displayMessage(handles,msg,props);