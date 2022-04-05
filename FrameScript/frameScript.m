clear;
clc;

program.pwd = pwd;
sim.directory = uigetdir('', 'Simulation directory');

readElements;
buildSystem;
readBoundaryConditions;
applyBoundaryConditions;
solveSystem;