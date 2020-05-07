function At = timeWarpOneAnimal(A)

inds = cellfun(@(Z)[~isempty(Z)],A);

nCycles = sum(inds);

cycInds = 1:5;
cycInds = cycInds(randperm(nCycles));

nc1 = cycInds(1); nc2 = cycInds(2);


ancs = nchoosek(1:nCycles,2);

for ii = 1:size(ancs,1)
    C1 = A{ancs(ii,1)}';
    C2 = A{ancs(ii,2)}';
    [ed(ii),Atx,Aty] = dtw(C1,C2);
    lenAt(ii,:) = [ancs(ii,1) ancs(ii,2) length(C1) length(C2) length(Atx) ed(ii)];
end
inds = lenAt(:,end) < 50;
ancs(inds,:)

min(lenAt(:,end))
    
C1 = A{ancs(5,1)}';
C2 = A{ancs(5,2)}';
C1 = A{4}'; C2 = A{5}';
figure(100);clf;
dtw(C1,C2);
[ed,Atx,Aty] = dtw(C1,C2);
figure(1000);clf;
plot(C1,'b');hold on;
plot(C1(Atx),'c');
plot(C2,'r');
plot(C2(Aty),'m');


