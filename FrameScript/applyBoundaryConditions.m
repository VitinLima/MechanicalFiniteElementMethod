%  Initializing displacement vector
simulation.Displacements = zeros(columns(simulation.StiffnessMatrix), 1);

%  Mark unknown displacements to be solved
simulation.KnownDisplacements = zeros(columns(simulation.StiffnessMatrix), 1);

% Boundary Conditions
simulation.PointLoads = zeros(columns(simulation.StiffnessMatrix),1); % Point loads
simulation.DistributedLoads = zeros(columns(simulation.StiffnessMatrix),1); % Distributed loads
simulation.PrescribedDisplacementLoads = zeros(columns(simulation.StiffnessMatrix),1); % Prescribed displacement loads
simulation.ThermalLoads = zeros(columns(simulation.StiffnessMatrix),1); % Temperature loads
simulation.ElasticSupportsMatrix = zeros(size(simulation.StiffnessMatrix)); % Elastic suport stiffness matrix

% conditionOptions: 'Force', 'Moment', 'Translation', 'Rotation', 'ThermalLoad', 'ElasticSupport', 'ElasticRotationSupport'

for bc = simulation.BoundaryConditions
	if strcmp(bc.Condition, 'Translation')
		if !isnan(bc.Nodes)
			i3 = 3*bc.Nodes;
			i2 = i3-1;
			i1 = i2-1;
			if !isnan(bc.Value(1))
				simulation.KnownDisplacements(i1) = 1; % Known displacement
				simulation.Displacements += accumarray(i1', bc.Value(1), size(simulation.Displacements));
			endif
			if !isnan(bc.Value(2))
				simulation.KnownDisplacements(i2) = 1;
				simulation.Displacements += accumarray(i2', bc.Value(2), size(simulation.Displacements));
			endif
		endif
	elseif strcmp(bc.Condition, 'Rotation')
		if !isnan(bc.Nodes)
			i3 = 3*bc.Nodes;
			if !isnan(bc.Value(1))
				simulation.KnownDisplacements(i3) = 1; % Known displacement
				simulation.Displacements += accumarray(i3', bc.Value(1), size(simulation.Displacements));
			endif
		endif
	elseif strcmp(bc.Condition, 'Force')
		if !isnan(bc.Nodes)
			i3 = 3*bc.Nodes;
			i2 = i3-1;
			i1 = i2-1;
			if !isnan(bc.Value(1))
				simulation.PointLoads += accumarray(i1', bc.Value(1), size(simulation.PointLoads));
			endif
			if !isnan(bc.Value(2))
				simulation.PointLoads += accumarray(i2', bc.Value(2), size(simulation.PointLoads));
			endif
		endif
		if !isnan(bc.Elements)
			i3 = 3*simulation.Elements(bc.Elements,1);
			i6 = 3*simulation.Elements(bc.Elements,2);
			if !isnan(bc.Value(1))
				i1 = i3-2;
				i4 = i6-2;
				sL = simulation.Nodes(simulation.Elements(bc.Elements,2),2)-simulation.Nodes(simulation.Elements(bc.Elements,1),2);
				s2L2 = sL.*sL; 
				simulation.DistributedLoads += accumarray(i1,bc.Value(1)*sL/2, size(simulation.DistributedLoads));
				simulation.DistributedLoads += accumarray(i3,bc.Value(1)*s2L2/12, size(simulation.DistributedLoads));
				simulation.DistributedLoads += accumarray(i4,bc.Value(1)*sL/2, size(simulation.DistributedLoads));
				simulation.DistributedLoads -= accumarray(i6,bc.Value(1)*s2L2/12, size(simulation.DistributedLoads));
			endif
			if !isnan(bc.Value(2))
				i2 = i3-1;
				i5 = i6-1;
				cL = simulation.Nodes(simulation.Elements(bc.Elements,2),1)-simulation.Nodes(simulation.Elements(bc.Elements,1),1);
				c2L2 = cL.*cL;
				simulation.DistributedLoads += accumarray(i2,bc.Value(2)*cL/2, size(simulation.DistributedLoads));
				simulation.DistributedLoads += accumarray(i3,bc.Value(2)*c2L2/12, size(simulation.DistributedLoads));
				simulation.DistributedLoads += accumarray(i5,bc.Value(2)*cL/2, size(simulation.DistributedLoads));
				simulation.DistributedLoads -= accumarray(i6,bc.Value(2)*c2L2/12, size(simulation.DistributedLoads));
			endif
		endif
	elseif strcmp(bc.Condition, 'Moment')
		if !isnan(bc.Nodes)
			i3 = 3*bc.Nodes;
			if !isnan(bc.Value(1))
				simulation.PointLoads += accumarray(i3', bc.Value(1), size(simulation.PointLoads));
			endif
		endif
	elseif strcmp(bc.Condition, 'ThermalLoad')
		if !isnan(bc.Elements)
			i3 = 3*simulation.Elements(bc.Elements,1);
			i6 = 3*simulation.Elements(bc.Elements,2);
			dT = str2double(bc.Value(1)) - str2double(bc.Value(2)); %Kelvin
			Tau = simulation.YoungModulus(bc.Elements).*simulation.MomentOfInertia(bc.Elements).*simulation.ThermalExpensionCoefficient(bc.Elements)./simulation.Height(bc.Elements)*dT;
			simulation.ThermalLoads += accumarray(i3, Tau, size(simulation.ThermalLoads));
			simulation.ThermalLoads -= accumarray(i6, Tau, size(simulation.ThermalLoads));
		endif
	elseif strcmp(bc.Condition, 'ElasticSupport')
		if !isnan(bc.Nodes)
			i3 = 3*bc.Nodes;
			i2 = i3-1;
			i1 = i2-1;
			if !isnan(bc.Value(1))
				simulation.ElasticSupportsMatrix += accumarray([i1, i1], bc.Value(1), size(simulation.ElasticSupportsMatrix));
			endif
			if !isnan(bc.Value(2))
				simulation.ElasticSupportsMatrix += accumarray([i2, i2], bc.Value(2), size(simulation.ElasticSupportsMatrix));
			endif
		endif
	endif
endfor
simulation.PrescribedDisplacementLoads = simulation.StiffnessMatrix(:,simulation.KnownDisplacements==1)*simulation.Displacements(simulation.KnownDisplacements==1); % Prescribed displacement loads