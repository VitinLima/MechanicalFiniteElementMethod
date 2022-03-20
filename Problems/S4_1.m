# Material Properties
E = 200e9;
b = 0.2;
h = 0.4;
L = 4;

I = b*h*h*h/12;
l = 2;

# 2GL Coefficient Matrix
K11 = 12/l/l/l;
K21 = 6/l/l;
K31 = -12/l/l/l;
K41 = 6/l/l;

K12 = 6/l/l;
K22 = 4/l;
K32 = -6/l/l;
K42 = 2/l;

K13 = -12/l/l/l;
K23 = -6/l/l;
K33 = 12/l/l/l;
K43 = -6/l/l;

K14 = 6/l/l;
K24 = 2/l;
K34 = -6/l/l;
K44 = 4/l;

K2GL = E*I*[K11 K12 K13 K14; K21 K22 K23 K24; K31 K32 K33 K34; K41 K42 K43 K44];

# Boundary Conditions
Mc = -60e3;
U2 = -0.01;

# Build system
Kc = sparse(6,6);
Kc(1:4,1:4) += K2GL;
Kc(3:6,3:6) += K2GL;
Ks = [Kc(3,3), Kc(3,4); Kc(4,3), Kc(4,4)]
Fs = [0; Mc] - [Kc(3,2); Kc(4,2)]*U2
Us = Ks\Fs;
Uc = [0; U2; Us(1); Us(2); 0; 0]

Fc = Kc*Uc