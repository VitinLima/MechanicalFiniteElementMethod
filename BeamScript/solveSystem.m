% Solving system
%  Solving unconstrained displacements with known forces
sIdx = sU == 0;
U(sIdx) = (K(sIdx,sIdx) - Kes(sIdx,sIdx))\(Fpl(sIdx) - Fdl(sIdx) - Fpd(sIdx) - Ft(sIdx));

%  Finding total forces actuating upon nodes
F = K*U;

%  Finding reactions on supports
R = zeros(columns(K));
R = F + Fdl + Ft;

% Filter too small values that can be disconsidered
R(abs(R) < 1e-5) = 0;
U(abs(U) < 1e-10) = 0;