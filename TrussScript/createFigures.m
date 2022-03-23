close all;

figure;
hold on;
axis equal;
title("Resolved system");

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
			vx = cosd(str2double(bc.value(2)))*str2double(bc.value(1));
			vy = sind(str2double(bc.value(2)))*str2double(bc.value(1));
	endswitch
	switch conditionTypeChoice
		case 1
			if !isempty(idx) && isempty(idy)
				angle = linspace(1,360,20);
				line([N(bc.targets,1) + 0.1*[0 sign(vx)]].',[N(bc.targets,2) + 0.1*[0 sign(vy)]].', 'color', 'green');
				if strcmp(bc.supportOrientation, 'left')
					line(0.1*sign(vx)+[N(bc.targets,1)-[0 0.1 0.1 0]].', 0.1*sign(vx)+[N(bc.targets,2)+[0 0.1 -0.1 0]].', 'color', 'green');
					line(-0.125+0.1*sign(vx)+[N(bc.targets,1)+0.025*cosd(angle)].', 0.05+0.1*sign(vx)+[N(bc.targets,2)+0.025*sind(angle)].', 'color', 'green');
					line(-0.125+0.1*sign(vx)+[N(bc.targets,1)+0.025*cosd(angle)].', -0.05+0.1*sign(vx)+[N(bc.targets,2)+0.025*sind(angle)].', 'color', 'green');
				elseif strcmp(bc.supportOrientation, 'right')
					line(0.1*sign(vx)+[N(bc.targets,1)+[0 0.1 0.1 0]].', 0.1*sign(vx)+[N(bc.targets,2)+[0 0.1 -0.1 0]].', 'color', 'green');
					line(0.125+0.1*sign(vx)+[N(bc.targets,1)+0.025*cosd(angle)].', 0.05+0.1*sign(vx)+[N(bc.targets,2)+0.025*sind(angle)].', 'color', 'green');
					line(0.125+0.1*sign(vx)+[N(bc.targets,1)+0.025*cosd(angle)].', -0.05+0.1*sign(vx)+[N(bc.targets,2)+0.025*sind(angle)].', 'color', 'green');
				end
			elseif !isempty(idy) && isempty(idx)
				angle = linspace(1,360,20);
				line([N(bc.targets,1) + 0.1*[0 sign(vx)]].',[N(bc.targets,2) + 0.1*[0 sign(vy)]].', 'color', 'green');
				if strcmp(bc.supportOrientation, 'top')
					line(0.1*sign(vy)+[N(bc.targets,1)+[0 0.1 -0.1 0]].', 0.1*sign(vy)+[N(bc.targets,2)+[0 0.1 0.1 0]].', 'color', 'green');
					line(0.05+0.1*sign(vy)+[N(bc.targets,1)+0.025*cosd(angle)].', 0.125+0.1*sign(vy)+[N(bc.targets,2)+0.025*sind(angle)].', 'color', 'green');
					line(-0.05+0.1*sign(vy)+[N(bc.targets,1)+0.025*cosd(angle)].', 0.125+0.1*sign(vy)+[N(bc.targets,2)+0.025*sind(angle)].', 'color', 'green');
				elseif strcmp(bc.supportOrientation, 'bottom')
					line(0.1*sign(vy)+[N(bc.targets,1)+[0 0.1 -0.1 0]].', 0.1*sign(vy)+[N(bc.targets,2)-[0 0.1 0.1 0]].', 'color', 'green');
					line(0.05+0.1*sign(vy)+[N(bc.targets,1)+0.025*cosd(angle)].', -0.125+0.1*sign(vy)+[N(bc.targets,2)+0.025*sind(angle)].', 'color', 'green');
					line(-0.05+0.1*sign(vy)+[N(bc.targets,1)+0.025*cosd(angle)].', -0.125+0.1*sign(vy)+[N(bc.targets,2)+0.025*sind(angle)].', 'color', 'green');
				end
			elseif vx == 0 && vy == 0
				if strcmp(bc.supportOrientation, 'top')
					line(0.1*sign(vy)+[N(bc.targets,1)+[0 0.1 -0.1 0]].', 0.1*sign(vy)+[N(bc.targets,2)-[0 -0.1 -0.1 0]].', 'color', 'green');
				elseif strcmp(bc.supportOrientation, 'bottom')
					line(0.1*sign(vy)+[N(bc.targets,1)+[0 0.1 -0.1 0]].', 0.1*sign(vy)+[N(bc.targets,2)+[0 -0.1 -0.1 0]].', 'color', 'green');
				elseif strcmp(bc.supportOrientation, 'left')
					line(0.1*sign(vy)+[N(bc.targets,1)+[0 -0.1 -0.1 0]].', 0.1*sign(vy)+[N(bc.targets,2)+[0 0.1 -0.1 0]].', 'color', 'green');
				elseif strcmp(bc.supportOrientation, 'right')
					line(0.1*sign(vy)+[N(bc.targets,1)-[0 -0.1 -0.1 0]].', 0.1*sign(vy)+[N(bc.targets,2)+[0 0.1 -0.1 0]].', 'color', 'green');
				endif
			else
				angle = atan2(vy,vx);
				line([N(bc.targets,1)+[0 0.1*cos(angle)]].',[N(bc.targets,2)+[0 0.1*sin(angle)]].', 'color', 'green');
				line([N(bc.targets,1)+0.1*(cos(angle)+0.5*[sin(angle) -sin(angle)])].',[N(bc.targets,2)+0.1*(sin(angle)-0.5*[cos(angle) -cos(angle)])].', 'color', 'green');
			endif
		case 2
			angle = atan2(vy,vx);
			quiver(N(bc.targets,1), N(bc.targets,2), 0.3*cos(angle), 0.3*sin(angle), 'color', 'blue');
		case 3
##			line([N(bc.targets) N(bc.targets)-0.1 N(bc.targets)+0.1 N(bc.targets)-0.1 N(bc.targets)+0.1 N(bc.targets)-0.1 N(bc.targets)+0.1 N(bc.targets)-0.1 N(bc.targets)+0.1 N(bc.targets)-0.1 N(bc.targets)].', -[0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5].', 'color', 'yellow');
	endswitch
endfor

line([N(E(:,1),1) N(E(:,2),1)].', [N(E(:,1),2) N(E(:,2),2)].', 'color', 'blue');
scatter(N(:,1),N(:,2),36, "b", "filled");
scatter(N(:,1),N(:,2),23, "w", "filled");