clear;
clc;

program.pwd = pwd;
sim.directory = uigetdir('', 'Simulation directory');

readElements;
buildSystem;
readBoundaryConditions;
applyBoundaryConditions;
solveSystem;

% Display results
disp("Displacements");
disp(U);

disp("");
disp("Reactions");
disp(Reactions);

createFigures;