function [SpringConst] = getSpringConstEPIRM(pdb,eigvalues)
%%%%%%%%%%%%%%%%%%%%need EPIRM attributes in PDBStructure%%%%%%%%%%%%%%
% input:
%   pdb is the structure gotten from cafrompdb with EPIRM attributes.
%	eigvalues is the EPIRM eigenvalues.
% return: spring constant for EPIRM of this input protein.
% Here the spring constant has the unit of kcal/(mol*A^2).
% Editor: Hong Rui
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	atom_num = length(pdb);
	B_factor = zeros(atom_num,1);
	eigvalues = diag(eigvalues);
	eigvectors = getEPIRM(pdb,[1:(atom_num*3-3)]);

	reduced_hessian = eigvectors*inv(eigvalues)*(eigvectors');
	reduced_covariance = 1.38064852*10^(-23)*300*10^(20)*8*pi^(2)/3*reduced_hessian;

	for i = 0:(atom_num-1)
		B_factor(i+1) = sum([reduced_covariance(i*3+1,i*3+1) reduced_covariance(i*3+2,i*3+2) reduced_covariance(i*3+3,i*3+3)]);
	end

	SpringConst = sum([pdb.bval])/sum(B_factor);
	SpringConst = 1/SpringConst;
end