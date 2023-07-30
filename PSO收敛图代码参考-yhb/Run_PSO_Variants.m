%========================================================================================================================
%% ***** Running Scripts for PSO variants, including following algorithms:
%% ***** 1. Global-PSO with linearly decreasing inertia weight
%% ***** 2. Local-PSO with constriction factor
%% ***** 3. wFIPS with Uring topology
%% ***** 4. DMS-PSO 
%% ***** 5. CLPSO  
%=======================================================================================================================
clear,clc
rng('default');
rng('shuffle');
warning('off');
Particle_Number=30;
Dimension=30;
Max_Gen=3000;
% Max_FES=Particle_Number*Max_Gen;

Max_FES=1000;

% Max_FES=50*d; % 500 for 10d / 1000 for 20d / 1500 for 30d / CEC 2014 expensive

% fname='FITNESS';                                        % Basic Function
% fname='benchmark_func';                                   % 2005 CEC Benchmark Function
% fname = 'eng_pro';                                        % several engineering problems
% fname = 'intersections';                                  % Novel Passive Vibration Isolator Feasibility
% fname='cec14_eotp_problems';                              % 2014 Expensive Benchmark Function
% fname=cec2015.CEC15Problems; func_num = 1; maxfe=50*d;    % 2015 CEC Expensive Benchmark Function

% variable_domain;
funcnum=2;

if funcnum==1 %---Ellipsoid 
    fname='ellipsoid';
    Xmin=-5.12;Xmax=5.12;
    VRmin=-5.12;VRmax=5.12;
elseif funcnum==2 %---Rosenbrock
    fname='rosenbrock';
    Xmin=-2.048;Xmax=2.048;
    VRmin=-2.048;VRmax=2.048;
elseif funcnum==3 %---Ackley 
    fname='ackley';
    Xmin=-32.768;Xmax=32.768;
    VRmin=-32.768;VRmax=32.768;
elseif funcnum==4 %---Griewank
    fname='griewank';
    Xmin=-600;Xmax=600;
    VRmin=-600;VRmax=600;
elseif funcnum==5 %---Rastrigins 
    fname='rastrigin';
    Xmin=-5.12;Xmax=5.12;
    VRmin=-5.12;VRmax=5.12;
elseif funcnum==10 || funcnum==16 || funcnum==19 % CEC 2005 function F10/F16/F19
    fname='benchmark_func';
    Xmin=-5;Xmax=5;
    VRmin=-5;VRmax=5;
end

sn1=2;  gfs=zeros(1,fix(Max_FES/sn1));  CE=zeros(Max_FES,2);    % 采样点设置

time_begin=tic;
runnum=1;

% %For algorithm Complexity
% tStart1 = cputime;
% for i=1:1000000
%     x= 0.55d0+i;
%     x=x+x; 
%     x=x/2;
%     x=x*x; 
%     x=sqrt(x); 
%     x=log(x);
%     x=exp(x); 
%     y=x/(x+2);
% end
% T0 = cputime-tStart1;

for run=1:runnum 
    
    [gbest,gbestval,fitcount,gfs]= PSO_func(fname,Max_Gen,Max_FES,Particle_Number,Dimension,VRmin,VRmax,sn1,gfs,CE);%GPSO
%     [gbest,gbestval,fitcount,gfs]= PSO_cf_local_func(fname,Max_Gen,Max_FES,Particle_Number,Dimension,VRmin,VRmax,sn1,gfs,CE);%LPSO
%     [gbest,gbestval,fitcount,gfs]= wFIPS_func(fname,Max_Gen,Max_FES,Particle_Number,Dimension,VRmin,VRmax,sn1,gfs,CE);%FIPS
%     [gbest,gbestval,fitcount,gfs]= DMS_PSO_func(fname,Max_FES,Dimension,Xmin,Xmax,VRmin,VRmax,sn1,gfs,CE);%DMS-PSO
%     [gbest,gbestval,fitcount,gfs]= CLPSO_new_func(fname,Max_Gen,Max_FES,Particle_Number,Dimension,VRmin,VRmax,sn1,gfs,CE);%CLPSO
    
    fprintf('Runing Number: %d Fitness evaluation:%d Best fitness:%e\n', run,fitcount,gbestval);
 
    gsamp1(run,:)=gfs;
end

best_samp=min(gsamp1(:,end));
worst_samp=max(gsamp1(:,end));
samp_mean=mean(gsamp1(:,end));
samp_median=median(gsamp1(:,end));
std_samp=std(gsamp1(:,end));
out1=[best_samp,worst_samp,samp_median,samp_mean,std_samp];
gsamp1_ave=mean(gsamp1,1);
gsamp1_log=log(gsamp1_ave);

for j=1:Max_FES
    if mod(j,sn1)==0
        j1=j/sn1; gener_samp1(j1)=j;
    end
end

figure(1);
plot(gener_samp1,gsamp1_log,'.-r','Marker','.','Markersize',25,'LineWidth',2)
% semilogy(gener_samp1,gsamp1_ave,'.-r','Marker','.','Markersize',25,'LineWidth',2)
legend('CLPSO');
% xlim([100,maxfe]);
xlabel('Function Evaluation Calls ');
ylabel('Mean Fitness Value (Natural log)');
% % % title('2015 CEC Expensive Benchmark Function')
% % % title('2014 CEC Expensive Benchmark Function (F13)')
% % % title('2005 CEC Benchmark Function (F10)')
% % % title('2005 CEC Benchmark Function (F11)')
% % % title('2005 CEC Benchmark Function (F16)')
% % % title('2005 CEC Benchmark Function (F19)')
% % % title('Ackley Function')
% % % title('Griewank Function')
% % % title('Rastrigin Function')
% % % title('Rosenbrock Function')
% % % title('Ellipsoid Function')
set(gca,'FontSize',20);
time_cost=toc(time_begin);
time_ave=time_cost/runnum;
% time_complexity=time_cost/T0; % Algorithm complexity