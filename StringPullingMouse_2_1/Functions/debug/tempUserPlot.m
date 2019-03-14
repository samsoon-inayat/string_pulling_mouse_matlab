global frames;
times = handles.d.times;
R = handles.md.resultsMF.R;
tags = handles.md.resultsMF.tags;
fns = 266:415;
indexC = strfind(tags,'Right Hand');
tagR = find(not(cellfun('isempty', indexC)));
indexC = strfind(tags,'Left Hand');
tagL = find(not(cellfun('isempty', indexC)));
for ii = 1:length(fns)
    ind = ismember(R(:,[1 2]),[fns(ii) tagR],'rows');
    xrs(ii) = R(ind,3);
    yrs(ii) = R(ind,4);
    ind = ismember(R(:,[1 2]),[fns(ii) tagL],'rows');
    xls(ii) = R(ind,3);
    yls(ii) = R(ind,4);
    
    iii = ismember(R(:,[1 2]),[fns(ii) 8],'rows');
    jj = ismember(R(:,[1 2]),[fns(ii) 7],'rows');
    aC(ii) = getSubjectFit(R(jj,[3 4]),R(iii,3),R(iii,4),R(iii,5));
end
frame = frames{266};
figure(10);clf;
imagesc(frame);
axis equal;
axis off;
zw = getParameter(handles,'Zoom Window');
hold on;
plot(xrs,yrs,'m');
plot(xls,yls,'c');
xlim([zw(1)-50 zw(3)+50]);
ylim([zw(2)-50 zw(4)]);


figure(11);clf;
imagesc(frame);
axis equal;
axis off;
hold on;
for ii = 1:10:length(fns)
    C = aC(ii);
%     plot(C.Major_axis_xs,C.Major_axis_ys,'g');
%     plot(C.Minor_axis_xs,C.Minor_axis_ys,'g');
    plot(C.Ellipse_xs,C.Ellipse_ys,'g');
end
xlim([zw(1)-50 zw(3)+50]);
ylim([zw(2)-50 zw(4)]);

ts = times(fns)-times(fns(1));
oxr = xrs(1);
oyr = yrs(1);
distR = sqrt((xrs-oxr).^2 + (yrs-oyr).^2);
oxl = xls(1);
oyl = yls(1);
distL = sqrt((xls-oxl).^2 + (yls-oyl).^2);
figure(100);clf;
plot(ts,distR,'m','linewidth',2);hold on;
plot(ts,distL,'c','linewidth',2);
set(gca,'FontSize',12,'FontWeight','bold');
xlabel('Time (sec)');
ylabel('Distance (pixels)');
speedR = [0 diff(distR)./diff(ts)];
speedL = [0 diff(distL)./diff(ts)];
figure(101);clf;
plot(ts,abs(speedR),'*m','linewidth',2);hold on;
plot(ts,abs(speedL),'*c','linewidth',2);
set(gca,'FontSize',12,'FontWeight','bold');
xlabel('Time (sec)');
ylabel('Speed (pixels/s)');

figure(101);clf;
plot(distR,abs(speedR),'*m','linewidth',2);hold on;
plot(distL,abs(speedL),'*c','linewidth',2);
set(gca,'FontSize',12,'FontWeight','bold');
xlabel('Distance (pixels)');
ylabel('Speed (pixels/s)');


mSR = min(abs(speedR));
MSR = max(abs(speedR));
mSL = min(abs(speedL));
MSL = max(abs(speedL));

scaleR = linspace(mSR,MSR,length(fns)+1);
scaleL = linspace(mSL,MSL,length(fns)+1);

scolors = distinguishable_colors(length(fns),'k');
figure(10);clf;
imagesc(frame);
axis equal;
axis off;
hold on;
for ii = 1:length(fns)
    thisSpeedR = abs(speedR(ii));
    dTemp = scaleR - thisSpeedR;
    ind = (find(dTemp>=0,1,'first'));
    if ind == 151
        ind = 150;
    end
    plot(xrs(ii),yrs(ii),'o','color',scolors(ind,:));
%     plot(xls,yls,'c');
end
xlim([zw(1)-50 zw(3)+50]);
ylim([zw(2)-50 zw(4)]);
% userPlot(handles);
