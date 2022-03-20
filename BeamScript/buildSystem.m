%  Building stiffness matrix
K = zeros(2*rows(N),2*rows(N));
for i = 1:rows(E)
	Kidx2 = 2*E(i,1);
	Kidx1 = Kidx2 - 1;
	Kidx4 = 2*E(i,2);
	Kidx3 = Kidx4 - 1;
	
	K(Kidx1, Kidx1) += 12*E(i,3)*E(i,7)/E(i,6)/E(i,6)/E(i,6);
	K(Kidx1, Kidx2) += 6*E(i,3)*E(i,7)/E(i,6)/E(i,6);
	K(Kidx1, Kidx3) -= 12*E(i,3)*E(i,7)/E(i,6)/E(i,6)/E(i,6);
	K(Kidx1, Kidx4) += 6*E(i,3)*E(i,7)/E(i,6)/E(i,6);
	
	K(Kidx2, Kidx1) += 6*E(i,3)*E(i,7)/E(i,6)/E(i,6);
	K(Kidx2, Kidx2) += 4*E(i,3)*E(i,7)/E(i,6);
	K(Kidx2, Kidx3) -= 6*E(i,3)*E(i,7)/E(i,6)/E(i,6);
	K(Kidx2, Kidx4) += 2*E(i,3)*E(i,7)/E(i,6);
	
	K(Kidx3, Kidx1) -= 12*E(i,3)*E(i,7)/E(i,6)/E(i,6)/E(i,6);
	K(Kidx3, Kidx2) -= 6*E(i,3)*E(i,7)/E(i,6)/E(i,6);
	K(Kidx3, Kidx3) += 12*E(i,3)*E(i,7)/E(i,6)/E(i,6)/E(i,6);
	K(Kidx3, Kidx4) -= 6*E(i,3)*E(i,7)/E(i,6)/E(i,6);
	
	K(Kidx4, Kidx1) += 6*E(i,3)*E(i,7)/E(i,6)/E(i,6);
	K(Kidx4, Kidx2) += 2*E(i,3)*E(i,7)/E(i,6);
	K(Kidx4, Kidx3) -= 6*E(i,3)*E(i,7)/E(i,6)/E(i,6);
	K(Kidx4, Kidx4) += 4*E(i,3)*E(i,7)/E(i,6);
end