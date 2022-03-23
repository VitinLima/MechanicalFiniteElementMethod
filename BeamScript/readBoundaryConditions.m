cd(sim.directory);

% Boundary conditions
BC = struct('name',{},'conditionType',{},'targetType',{},'numberOfTargets',{},'value',{},'targets',{},'supportOrientation',{});

[fid, msg] = fopen("BoundaryConditions.txt");

flag = true;
while flag
	if (s=fgetl(fid)) == -1
		flag = false;
		continue;
	end
	if isempty(s)
		continue;
	end
	if s(1) == '%' || s(1) == '#'
		continue;
	end
	s = strsplit(s, ',');
	BC(end+1).name = cell2mat(s(1));
	BC(end).conditionType = cell2mat(s(2));
	BC(end).targetType = cell2mat(s(3));
	BC(end).numberOfTargets = str2double(s(4));
	if strcmp(BC(end).conditionType, 'temperatureLoad')
		BC(end).value = s(5:6);
		if length(s) > 6
			BC(end).supportOrientation = cell2mat(s(7));
		end
	else
		BC(end).value = s(5);
		if length(s) > 5
			BC(end).supportOrientation = cell2mat(s(6));
		end
	endif
	while length(BC(end).targets) < BC(end).numberOfTargets && flag
		if (s=fgetl(fid)) == -1
			flag = false;
			continue;
		end
		BC(end).targets = [BC(end).targets, str2double(strsplit(s,' '))];
	end
endwhile

fclose(fid);

cd(program.pwd);