% Solving system
%  Solving unconstrained displacements with known forces
simulation.Displacements(simulation.KnownDisplacements==0) = (simulation.StiffnessMatrix(simulation.KnownDisplacements==0,simulation.KnownDisplacements==0) + simulation.ElasticSupportsMatrix(simulation.KnownDisplacements==0,simulation.KnownDisplacements==0))\(simulation.PointLoads(simulation.KnownDisplacements==0) + simulation.DistributedLoads(simulation.KnownDisplacements==0) - simulation.PrescribedDisplacementLoads(simulation.KnownDisplacements==0) - simulation.ThermalLoads(simulation.KnownDisplacements==0));

simulation.Reactions = simulation.StiffnessMatrix*simulation.Displacements - simulation.PointLoads - simulation.DistributedLoads + simulation.ThermalLoads;

% Filter too small values that can be disconsidered
simulation.Displacements(abs(simulation.Displacements) < 1e-7) = 0;
simulation.Reactions(abs(simulation.Reactions) < 1e-7) = 0;