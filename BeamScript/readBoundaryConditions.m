clear;
clc;

[fid, msg] = fopen("BoundaryConditions.txt");

lines = {};
while (l=fgetl(fid)) != -1
	lines(end+1) = l;
endwhile

fclose(fid);

% Boundary conditions
BC = struct('name',{},'conditionType',{},'targetType',{},'targets',{},'value',{});

for s = lines
	s = cell2mat(s);
	if isempty(s)
		continue;
	end
	if s(1) == '%' || s(1) == '#'
		continue;
	end
	
endfor