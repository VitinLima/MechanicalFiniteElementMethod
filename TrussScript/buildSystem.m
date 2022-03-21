K = sparse(2*rows(N), 2*rows(N));

% E = node 1, node 2, Young Modulus, Diameter, Area, Length

for i = 1:rows(E)
	n1x = 2*E(i,1)-1;
	n1y = 2*E(i,1);
	n2x = 2*E(i,2)-1;
	n2y = 2*E(i,2);
	c = (N(E(i,2),1) - N(E(i,1),1))/E(i,6);
	s = (N(E(i,2),2) - N(E(i,1),2))/E(i,6);
	c2 = c*c;
	s2 = s*s;
	cs = c*s;
	K([n1x, n1y, n2x, n2y], [n1x, n1y, n2x, n2y]) += E(i,3)*E(i,5)/E(i,6)*[c2 cs -c2 -cs;
																										cs s2 -cs -s2;
																										-c2 -cs c2 cs;
																										-cs -s2 cs s2];
endfor