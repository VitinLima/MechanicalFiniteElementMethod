[fid, msg] = fopen("Nodes.txt");

lines = {};
while (l=fgetl(fid)) != -1
	lines(end+1) = l;
endwhile

fclose(fid);

idx = 1;
for s = lines
	s = cell2mat(s);
	N(idx++, 1) = str2double(s);
endfor

[fid, msg] = fopen("Elements.txt");

lines = {};
while (l=fgetl(fid)) != -1
	lines(end+1) = l;
endwhile

fclose(fid);

idx = 1;
YM = NaN;
B = NaN;
H = NaN;
TEC = NaN;
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
	elseif strncmp(s, 'Base', 4)
		s = strsplit(s, '=');
		B = str2double(s(2));
		continue;
	elseif strncmp(s, 'Height', 6)
		s = strsplit(s, '=');
		H = str2double(s(2));
		continue;
	elseif strncmp(s, 'ThermalExpansionCoefficient', 27)
		s = strsplit(s, '=');
		TEC = str2double(s(2));
		continue;
	end
	s = strsplit(s, ' ');
	E(idx,:) = [str2double(s), YM, B, H, 0, B*H*H*H/12, TEC];
	E(idx,6) = abs(N(E(idx, 2)) - N(E(idx++, 1)));
endfor