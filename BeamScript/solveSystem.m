% Solving system
%  Solving unconstrained displacements with known forces
U(sU==0) = (K(sU==0,sU==0) + Kes(sU==0,sU==0))\(Fpl(sU==0) + Fdl(sU==0) - Fpd(sU==0) - Ft(sU==0));

Reactions = K*U - Fpl - Fdl + Ft;

% Filter too small values that can be disconsidered
U(abs(U) < 1e-7) = 0;
Reactions(abs(Reactions) < 1e-7) = 0;