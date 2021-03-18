function [T_RMSE_model,T_Mean_deviation_model,F,T_Estimated_parameters,C_app,f,Z,frequency_range,T_modulus,T_phases,Parameters,T_Modulus_model,T_Phase_model,Performance,...
    T_Deviation_model,T_Rp]= performance_evaluation(Q,P,time,subjects,frequency,Model,IC,lb,ub)

for i=1:1:length(subjects)
t=0:0.002:time(end);
q=interp1(time,Q(:,subjects(i)),t)';
p=interp1(time,P(:,subjects(i)),t)';
m = length(t);
fs=1/(t(3)-t(2));
f = (0:m-1)*(fs/m);
F=fix(frequency/(f(2)-f(1)))+2;
frequency_range=f(1:F);
%% Frequency Analysis of Real Data
P_f=fft(p);Q_f=fft(q);Z= P_f./Q_f; 
Rp = mean(p)/mean(q); T_Rp(i)=Rp;
C_app=(Rp-Z)./(1i.*2.*pi.*f'.*Rp.*Z);
modulus=abs(C_app); phases=unwrap(angle(C_app)).*180./pi;
T_modulus(:,i)=modulus(1:F); T_phases(:,i)=phases(1:F);
%% Optomization WK2 parameters
   fun= @(w) (sqrt(sum( (((real(WK_MODEL(Model,w,f(2:F))))'-(real(C_app(2:F))))./max(real(C_app(2:F)))).^2 +...
       (((imag(WK_MODEL(Model,w,f(2:F))))'-(imag(C_app(2:F))))./(imag(C_app(2:F)))).^2))/(sqrt(F-1)));
% options=optimoptions(@fmincon,'OptimalityTolerance', 0, ...
%     'StepTolerance', 0, ...
%     'MaxFunctionEvaluations', inf,...
%     'MaxIterations', 100, 'OutputFcn', {@optimplotfval});
[Estimated_parameters,fval] = fmincon (fun,IC,[],[],[],[],lb,ub);%,[],options); 
hold on
T_Estimated_parameters(i,:)=Estimated_parameters;
%% Analysis
T_RMSE_model(i,1)=fval;
T_MSE_model_modulus(i,1)=goodnessOfFit((abs(WK_MODEL(Model,Estimated_parameters,f(2:F))))',modulus(2:F),'MSE'); 
T_NRMSE_model_modulus(i,1)=goodnessOfFit((abs(WK_MODEL(Model,Estimated_parameters,f(2:F))))',modulus(2:F),'NMSE'); 
T_NRMSE_model_phase(i,1)=goodnessOfFit((unwrap(angle(WK_MODEL(Model,Estimated_parameters,f(2:F)))).*180./pi)',phases(2:F),'NMSE'); 
D_model=(abs(((abs(WK_MODEL(Model,Estimated_parameters,f(2:F))))'./modulus(2:F))-1)).*100;
T_Deviation_model(i,:)=D_model;
T_Mean_deviation_model(i,1)=mean(D_model);
%%
T_Modulus_model(:,i)=abs(WK_MODEL(Model,Estimated_parameters,f(1:F)));
T_Phase_model(:,i)=unwrap(angle(WK_MODEL(Model,Estimated_parameters,f(1:F)))).*180./pi;
i
end
Perform=[T_RMSE_model T_NRMSE_model_modulus T_NRMSE_model_phase T_Mean_deviation_model T_MSE_model_modulus];
Performance=array2table(Perform,'VariableNames',{'RMSE','NRMSE_M','NRMSE_P','M_DEV','MSE'});
 switch Model
    case 'Model_A'
        Parameters=array2table(T_Estimated_parameters,'VariableNames',{'C_alpha','alpha'});
    case 'Model_C'
        Parameters=array2table(T_Estimated_parameters,'VariableNames',{'Rd','C_alpha','alpha'});
    case 'Model_B'
        Parameters=array2table(T_Estimated_parameters,'VariableNames',{'C_stat','alpha'});
    case 'Model_E'
        Parameters=array2table(T_Estimated_parameters,'VariableNames',{'C1','C2','C_alpha','alpha'});
    case 'Model_D'
        Parameters=array2table(T_Estimated_parameters,'VariableNames',{'Rd','C','alpha'});
    case 'Model_G'
        Parameters=array2table(T_Estimated_parameters,'VariableNames',{'Rd','C'});     
    case 'Model_F'
        Parameters=array2table(T_Estimated_parameters,'VariableNames',{'a1','b1','a2','b2','a3','b3','a4','b4','C_stat'});
     otherwise 
           disp ('error')
  end
end
