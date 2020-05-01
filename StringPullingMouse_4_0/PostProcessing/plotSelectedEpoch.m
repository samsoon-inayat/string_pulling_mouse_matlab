function plotSelectedEpoch (handles)

zw = getParameter(handles,'Auto Zoom Window');

[sfn efn] = getFrameNums(handles);
numFrames = sfn:efn;

handles.d = get_data(handles);
frames = handles.d.frames;
times = handles.d.frame_times;
try
    out = get_all_params(handles,sfn,efn,0);
catch
    rethrow(lasterror);
    return;
end
if isempty(out)
    rethrow(lasterror);
end
objectVs = {'body','right_ear','nose','right_hand'};
for ii = 1:length(objectVs)
    cmdTxt = sprintf('val = out.%s.manual;',objectVs{ii});
    eval(cmdTxt);
    temp = nansum(val)*100/sum(~isnan(val));
    acVals(ii,1) = objectVs(ii);
    acVals(ii,2) = {100-temp};
end
acVals % accuracy values
Scale = getParameter(handles,'Scale');
display(sprintf('Hands - %d of %d (%.2f%%) were manually found',nansum(out.right_hand.manual),sum(~isnan(out.right_hand.manual)),nansum(out.right_hand.manual)*100/sum(~isnan(out.right_hand.manual))))
fns = sfn:efn;
ts = times(fns);

aC = out.body.fit;
xrs = out.right_hand.centroid(:,1)*Scale;
yrs = out.right_hand.centroid(:,2)*Scale;
xls = out.left_hand.centroid(:,1)*Scale;
yls = out.left_hand.centroid(:,2)*Scale;
head_yaw = out.head.yaw;
head_roll = out.head.roll;
head_pitch = out.head.pitch*Scale;
bodyAngle = out.body.angle;
bodyLength = out.body.length*Scale;
nose_string_distance = out.nose.string_distance*Scale;

fn = 1;
thisFrame = frames{fns(fn)};
zw = getParameter(handles,'Zoom Window');

if get(handles.radiobutton_x_axis_time,'Value')
    ts = times(fns)-times(fns(1));
    xlab = 'Time (sec)';
else
    ts = fns;
    xlab = 'Frames';
end

% hf = figure(21);clf;
% add_window_handle(handles,hf);
% imagesc(thisFrame);axis equal;
% hold on;
% plot(out.body.ellipse_top(fn,1),out.body.ellipse_top(fn,2),'*r');
% plot(out.nose.centroid(fn,1),out.nose.centroid(fn,2),'*y');


hf1 = figure(22);clf;
add_window_handle(handles,hf1);
subplot 421
plot(ts,bodyLength);hold on;
set(gca,'FontSize',10,'FontWeight','Normal'); 
xlabel(xlab);
ylabel('Body Length (mm)');

subplot 422
plot(ts,bodyAngle);hold on;
set(gca,'FontSize',10,'FontWeight','Normal'); 
xlabel(xlab);
ylabel('Body Angle(deg)');

subplot 423
plot(ts,head_roll);hold on;
plot(ts,zeros(size(head_yaw)));
set(gca,'FontSize',10,'FontWeight','Normal'); 
xlabel(xlab);
ylabel('Head Roll (Angle-Deg)');

subplot 424
plot(ts,head_yaw);hold on;
plot(ts,zeros(size(head_yaw)));
set(gca,'FontSize',10,'FontWeight','Normal'); 
xlabel(xlab);
ylabel('Head Yaw (arb.)');
ylim([-1.3 1.3]);

subplot 425
plot(ts,head_pitch);hold on;
plot(ts,zeros(size(head_yaw)));
set(gca,'FontSize',10,'FontWeight','Normal'); 
xlabel(xlab);
ylabel('Head Pitch (D_nbe,mm)');

subplot 426
try
plot(ts(1:length(nose_string_distance)),nose_string_distance);hold on;
set(gca,'FontSize',10,'FontWeight','Normal'); 
xlabel(xlab);
ylabel('Nose-String Dist (mm)');
catch
end

subplot 427
m = min([xrs' xls']); M = max([xrs' xls']);
plot(ts,xrs,'c','linewidth',1);hold on;
plot(ts,xls,'m','linewidth',1);
set(gca,'FontSize',10,'FontWeight','Normal'); 
xlabel(xlab);
ylabel('Hands X Coordinate mm');
ylim([m M]);

subplot 428
m = min([yrs' yls']); M = max([yrs' yls']);
plot(ts,yrs,'c','linewidth',1);hold on;
plot(ts,yls,'m','linewidth',1);
set(gca,'FontSize',10,'FontWeight','Normal'); 
xlabel(xlab);
ylabel('Hands Y Coordinate');
ylim([m M]);


