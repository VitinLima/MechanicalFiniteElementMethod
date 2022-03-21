clear;
clc;

readElements;
buildSystem;
readBoundaryConditions;
applyBoundaryConditions;
solveSystem;

disp('Displacements');
disp(U);

disp('');
disp('Internal forces on elements');
for i = 1:rows(E)
	if T(i) > 0
		disp(['Element ', num2str(i), ': ', num2str(T(i)), ' (Compression)']);
	else
		disp(['Element ', num2str(i), ': ', num2str(T(i)), ' (Tension)']);
	endif
endfor

disp('');
disp('Reactions');
disp(K*U);