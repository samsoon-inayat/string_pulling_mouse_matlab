function [ pp ] = getPanelsProps( pp )
%GETPANELSPROPS Summary of this function goes here
%   Detailed explanation goes here


numberOfRows = pp.numberOfRows;
numberOfCols = pp.numberOfCols;
rowHeights = pp.rowHeights;
colWidths = pp.colWidths;
spaceBetweenRows = pp.spaceBetweenRows;
spaceBetweenCols = pp.spaceBetweenCols;
leftOffset = pp.leftOffset;
bottomOffset = pp.bottomOffset;

for rr = 1:numberOfRows
    for cc = 1:numberOfCols(rr)
        if cc == 1
            lefts{rr,cc} = leftOffset;
        else
            lefts{rr,cc} = lefts{rr,cc-1} + colWidths{rr}(cc-1) + spaceBetweenCols{rr}(cc-1);
        end
        if rr == 1
            bottoms{rr,cc} = bottomOffset;
        else
            bottoms{rr,cc} = bottoms{rr-1,cc} + rowHeights(rr-1) + spaceBetweenRows(rr-1);
        end
    end
end

pp.lefts = lefts;
pp.bottoms = bottoms;

