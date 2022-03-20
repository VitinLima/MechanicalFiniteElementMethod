clear;
clc;

readElements;
buildSystem;
readBoundaryConditions;
applyBoundaryConditions;
solveSystem;

% Display results
##format short eng;
disp("Displacement:");
disp(U);
disp("");
disp("Reactions:");
disp(R);