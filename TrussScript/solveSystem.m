% Solving system
%  Solving unconstrained displacements with known forces
U(sU==0) = (K(sU==0,sU==0) - Kes(sU==0,sU==0))\(Fpl(sU==0) - Fpd(sU==0));

T = zeros(rows(E),1);

for i = 1:rows(E)
	n1x = N(E(i,1),1) + U(2*E(i,1)-1);
	n1y = N(E(i,1),2) + U(2*E(i,1));
	n2x = N(E(i,2),1) + U(2*E(i,2)-1);
	n2y = N(E(i,2),2) + U(2*E(i,2));
	dx = n2x-n1x;
	dy = n2y-n1y;
	T(i) = E(i,3)*E(i,5)/E(i,6)*(E(i,6) - sqrt(dx*dx + dy*dy));
endfor

Reactions = K*U - Fpl + Fpd;

% Filter too small values that can be disconsidered
U(abs(U) < 1e-10) = 0;
Reactions(abs(Reactions) < 1e-10) = 0;