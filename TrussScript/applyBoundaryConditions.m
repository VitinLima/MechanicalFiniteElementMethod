%  Initializing displacement vector
U = zeros(columns(K), 1);

%  Mark unknown displacements to be solved
sU = zeros(columns(K), 1);

% Boundary Conditions
Fl = zeros(columns(K),1); % Point loads
Kes = sparse(rows(K), columns(K)); % Elastic suport stiffness matrix
conditionTypeOptions = {'prescribedDisplacement', 'load', 'elasticSupport'};
coordinateTypeOptions = {'horizontal', 'vertical', 'cartesian', 'polar'};

for bc = BC
	conditionTypeChoice = find(strcmp(bc.conditionType, conditionTypeOptions));
	coordinateTypeChoice = find(strcmp(bc.coordinateType, coordinateTypeOptions));
	switch coordinateTypeChoice
		case 1
			idx = 2*bc.targets'-1;
			idy = [];
			vx = str2double(bc.value);
			vy = 0;
		case 2
			idx = [];
			idy = 2*bc.targets';
			vx = 0;
			vy = str2double(bc.value);
		case 3
			idx = 2*bc.targets'-1;
			idy = 2*bc.targets';
			vx = str2double(bc.value(1));
			vy = str2double(bc.value(2));
		case 4
			idx = 2*bc.targets'-1;
			idy = 2*bc.targets';
			vx = cosd(str2double(bc.value(1)))*str2double(bc.value(2));
			vy = sind(str2double(bc.value(1)))*str2double(bc.value(2));
	end
	switch conditionTypeChoice
		case 1
			sU([idx; idy]) = 1; % Known displacement
			U += accumarray(idx, vx, size(U));
			U += accumarray(idy, vy, size(U));
		case 2
			Fl += accumarray(idx, vx, size(Fl));
			Fl += accumarray(idy, vy, size(Fl));
		case 3
			Kes += accumarray([idx, idx], vx, size(Kes));
			Kes += accumarray([idy, idy], vy, size(Kes));
	end
endfor
Fpd = K(:,sU==1)*U(sU==1); % Prescribed displacement loads