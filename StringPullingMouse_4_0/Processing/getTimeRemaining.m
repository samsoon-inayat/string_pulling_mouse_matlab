function timeRemainingText = getTimeRemaining(total,current)
t = toc;
timeRemaining = ((total-current)*t);
timeRemainingText = datestr(seconds(timeRemaining),'HH:MM:SS');
