close all; clear all;

cd ~/Desktop/

x = [ 2 5 7]';
M = [3 8 7; 8 3 8; 7 8 3];
y = M * x;

xVector = levinsonDurbin(M, y)
diff = sum(xVector - x);
