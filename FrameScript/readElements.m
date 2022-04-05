cd(sim.directory)

simulation = struct('Elements',[], 'ElementLabels',[], 'Nodes',[], 'NodeLabels',[], 'YoungModulus',[], 'MomentOfInertia',[], 'ThermalExpansionCoefficient',[], 'Length',[], 'Area',[], 'Width',[], 'Height',[], 'StiffnessMatrix',[], 'Displacements',[]);

[fid, msg] = fopen("Nodes.txt");

lines = {};
while (l=fgetl(fid)) != -1
	lines(end+1) = l;
endwhile

fclose(fid);

for s = lines
	s = strsplit(cell2mat(s));
	simulation.Nodes(end+1,:) = str2double(s(1:2));
	if length(s) == 3
		simulation.NodeLabels(end+1) = cell2mat(s(3));
	else
		simulation.NodeLabels(end+1) = ' ';
	end
endfor

[fid, msg] = fopen("Elements.txt");

lines = {};
while (l=fgetl(fid)) != -1
	lines(end+1) = l;
endwhile

fclose(fid);

YM = NaN;
A = NaN;
I = NaN;
TEC = NaN;
H = NaN;
W = NaN;
for s = lines
	s = cell2mat(s);
	if isempty(s)
		continue;
	end
	if s(1) == '%'
		continue;
	end
	if strncmp(s, 'YoungModulus', 12)
		s = strsplit(s, '=');
		YM = str2double(s(2));
		continue;
	elseif strncmp(s, 'Area', 4)
		s = strsplit(s, '=');
		A = str2double(s(2));
		continue;
	elseif strncmp(s, 'Width', 4)
		s = strsplit(s, '=');
		W = str2double(s(2));
		continue;
	elseif strncmp(s, 'Height', 4)
		s = strsplit(s, '=');
		H = str2double(s(2));
		continue;
	elseif strncmp(s, 'MomentOfInertia', 15)
		s = strsplit(s, '=');
		I = str2double(s(2));
		continue;
	elseif strncmp(s, 'ThermalExpansionCoefficient', 27)
		s = strsplit(s, '=');
		TEC = str2double(s(2));
		continue;
	end
	s = strsplit(s, ' ');
	simulation.Elements(end+1,:) = str2double(s(1:2));
	simulation.YoungModulus(end+1) = YM;
	simulation.Area(end+1) = A;
	simulation.Width(end+1) = W;
	simulation.Height(end+1) = H;
	simulation.MomentOfInertia(end+1) = I;
	simulation.ThermalExpansionCoefficient(end+1) = TEC;
	simulation.Length(end+1) = norm(simulation.Nodes(simulation.Elements(end, 2),:) - simulation.Nodes(simulation.Elements(end, 1),:));
	if length(s) == 3
		simulation.ElementLabels(end+1) = cell2mat(s(3));
	else
		simulation.ElementLabels(end+1) = ' ';
	end
endfor

cd(program.pwd);