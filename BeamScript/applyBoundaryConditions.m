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
	if strcmp(bc.conditionType, 'forceLoad')
		Fpl += accumarray(2*bc.targets'-1, str2double(bc.value), size(Fpl));
	elseif strcmp(bc.conditionType, 'momentLoad')
		Fpl += accumarray(2*bc.targets', str2double(bc.value), size(Fpl));
	elseif strcmp(bc.conditionType, 'distributedForceLoad')
		Fdl += accumarray(2*E(bc.targets',1)-1,str2double(bc.value)*E(bc.targets',6)/2, size(Fdl));
		Fdl += accumarray(2*E(bc.targets',1),str2double(bc.value)*E(bc.targets',6).*E(bc.targets',6)/12, size(Fdl));
		Fdl += accumarray(2*E(bc.targets',2)-1,str2double(bc.value)*E(bc.targets',6)/2, size(Fdl));
		Fdl -= accumarray(2*E(bc.targets',2),str2double(bc.value)*E(bc.targets',6).*E(bc.targets',6)/12, size(Fdl));
	elseif strcmp(bc.conditionType, 'distributedMomentLoad')
	elseif strcmp(bc.conditionType, 'prescribedTranslationalDisplacement')
		sU(2*bc.targets-1) = 1; % Known displacement
		U += accumarray(2*bc.targets'-1, str2double(bc.value), size(U));
		Fpd += K(:,2*bc.targets-1)*U(2*bc.targets-1);
	elseif strcmp(bc.conditionType, 'prescribedRotationalDisplacement')
		sU(2*bc.targets) = 1; % Known displacement
		U += accumarray(2*bc.targets', str2double(bc.value), size(U));
		Fpd += K(:,2*bc.targets)*U(2*bc.targets);
	elseif strcmp(bc.conditionType, 'temperatureLoad')
		#  Temperature loads
		dT = str2double(bc.value(1)) - str2double(bc.value(2)); %Kelvin
		Tau = E(bc.targets',8).*E(bc.targets',3).*E(bc.targets',7)./E(bc.targets',5)*dT;
		Ft += accumarray(2*E(bc.targets',1), Tau, size(Ft));
		Ft -= accumarray(2*E(bc.targets',2), Tau, size(Ft));
	elseif strcmp(bc.conditionType, 'translationalElasticSupport')
		Kes += accumarray([2*bc.targets'-1, 2*bc.targets'-1], str2double(bc.value), size(Kes));
	end
end