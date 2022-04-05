%  Building stiffness matrix
simulation.StiffnessMatrix = zeros(3*rows(simulation.Nodes));
for i = 1:rows(simulation.Elements)
	L = simulation.Length(i);
	L2 = L*L;
	L3 = L2*L;
	c = simulation.Nodes(simulation.Elements(i,2),1)-simulation.Nodes(simulation.Elements(i,1),1);
	c /= L;
	s = simulation.Nodes(simulation.Elements(i,2),2)-simulation.Nodes(simulation.Elements(i,1),2);
	s /= L;
	idx = [0 0 3*simulation.Elements(i,1) 0 0 3*simulation.Elements(i,2)];
	idx([2,5]) = idx([3,6])-1;
	idx([1,4]) = idx([2,5])-1;
	R = zeros(6,6);
	R(1,1) = c;	R(1,2) = -s;
	R(2,1) = s;	R(2,2) = c;
	R(3,3) = 1;
	R(4,4) = c;	R(4,5) = -s;
	R(5,4) = s;	R(5,5) = c;
	R(6,6) = 1;
	KL = zeros(6,6); %->Displacement_x, Displecement_y, Angle_z
	KL(1,1) = 1;	KL(1,4) = -1;
	KL(4,1) = -1;	KL(4,4) = 1;
	KL(2,2) = 12/L3;	KL(2,3) = 6/L2;		KL(2,5) = -12/L3;		KL(2,6) = 6/L2;
	KL(3,2) = 6/L;		KL(3,3) = 4/L;		KL(3,5) = -6/L;			KL(3,6) = 2/L;
	KL(5,2) = -12/L3;	KL(5,3) = -6/L2;	KL(5,5) = 12/L3;		KL(5,6) = -6/L2;
	KL(6,2) = 6/L;		KL(6,3) = 2/L;		KL(6,5) = -6/L;			KL(6,6) = 4/L;
	KL([1,4],[1,4]) *= simulation.YoungModulus(i)*simulation.Area(i);
	KL([2,3,5,6],[2,3,5,6]) *= simulation.YoungModulus(i)*simulation.MomentOfInertia(i);
	simulation.StiffnessMatrix(idx,idx) += R*KL*R';
end