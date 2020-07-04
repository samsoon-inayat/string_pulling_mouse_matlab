function position = adjustAxesPosition(position,adjustment)
position(1) = position(1) + adjustment(1);
position(2) = position(2) + adjustment(2);
position(3) = adjustment(3);
position(4) = adjustment(4);