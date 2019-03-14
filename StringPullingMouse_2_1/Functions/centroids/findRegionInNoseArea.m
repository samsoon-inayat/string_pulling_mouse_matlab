function toDiscard = selectAppropriateRegions(M,Cs,masks,s)
In = masks.cIn;

Ce = Cs{2};
RE = Ce(1); % region representing right ear
LE = Ce(2); % region representing left ear
diffeyR = max(RE.yb) - min(RE.yb); % find maximum minus minimum y of boundary representing right region
diffeyL = max(LE.yb) - min(LE.yb); % find maximum minus minimum y of boundary representing left region
lengthE = max([diffeyR diffeyL]); % which region is larger
zw = M.zw;
cR = RE.Centroid - [zw(1) zw(2)]; % centroid of right ear
cL = LE.Centroid - [zw(1) zw(2)]; % centroid of left ear
RE.Centroid = cR;
LE.Centroid = cL;
temp = cL - cR; % temp is vector joing ear centroids
eslope = temp(2)/temp(1); % slope of vector
exs = linspace(cR(1),cL(1),50); % x points linspace
eys = eslope*(exs-cR(1)) + cR(2); % y points of line parallel to and above line joining centroids of right and left ears
eysd = eys + lengthE/2; % y points of line parallel to and below line joining centroids of right and left ears
eysu = eys - lengthE/2;



% toDiscard = [];
% for ii = 1:length(s)
%     thisS = s(ii);
%     yC = thisS.Centroid(2);
%     xC = thisS.Centroid(1);
%     yC_line = eslope*(thisS.Centroid(1)-cR(1)) + cR(2)+ lengthE/4;
%     if yC < yC_line
%         toDiscard = [toDiscard ii];
%     end
% end
% s(toDiscard) = [];

toDiscard = [];
for ii = 1:length(s)
    thisS = s(ii);
    yC = thisS.Centroid(2);
    temp = yC<eysd;
    if sum(temp) == length(temp)
        toDiscard = [toDiscard ii];
    end
end
n=0;
% s(toDiscard) = [];


