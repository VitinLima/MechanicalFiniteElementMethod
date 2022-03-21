clear;
clc;

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