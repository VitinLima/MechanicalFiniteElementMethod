close all;
clear;
clc;

q = 60;
EI = 20000;
l1 = 6;
l2 = 6;
l3 = 3;

k111 = 12/l1/l1/l1;
k121 = 6/l1/l1;
k122 = 4/l1;
k112 = 6/l1/l1;
k222 = 3/l2;

Kg = EI*[k111, k112; k121, k122+k222]

F = [0; 0]

F0 = [0; q*l2*l2/8]

U = Kg\(F - F0)