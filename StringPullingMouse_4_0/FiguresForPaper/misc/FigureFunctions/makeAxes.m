function [ pp ] = makeAxes(hf,pp,row,col,adjustPos)
%MAKEAXES Summary of this function goes here
%   Detailed explanation goes here

figure(hf);
axesPosition = [pp.lefts{row,col} pp.bottoms{row,col} pp.colWidths{row}(col) pp.rowHeights(row)];
axesPosition = adjustPosition(axesPosition,adjustPos);
pp.ha(row,col) = axes('Position',axesPosition);hold on;


function paPosition = adjustPosition(paPosition,adjustment)
fineSp = 0.001;
paPosition(1) = paPosition(1) + adjustment(1) * fineSp;
paPosition(2) = paPosition(2) + adjustment(2) * fineSp;
paPosition(3) = paPosition(3) + adjustment(3) * fineSp;
paPosition(4) = paPosition(4) + adjustment(4) * fineSp;
