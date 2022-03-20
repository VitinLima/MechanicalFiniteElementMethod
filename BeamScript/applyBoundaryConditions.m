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