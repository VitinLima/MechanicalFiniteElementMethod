clear;
clc;

# Material Properties
E = 200e9;
b = 0.2;
h = 0.4;
L = 4;
I = b*h*h*h/12;
l = 2;
alpha = 1.2e-5;
R = h;
Ti = 50;
Ts = 150;

### Elements
##E = [1, 2; 2, 3];

### Boundary conditions
BC(1) = struct( ...
	'name', 'precribedDisplacement', ...
	'conditionType', 'prescribedDisplacement', ...
	'targetType', 'Node', ...
	'targets', 2, ...
	'value', -0.01);
BC(2) = struct( ...
	'name', 'distributedLoad', ...
	'conditionType', 'distributedLoad', ...
	'targetType', 'Element', ...
	'targets', [1 2], ...
	'value', 0);
BC(3) = struct( ...
	'name', 'temperature', ...
	'conditionType', 'temperature', ...
	'targetType', 'Element', ...
	'targets', [1 2], ...
	'value', Ti - Ts);

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

# Build system
#  Building stiffness matrix
K = zeros(6,6);
K(1:4,1:4) += K2GL;
K(3:6,3:6) += K2GL;

#  Initializing forces vector
F = zeros(columns(K), 1);
#  Initializing displacement vector
U = zeros(columns(K), 1);

#  Constrained displacements
sU = zeros(columns(K), 1);
#  Known forces
sF = ones(columns(K), 1);

# Boundary Conditions
#  Point loads
F(4) = -60e3; %Nm

#  Constrained nodes, unknown reactions
U(1) = 0;
sU(1) = 1;
sF(1) = 0;
U(2) = 0;
sU(2) = 1;
sF(2) = 0;
U(5) = 0;
sU(5) = 1;
sF(5) = 0;
U(6) = 0;
sU(6) = 1;
sF(6) = 0;

# Solving system
#  Solving unconstrained displacements with known forces
sIdx = sU == 0 & sF == 1;
U(sIdx) = K(sIdx,sIdx)\F(sIdx);

#  Solving unknown forces with known displacements
sIdx = sU == 1 & sF == 0;
F(sIdx) = K(sIdx, :)*U;

# Adding precribed displacement, distributed loads, and temperature loads
#  Prescribed displacement
Up = zeros(columns(K), 1);
Up(2) = -0.01; %rad

Fp = K*Up;
F -= Fp;

###  Distributed loads;
##Fd = zeros(columns(K), 1);
p = 10e3; %N/m
##Fd(1) += p*l/2;
##Fd(3) += p*l/2;
##Fd(2) += p*l*l/12;
##Fd(4) -= p*l*l/12;
##Fd(3) += p*l/2;
##Fd(5) += p*l/2;
##Fd(4) += p*l*l/12;
##Fd(6) -= p*l*l/12;
##F -= Fd;

###  Temperature loads
##Ft = zeros(columns(K), 1);
##dT = Ti - Ts; %Kelvin
##Tau = alpha*E*I/R*dT;
##Ft(2) -= Tau;
##Ft(6) += Tau;
##
##F -= Ft;

# Solving system
#  Solving unconstrained displacements with known forces
sIdx = sU == 0 & sF == 1;
U(sIdx) = K(sIdx,sIdx)\F(sIdx);

#  Solving unknown forces with known displacements
sIdx = sU == 1 & sF == 0;
F(sIdx) = K(sIdx, :)*U;