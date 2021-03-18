reference
%% NB
%% -1-
% For more details check the paper: Mohamed A.Bahloul and Taous-Meriem Laleg Kirati 
% "Fractional-order model representations of apparent vascular compliance as an alternative in the analysis of arterial stiffness: An in-silico study"
%% -2- Insilico Database
%The in-silico data used in this study, is made available under the Public Domain Dedication and License v1.0
% whose full text can be found at: http://www.opendatacommons.org/licenses/pddl/1.0/.
% https://peterhcharlton.github.io/pwdb/datasets.html
% The database is publicly available at DOI: 10.5281/zenodo.3275625 in Matlab ®, CSV and WaveForm DataBase (WFDB) formats.
% When using this dataset please cite this publication:
% Charlton P.H., Mariscal Harana, J., Vennin, S., Li, Y., Chowienczyk, P. & Alastruey, J., 
% ?Modelling arterial pulse waves in healthy ageing: a database for in silico evaluation of haemodynamics and pulse wave indices,?
% AJP Hear. Circ. Physiol., [in press], 2019.
%%
%%  Main code %%
close all;clear all;
load('pressure_data.mat');
load('flow_data.mat');
load('hr.mat');
v=["Model_A","Model_C","Model_B","Model_D","Model_E","Model_F","Model_G"];%% Models
Model='Model_G';
aa='357'; %% heart rate (cardiac period)
b='25'; %% age
c=243; %% Number of patient per group of age and heart rate
frequency=20;
subjects=1:1:c;
rate=eval(aa)*0.002;
%%
time=linspace(0,eval(aa)*0.002,eval(aa));
Q=eval(genvarname (strcat('q_',b,'_',aa)));
P=eval(genvarname (strcat('p_',b,'_',aa)));

switch Model
    case 'Model_A'
            IC=[1 1];
            lb=[0 0];
            ub=[100 100];
    case 'Model_C'
            IC=[0.1 1 1];
            lb=[0 0 0];
            ub=[100 100 10];
   case 'Model_B'
            IC=[1 1];
            lb=[0 0];
            ub=[100 2];
   case 'Model_E'
            IC=[0 0 0 0];
            lb=[0 0 0 0];
            ub=[1000 1000 1000 2];  
   case 'Model_D'
            IC=[0 0 0];
            lb=[0 0 0];
            ub=[inf inf 2];  
   case 'Model_G'
            IC=[.1 1];
            lb=[0 0];
            ub=[100 100];
   case 'Model_F'
            IC=[1 1 1 1 1 1 1 1 1];
            lb=[0 0 0 0 0 0 0 0 0];
            ub=[inf inf inf inf inf inf inf inf inf];
     otherwise 
           disp ('error')
end
%%
[T_RMSE_model,T_Mean_deviation_model,F,T_Estimated_parameters,C_app,a,T,f,T_modulus,T_phases,Parameters,T_Modulus_model,T_Phase_model,Performance,...
T_Deviation_model,T_Rp]= performance_evaluation(Q,P,time,subjects,frequency,Model,IC,lb,ub);
%%
fprintf ('*Author: Mohamed A. Bahloul\n')
fprintf ('Research group: Estimation, Modeling and Analysis group\n')
fprintf ('Departement: Electrical and Computer Engineering Departement\n')
fprintf ('Universisty: King Abdullah_University of_Science and Technilogy\n')
fprintf ('Reference: For more details please check and cite the paper of Mohamed A.Bahloul and Taous-Meriem Laleg Kirati\n') 
fprintf ('Title: Fractional-order model representations of apparent vascular compliance as an alternative in the analysis of arterial stiffness: An in-silico study\n')
fprintf ('Journal: Physiological Measurement\n')