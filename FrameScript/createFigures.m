close all;

figure;
hold on;
##axis equal;
title("Resolved system");

line([N(E(:,1)) N(E(:,2))].', zeros(rows(E), 2).', 'color', 'blue');
line(N,zeros(rows(N),1), 'marker', '*', 'linestyle', 'none', 'color', 'blue');

for bc = BC
	if strcmp(bc.conditionType, 'forceLoad')
		if str2double(bc.value) > 0
			quiver(N(bc.targets), -ones(size(N(bc.targets))), zeros(size(N(bc.targets))), ones(size(N(bc.targets))), 'color', 'blue');
		elseif str2double(bc.value) < 0
			quiver(N(bc.targets), ones(size(N(bc.targets))), zeros(size(N(bc.targets))), -ones(size(N(bc.targets))), 'color', 'blue');
		endif
	elseif strcmp(bc.conditionType, 'momentLoad')
		angle = deg2rad(1:270);
		if str2double(bc.value) > 0
			line([N(bc.targets) + cos(angle)/5].', sin(angle)/5.', 'color', 'blue');
			line([N(bc.targets) N(bc.targets)-0.1], [-0.2 -0.1], 'color', 'blue');
			line([N(bc.targets) N(bc.targets)-0.1], [-0.2 -0.3], 'color', 'blue');
		elseif str2double(bc.value) < 0
			line([N(bc.targets) + cos(angle)/5].', -sin(angle)/5.', 'color', 'blue');
			line([N(bc.targets) N(bc.targets)-0.1], [0.2 0.1], 'color', 'blue');
			line([N(bc.targets) N(bc.targets)-0.1], [0.2 0.3], 'color', 'blue');
		endif
	elseif strcmp(bc.conditionType, 'distributedForceLoad')
		if str2double(bc.value) > 0
			for idx = bc.targets
				p = linspace(N(E(idx,1)),N(E(idx,2)),ceil((N(E(idx,2))-N(E(idx,1)))/0.2))';
				quiver(p, -ones(size(p))/2, zeros(size(p)), ones(size(p))/2, 0.6, 'color', 'blue');
				line([N(E(idx,1)),N(E(idx,2))], [-0.5, -0.5], 'linestyle', '--', 'color', 'blue');
			endfor
		elseif str2double(bc.value) < 0
			for idx = bc.targets
				p = linspace(N(E(idx,1)),N(E(idx,2)),ceil((N(E(idx,2))-N(E(idx,1)))/0.2))';
				quiver(p, ones(size(p))/2, zeros(size(p)), -ones(size(p))/2, 0.6, 'color', 'blue');
				line([N(E(idx,1)),N(E(idx,2))], [0.5, 0.5], 'linestyle', '--', 'color', 'blue');
			endfor
		endif
	elseif strcmp(bc.conditionType, 'distributedMomentLoad')
	elseif strcmp(bc.conditionType, 'prescribedTranslationalDisplacement')
		if str2double(bc.value) > 0
			for idx = bc.targets
				line([N(idx) N(idx)], [0 0.1], 'color', 'green')
				line([N(idx)-0.1 N(idx)+0.1], [0.1 0.1], 'color', 'green')
			endfor
		elseif str2double(bc.value) < 0
			for idx = bc.targets
				line([N(idx) N(idx)], [0 -0.1], 'color', 'green')
				line([N(idx)-0.1 N(idx)+0.1], [-0.1 -0.1], 'color', 'green')
			endfor
		else
			for idx = bc.targets
				line([N(idx)-0.1 N(idx)+0.1], [0.1 -0.1], 'color', 'green')
				line([N(idx)-0.1 N(idx)+0.1], [-0.1 0.1], 'color', 'green')
			endfor
		endif
	elseif strcmp(bc.conditionType, 'prescribedRotationalDisplacement')
		if str2double(bc.value) > 0
			angle = deg2rad(1:330);
			line([N(bc.targets)+0.1*cos(angle)].', -0.1*sin(angle).', 'color', 'green');
			line([N(bc.targets) N(bc.targets)+0.1*cos(angle(end))].', [0 -0.1*sin(angle(end))].', 'color', 'green');
			line([N(bc.targets) N(bc.targets)+0.1].', [0 0].', 'color', 'green');
		elseif str2double(bc.value) < 0
			angle = deg2rad(1:330);
			line([N(bc.targets)+0.1*cos(angle)].', 0.1*sin(angle).', 'color', 'green');
			line([N(bc.targets) N(bc.targets)+0.1*cos(angle(end))].', [0 0.1*sin(angle(end))].', 'color', 'green');
			line([N(bc.targets) N(bc.targets)+0.1].', [0 0].', 'color', 'green');
		else
			angle = deg2rad(1:360);
			line([N(bc.targets) + 0.1*cos(angle)].', 0.1*sin(angle).', 'color', 'green');
		endif
	elseif strcmp(bc.conditionType, 'temperatureLoad')
		if str2double(bc.value(1)) > str2double(bc.value(2))
			for idx = bc.targets
				angle2 = deg2rad(linspace(-45,3*360 - 45,50));
				p = linspace(N(E(idx,1))+0.1,N(E(idx,2))-0.1,ceil((N(E(idx,2))-N(E(idx,1)))/0.2));
				line([p p-0.05].', -[0.1*ones(size(p)) 0.05*ones(size(p))].', 'color', 'red');
				line([p p+0.05].', -[0.1*ones(size(p)) 0.05*ones(size(p))].', 'color', 'red');
				line([p + 0.05*cos(angle2)].',[zeros(size(p))+linspace(-0.1,0.1,length(angle2))].', 'color', 'red');
			endfor
		elseif str2double(bc.value(1)) < str2double(bc.value(2))
			for idx = bc.targets
				angle1 = deg2rad(linspace(0,180,10));
				angle2 = deg2rad(linspace(0,3*360+180,50));
				p = linspace(N(E(idx,1))+0.1,N(E(idx,2))-0.1,ceil((N(E(idx,2))-N(E(idx,1)))/0.2))';
				line([p p-0.05].', [0.1*ones(size(p)) 0.05*ones(size(p))].', 'color', 'red');
				line([p p+0.05].', [0.1*ones(size(p)) 0.05*ones(size(p))].', 'color', 'red');
				line([p + [0.0125-0.0125*cos(angle1), 0.025*cos(angle2), -0.0125+0.0125*cos(angle1(end:-1:1))]].',[zeros(size(p))+[linspace(-0.1,-0.07,length(angle1)), linspace(-0.07,0.07,length(angle2)), linspace(0.07,0.1,length(angle1))]].', 'color', 'red');
			endfor
		endif
	elseif strcmp(bc.conditionType, 'translationalElasticSupport')
		line([N(bc.targets) N(bc.targets)-0.1 N(bc.targets)+0.1 N(bc.targets)-0.1 N(bc.targets)+0.1 N(bc.targets)-0.1 N(bc.targets)+0.1 N(bc.targets)-0.1 N(bc.targets)+0.1 N(bc.targets)-0.1 N(bc.targets)].', -[0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5].', 'color', 'black')
	end
endfor