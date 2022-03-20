clear;
clc;

% Elements
E.Elements = [1, 2; 2, 3];
E.YoungModulus = 200e9;
E.Base = 0.2;
E.Height = 0.4;
E.Length = 2;
E.RotationalInertia = E.Base.*E.Height.*E.Height.*E.Height/12;
E.ThermalExpansionCoefficient = 1.2e-5;

E.YoungModulus .*= ones(rows(E.Elements),1);
E.Base .*= ones(rows(E.Elements),1);
E.Height .*= ones(rows(E.Elements),1);
E.Length .*= ones(rows(E.Elements),1);
E.RotationalInertia .*= ones(rows(E.Elements),1);
E.ThermalExpansionCoefficient .*= ones(rows(E.Elements),1);

% Boundary conditions
BC = struct('name',{},'conditionType',{},'targetType',{},'targets',{},'value',{});

BC(end+1) = struct( ...
	'name', 'Constraint', ...
	'conditionType', 'prescribedDisplacement', ...
	'targetType', 'Node', ...
	'targets', [1 2], ...
	'value', 0); %m or rad
BC(end+1) = struct( ...
	'name', 'Point Load', ...
	'conditionType', 'pointLoad', ...
	'targetType', 'Node', ...
	'targets', 4, ...
	'value', -60e3); %N
	
##BC(end+1) = struct( ...
##	'name', 'Distributed Load', ...
##	'conditionType', 'distributedLoad', ...
##	'targetType', 'Element', ...
##	'targets', [1 2], ...
##	'value', 2e3); %N/m
##BC(end+1) = struct( ...
##	'name', 'Precribed Displacement', ...
##	'conditionType', 'prescribedDisplacement', ...
##	'targetType', 'Node', ...
##	'targets', 2, ...
##	'value', -0.01); %rad
##BC(end+1) = struct( ...
##	'name', 'Temperature Load', ...
##	'conditionType', 'temperatureLoad', ...
##	'targetType', 'Element', ...
##	'targets', [1 2], ...
##	'value', [50 150]); %Kelvin
BC(end+1) = struct( ...
	'name', 'Elastic support', ...
	'conditionType', 'elasticSupport', ...
	'targetType', 'Node', ...
	'targets', 5, ...
	'value', 20e3); %N/m

% Build system
%  Building stiffness matrix
K = zeros(6,6);
EI = E.YoungModulus .* E.RotationalInertia;
for i = 1:rows(E.Elements)
	Kidx2 = 2*E.Elements(i,1);
	Kidx1 = Kidx2 - 1;
	Kidx4 = 2*E.Elements(i,2);
	Kidx3 = Kidx4 - 1;
	
	K(Kidx1, Kidx1) += 12*EI(i)/E.Length(i)/E.Length(i)/E.Length(i);
	K(Kidx1, Kidx2) += 6*EI(i)/E.Length(i)/E.Length(i);
	K(Kidx1, Kidx3) -= 12*EI(i)/E.Length(i)/E.Length(i)/E.Length(i);
	K(Kidx1, Kidx4) += 6*EI(i)/E.Length(i)/E.Length(i);
	
	K(Kidx2, Kidx1) += 6*EI(i)/E.Length(i)/E.Length(i);
	K(Kidx2, Kidx2) += 4*EI(i)/E.Length(i);
	K(Kidx2, Kidx3) -= 6*EI(i)/E.Length(i)/E.Length(i);
	K(Kidx2, Kidx4) += 2*EI(i)/E.Length(i);
	
	K(Kidx3, Kidx1) -= 12*EI(i)/E.Length(i)/E.Length(i)/E.Length(i);
	K(Kidx3, Kidx2) -= 6*EI(i)/E.Length(i)/E.Length(i);
	K(Kidx3, Kidx3) += 12*EI(i)/E.Length(i)/E.Length(i)/E.Length(i);
	K(Kidx3, Kidx4) -= 6*EI(i)/E.Length(i)/E.Length(i);
	
	K(Kidx4, Kidx1) += 6*EI(i)/E.Length(i)/E.Length(i);
	K(Kidx4, Kidx2) += 2*EI(i)/E.Length(i);
	K(Kidx4, Kidx3) -= 6*EI(i)/E.Length(i)/E.Length(i);
	K(Kidx4, Kidx4) += 4*EI(i)/E.Length(i);
end

%  Initializing displacement vector
U = zeros(columns(K), 1);
%  Initializing forces vector
F = zeros(columns(K), 1);

%  Mark unknown displacements to be solved
sU = zeros(columns(K), 1);
%  Known forces
sF = ones(columns(K), 1);

% Boundary Conditions
Fpl = zeros(columns(K),1); % Point loads
Fdl = zeros(columns(K),1); % Distributed loads
Fpd = zeros(columns(K),1); % Prescribed displacement loads
Ft = zeros(columns(K),1); % Temperature loads
Kes = sparse(rows(K), columns(K)); % Elastic suport stiffness matrix

for i = 1:length(BC)
	if strcmp(BC(i).conditionType, 'pointLoad')
		for j = BC(i).targets
			Fpl(j) += BC(i).value;
		end
	elseif strcmp(BC(i).conditionType, 'distributedLoad')
		for j = BC(i).targets
			Kidx2 = 2*E.Elements(j,1);
			Kidx1 = Kidx2 - 1;
			Kidx4 = 2*E.Elements(j,2);
			Kidx3 = Kidx4 - 1;
			Fdl(Kidx1) += BC(i).value*E.Length(j)/2;
			Fdl(Kidx2) += BC(i).value*E.Length(j)*E.Length(j)/12;
			Fdl(Kidx3) += BC(i).value*E.Length(j)/2;
			Fdl(Kidx4) -= BC(i).value*E.Length(j)*E.Length(j)/12;
		end
	elseif strcmp(BC(i).conditionType, 'prescribedDisplacement')
		for j = BC(i).targets
			sU(j) = 1; % Known displacement
			U(j) += BC(i).value;
			sF(j) = 0; % Unknown force
			Fpd += K(:,j)*U(j);
		end
	elseif strcmp(BC(i).conditionType, 'temperatureLoad')
		#  Temperature loads
		for j = BC(i).targets
			Kidx2 = 2*E.Elements(j,1);
			Kidx1 = Kidx2 - 1;
			Kidx4 = 2*E.Elements(j,2);
			Kidx3 = Kidx4 - 1;
			dT = BC(i).value(1) - BC(i).value(2); %Kelvin
			Tau = E.ThermalExpansionCoefficient(j)*EI(j)/E.Height(j)*dT;
			Ft(Kidx2) -= Tau;
			Ft(Kidx4) += Tau;
		end
	elseif strcmp(BC(i).conditionType, 'elasticSupport')
		for j = BC(i).targets
			sF(j) = 0;
			Kes(j,j) += BC(i).value;
		end
	end
end
F = Fpl - Fdl - Fpd - Ft;

% Solving system
%  Solving unconstrained displacements with known forces
sIdx = sU == 0;
U(sIdx) = (K(sIdx,sIdx) - Kes(sIdx,sIdx))\F(sIdx);

%  Finding total forces actuating upon nodes
F = K*U;

%  Finding reactions on supports
R = zeros(columns(K));
R = F + Fdl + Ft;

% Filter too small values that can be disconsidered
R(abs(R) < 1e-5) = 0;
U(abs(U) < 1e-10) = 0;

% Display results
##format short eng;
disp("Displacement:");
disp(U);
disp("");
disp("Reactions:");
disp(R);