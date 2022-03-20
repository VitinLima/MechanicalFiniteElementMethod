[fid, msg] = fopen("Nodes.txt");

lines = {};
while (l=fgetl(fid)) != -1
	lines(end+1) = l;
endwhile

fclose(fid);

idx = 1;
for s = lines
	s = cell2mat(s);
	s = strsplit(s, ';');
	N(idx++,:) = str2double(s);
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
	s = strsplit(s, ';');
	p = N(str2double(s),:);
	dx = p(1,1) - p(2,1);
	dy = p(1,2) - p(2,2);
	E(idx++,:) = [p(1), p(2), YM, B, H, sqrt(dx*dx + dy*dy), B*H*H*H/12, TEC];
endfor