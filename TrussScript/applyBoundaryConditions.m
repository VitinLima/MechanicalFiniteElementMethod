%  Initializing displacement vector
U = zeros(columns(K), 1);

%  Mark unknown displacements to be solved
sU = zeros(columns(K), 1);

% Boundary Conditions
Fpl = zeros(columns(K),1); % Point loads
Kes = sparse(rows(K), columns(K)); % Elastic suport stiffness matrix

for bc = BC
	if strcmp(bc.conditionType, 'prescribedDisplacement')
		for j = bc.targets
			sU(j) = 1; % Known displacement
			U(j) += str2double(bc.value);
		endfor
	elseif strcmp(bc.conditionType, 'pointLoad')
		if strcmp(cell2mat(bc.value(1)), 'polar')
			for j = bc.targets
				Fpl(2*j-1) += str2double(bc.value(2))*cosd(str2double(bc.value(3)));
				Fpl(2*j) += str2double(bc.value(2))*sind(str2double(bc.value(3)));
			endfor
		elseif strcmp(cell2mat(bc.value(1)), 'cartesian')
			for j = bc.targets
				Fpl(2*j-1) += str2double(bc.value(2));
				Fpl(2*j) += str2double(bc.value(3));
			endfor
		endif
	elseif strcmp(BC(i).conditionType, 'elasticSupport')
		for j = bc.targets
			Kes(j,j) += str2double(bc.value);
		endfor
	end
endfor
Fpd = K(:,sU==1)*U(sU==1); % Prescribed displacement loads