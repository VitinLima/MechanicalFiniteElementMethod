%  Initializing displacement vector
U = zeros(columns(K), 1);

%  Mark unknown displacements to be solved
sU = zeros(columns(K), 1);

% Boundary Conditions
Fpl = zeros(columns(K),1); % Point loads
Fdl = zeros(columns(K),1); % Distributed loads
Fpd = zeros(columns(K),1); % Prescribed displacement loads
Ft = zeros(columns(K),1); % Temperature loads
Kes = sparse(rows(K), columns(K)); % Elastic suport stiffness matrix

for bc = BC
	if strcmp(bc.conditionType, 'pointLoad')
		for j = bc.targets
			Fpl(j) += str2double(bc.value);
		end
	elseif strcmp(bc.conditionType, 'distributedLoad')
		for j = bc.targets
			Kidx2 = 2*E(j,1);
			Kidx1 = Kidx2 - 1;
			Kidx4 = 2*E(j,2);
			Kidx3 = Kidx4 - 1;
			Fdl(Kidx1) += str2double(bc.value)*E(j,6)/2;
			Fdl(Kidx2) += str2double(bc.value)*E(j,6)*E(j,6)/12;
			Fdl(Kidx3) += str2double(bc.value)*E(j,6)/2;
			Fdl(Kidx4) -= str2double(bc.value)*E(j,6)*E(j,6)/12;
		end
	elseif strcmp(bc.conditionType, 'prescribedDisplacement')
		for j = bc.targets
			sU(j) = 1; % Known displacement
			U(j) += str2double(bc.value);
			Fpd += K(:,j)*U(j);
		end
	elseif strcmp(bc.conditionType, 'temperatureLoad')
		#  Temperature loads
		for j = bc.targets
			Kidx2 = 2*E(j,1);
			Kidx1 = Kidx2 - 1;
			Kidx4 = 2*E(j,2);
			Kidx3 = Kidx4 - 1;
			dT = str2double(bc.value(1)) - str2double(bc.value(2)); %Kelvin
			Tau = E(j,8)*E(j,3)*E(j,7)/E(j,5)*dT;
			Ft(Kidx2) += Tau;
			Ft(Kidx4) -= Tau;
		end
	elseif strcmp(bc.conditionType, 'elasticSupport')
		for j = bc.targets
			Kes(j,j) += str2double(bc.value);
		end
	end
end