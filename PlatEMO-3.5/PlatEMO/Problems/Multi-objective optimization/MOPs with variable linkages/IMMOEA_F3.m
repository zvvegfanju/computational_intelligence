classdef IMMOEA_F3 < PROBLEM
% <multi> <real> <large/none>
% Benchmark MOP for testing IM-MOEA

%------------------------------- Reference --------------------------------
% R. Cheng, Y. Jin, K. Narukawa, and B. Sendhoff, A multiobjective
% evolutionary algorithm using Gaussian process-based inverse modeling,
% IEEE Transactions on Evolutionary Computation, 2015, 19(6): 838-856.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    methods
        %% Default settings of the problem
        function Setting(obj)
            obj.M = 2;
            if isempty(obj.D); obj.D = 30; end
            obj.lower    = zeros(1,obj.D);
            obj.upper    = ones(1,obj.D);
            obj.encoding = 'real';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,X)
            t = (1+5*repmat(2:obj.D,size(X,1),1)/obj.D).*X(:,2:obj.D) - repmat(X(:,1),1,obj.D-1);
            g = 1 + 9*mean(t.^2,2);
            PopObj(:,1) = 1 - exp(-4*X(:,1)).*sin(6*pi*X(:,1)).^6;
            PopObj(:,2) = g.*(1-(PopObj(:,1)./g).^2);
        end
        %% Generate points on the Pareto front
        function R = GetOptimum(obj,N)
            minf1  = min(1-exp(-4*(0:1e-6:1)).*(sin(6*pi*(0:1e-6:1))).^6);
            R(:,1) = linspace(minf1,1,N)';
            R(:,2) = 1 - R(:,1).^2;
        end
        %% Generate the image of Pareto front
        function R = GetPF(obj)
            R = obj.GetOptimum(100);
        end
    end
end