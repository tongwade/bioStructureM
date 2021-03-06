function [power_coefficient,corr,p_value,effective_time_scale,GNM_eigvalues] = get_GNM_time_regression(PDB_Structure,PCA_to_GNM_mode_mapping,intensity_weighted_period)
%%%%%%%%%%%%%%%%%%%%%%%%%need PDBStructure and mapping information%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	This function is to calculate the regression between GNM eigenvalues and the time scale of each mode.
%	The time scale is extracted from the GNM_to_PCA mode mapping results and its corresponding PCA mode time scale. 
% input:
%   PDB_Structure is the structure gotten from cafrompdb with GNM and GNMValue attributes.
%   PCA_to_GNM_mode_mapping is the mapping information between GNM and PCA modes.
%	intensity_weighted_period is the time scale vector of each PC mode.
% return:
%   power_coefficient: the exponent and the factor in front of regression function.
%	corr: The correlation coefficient of estimated time and the real time scale of GNM modes.
%	p_value: p-value from above calculation.
%	effective_time_scale: real time scale of each GNM mode extracted from intensity_weighted_period.
%	GNM_eigvalues: GNM eigenvalues with real physical units of each mode.
%	The unit of GNM_eigvalues is in (kcal/(mol*angstorm^2)).
%	The unit of effective_time_scale is in picosecond.
%
% Editor: Hong Rui
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[num_of_modes_GNM,~] = size(PCA_to_GNM_mode_mapping);
	[PDB_Structure,GNM_eigvalues] = GNM(PDB_Structure,num_of_modes_GNM);
%	GNM_eigvalues = GNM_eigvalues./(4*pi^(2));
%	GNM_eigvalues = 6.02*10^(23)/4.18/1000/10^(20).*GNM_eigvalues;
	effective_time_scale = zeros(num_of_modes_GNM,1);
	
	for i = 1:num_of_modes_GNM
		effective_time_scale(i) = intensity_weighted_period(PCA_to_GNM_mode_mapping(i,2)).*10^(-3);
	end

	predictor = [ones(num_of_modes_GNM,1) log(GNM_eigvalues)];

	effective_time_scale = log(effective_time_scale);

	power_coefficient = predictor\effective_time_scale;
	power_coefficient(1) = exp(power_coefficient(1));

	effective_time_scale = exp(effective_time_scale);
	estimated_time = power_coefficient(1).*(GNM_eigvalues.^(power_coefficient(2)));
	[corr,p_value] = corrcoef(estimated_time,effective_time_scale);
	corr = corr(1,2);
	p_value = p_value(1,2);
end
