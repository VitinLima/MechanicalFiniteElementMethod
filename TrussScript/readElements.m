[fid, msg] = fopen("Nodes.txt");

lines = {};
while (l=fgetl(fid)) != -1
	lines(end+1) = l;
endwhile

fclose(fid);

idx = 1;
for s = lines
	s = cell2mat(s);
	s = strsplit(s, ' ');
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
D = NaN;
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
	elseif strncmp(s, 'Diameter', 8)
		s = strsplit(s, '=');
		D = str2double(s(2));
		continue;
	end
	s = strsplit(s, ' ');
	E(idx,:) = [str2double(s), YM, D, pi*D*D/4, 0];
	p = N(E(idx,1:2),:);
	dx = p(1,1) - p(2,1);
	dy = p(1,2) - p(2,2);
	E(idx++,6) = sqrt(dx*dx + dy*dy);
endfor