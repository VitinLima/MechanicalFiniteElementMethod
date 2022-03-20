clear;
clc;

YM = 200e9
D = 50e-3
A = pi*D*D/4;
l1 = 2
l2 = 2.5
c2 = 0.64;
s2 = 0.36;
cs = 0.48;

N = [0, 0; 2, 1.5; 2, 0];
E = [1, 3; 1, 2];

Ke1g = YM*A/l1*[1 0 0 0 -1 0;
                0 0 0 0 0 0;
                0 0 0 0 0 0;
                0 0 0 0 0 0;
                -1 0 0 0 1 0;
                0 0 0 0 0 0]

Ke2g = YM*A/l2*[c2 cs -c2 -cs 0 0;
                cs s2 -cs -s2 0 0;
                -c2 -cs c2 cs 0 0;
                -cs -s2 cs s2 0 0;
                0 0 0 0 0 0;
                0 0 0 0 0 0]

Kg = Ke1g+Ke2g

F = [30e3 -sqrt(3)*30e3 0 0 0 0]';
U = [0 0 0 0 0 0]';

sU = [0 0 1 1 1 1]';
sF = [1 1 0 0 0 0]';

U(sU==0) = Kg(sU==0,sU==0)\(F(sU==0) - Kg(sU==0,sU==1)*U(sU==1))
F(sF==0) = Kg(sF==0,:)*U

disp(['Sum of horizontal forces ', num2str(sum(F([1 3 5])))]);
disp(['Sum of vertical forces ', num2str(sum(F([2 4 6])))]);

disp('');
disp('Internal forces on elements');
for i = 1:rows(E)
	Fx = F(2*E(i,2)-1);
	Fy = F(2*E(i,2));
	disp(['Element ', num2str(i), ': ', num2str(sqrt(Fx*Fx+Fy*Fy))]);
end