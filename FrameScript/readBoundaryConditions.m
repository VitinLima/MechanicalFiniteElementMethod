cd(sim.directory);

% Boundary conditions
simulation.BoundaryConditions = struct('Name',{},'Condition',{},'Value',{},'DisplayOrientation',{},'Elements',{},'Nodes',{});

[fid, msg] = fopen("BoundaryConditions.txt");

reading = 'NONE';

name = '';
condition = '';
coordinateSystem = 'Cartesian';
value = NaN;
displayOrientation = '';
elements = [];
while (l = fgetl(fid)) != -1 || isempty(l)
	if isempty(l)
		continue;
	end
	if l(1) == '%'
		continue;
	end
	
	if strcmp(l, 'BOUNDARY CONDITION')
		reading = 'BOUNDARY CONDITION';
		continue;
	elseif strcmp(l, 'END')
		reading = 'NONE';
		simulation.BoundaryConditions(end+1).Name = strjoin(name,' ');
		simulation.BoundaryConditions(end).Condition = cell2mat(condition);
		if strcmp(condition, 'Rotation') || strcmp(condition, 'Moment') || strcmp(condition, 'ElasticRotationSupport')
			value = cell2mat(value(1:end));
			value = strsplit(value,',');
			simulation.BoundaryConditions(end).Value = str2double(value(1));
		else
			if strcmp(coordinateSystem, 'Cartesian')
				value = cell2mat(value(1:end));
				value = strsplit(value,',');
				simulation.BoundaryConditions(end).Value = str2double(value(1:end));
			elseif strcmp(coordinateSystem, 'Polar')
				value = cell2mat(value(1:end));
				value = strsplit(value,',');
				value = str2double(value);
				simulation.BoundaryConditions(end).Value = value(1)*[cosd(value(2)) sind(value(2))];
			elseif strcmp(coordinateSystem, 'Horizontal')
				simulation.BoundaryConditions(end).Value = [str2double(value(1)) NaN];
			elseif strcmp(coordinateSystem, 'Vertical')
				simulation.BoundaryConditions(end).Value = [NaN str2double(value(1))];
			endif
		endif
		simulation.BoundaryConditions(end).DisplayOrientation = displayOrientation;
		simulation.BoundaryConditions(end).Elements = str2double(elements);
		simulation.BoundaryConditions(end).Nodes = str2double(nodes);
		name = '';
		condition = '';
		coordinateSystem = '';
		value = NaN;
		displayOrientation = '';
		elements = [];
		nodes = [];
		continue;
	end
	
	if strcmp(reading, 'BOUNDARY CONDITION')
		l = strsplit(l, {'=', ' '});
		if strncmp(l(1), 'Name', 4)
			name = l(2:end);
			continue;
		elseif strncmp(l(1), 'Condition', 9)
			condition = l(2:end);
			continue;
		elseif strncmp(l(1), 'CoordinateSystem', 16)
			coordinateSystem = l(2:end);
			continue;
		elseif strncmp(l(1), 'Value', 5)
			value = l(2:end);
			continue;
		elseif strncmp(l(1), 'DisplayOrientation', 18)
			displayOrientation = l(2:end);
			continue;
		elseif strncmp(l(1), 'Elements', 8)
			elements = l(2:end);
			continue;
		elseif strncmp(l(1), 'Nodes', 5)
			nodes = l(2:end);
			continue;
		endif
	endif
endwhile

fclose(fid);

cd(program.pwd);