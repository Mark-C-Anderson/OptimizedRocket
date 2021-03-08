function [xopt, fopt, exitflag, output] = runOptimization2()

    % -------- starting point and bounds ----------
    downrangeDistance = 10e3; % meters
    xPoints = 20;
    dx = downrangeDistance/xPoints;
    x0 = 0:dx:(downrangeDistance-dx);
    
    targetY = 42e3; % meters
    deltaY = targetY / length(x0); % meters
    y = 0:deltaY:targetY - deltaY;
    
    % Making all of the x-inputs be of a similar order
    x0 = log(x0(2:end)); % Removing the first zero
    
    lb = zeros(1,length(x0));
    ub = [];
    
    
    % ---------------------------------------------

    % ------ linear constraints ----------------
    % We won't be doing this for the truss example. Leave these as empty
    % arrays
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    % ------------------------------------------
    
    % Counting the number of function calls
    global funcCount
    funcCount = 0;

    % ---- Objective and Constraints -------------
    function [f, g, h, df, dg, dh] = objcon(x)

        x = exp(x);
        
        % set objective/constraints here
        % f: objective
        % g: inequality constraints
        % h: equality constraints
        % d*: derivatives of * (see fmincon docs for index ordering)
        
        % Derivative Method
        method = 'Complex-Step';
        
        % Interpretation
        % f: the objective value
        f = trajectory(x);
        f = f.usedMass / 1e4;
        
        % g: inequality constraints
        constraints = trajectoryInequalityCon(x);
        g = constraints.inequalityConstraints;
        g = [];
        
        % h: equality constraints, see first homework. There are none for
        % this homework
        % h = constraints.equalityConstraints;
        constraints = trajectoryEqualityCon(x);
        h = constraints.equalityConstraints ./ 1;
        h = [];
        
        % df: simple derivative
        J = getJacobian(@trajectory,x,...
                        'Method',method);
                    
        df = J(1).output;           
        
        % dg: Jacobian of g.
        J = getJacobian(@trajectoryInequalityCon,x,...
                        'Method',method);
        dg = J(1).output;
        dg = [];
        
        % dh: Jacobian of h
        J = getJacobian(@trajectoryEqualityCon,x,...
                        'Method',method);
        dh = J(1).output;
        dh = [];

    end
    % -------------------------------------------

    % ----------- options ----------------------------
    options = optimoptions('fmincon', ...
        'Algorithm', 'active-set', ...  % choose one of: 'interior-point', 'sqp', 'active-set', 'trust-region-reflective'
        'HonorBounds', true, ...  % forces optimizer to always satisfy bounds at each iteration
        'Display', 'iter-detailed', ...  % display more information
        'MaxIterations', 1000, ...  % maximum number of iterations
        'MaxFunctionEvaluations', 10000, ...  % maximum number of function calls
        'OptimalityTolerance', 1e-6, ...  % convergence tolerance on first order optimality
        'ConstraintTolerance', 1e-6, ...  % convergence tolerance on constraints
        'FiniteDifferenceType', 'central', ...  % if finite differencing, can also use central
        'SpecifyObjectiveGradient', true, ...  % supply gradients of objective
        'SpecifyConstraintGradient', true, ...  % supply gradients of constraints
        'CheckGradients', false, ...  % true if you want to check your supplied gradients against finite differencing
        'Diagnostics', 'on',... % display diagnotic information
        'OutputFcn',@outfun);
    % -------------------------------------------
    
    opt = [];
    funcCallCount = [];
    
    % Creating an output function
    function stop = outfun(x,optimValues,state)
        opt = [opt;optimValues.firstorderopt];
        if ~isempty(optimValues.firstorderopt)
            funcCallCount = [funcCallCount;funcCount];
        end
        stop = false; % you can set your own stopping criteria
        
        downrangeValues = [0,exp(x)];
        
        plot(downrangeValues/1000,y./1000)
        title("Trajectory")
        xlabel("X (km)")
        ylabel("Y (km)")
        %axis equal
        %xlim([0,downrangeValues(end)/1000])
        drawnow()
        
    end


    % -- NOTE: no need to change anything below) --
    % see: https://www.mathworks.com/help/optim/ug/objective-and-nonlinear-constraints-in-the-same-function.html
    

    % ------- shared variables -----------
    xlast = [];  % last design variables
    flast = [];  % last objective
    glast = [];  % last nonlinear inequality constraint
    hlast = [];  % last nonlinear equality constraint
    dflast = [];  % last derivatives
    dglast = [];
    dhlast = [];
    % --------------------------------------


    % ------ separate obj/con  --------
    function [f, df] = obj(x)

        % check if computation is necessary
        if ~isequal(x, xlast)
            [flast, glast, hlast, dflast, dglast, dhlast] = objcon(x);
            xlast = x;
        end

        f = flast;
        df = dflast;
    end

    function [g, h, dg, dh] = con(x)

        % check if computation is necessary
        if ~isequal(x, xlast)
            [flast, glast, hlast, dflast, dglast, dhlast] = objcon(x);
            xlast = x;
        end

        % set constraints
        g = glast;
        h = hlast;
        dg = dglast;
        dh = dhlast;
    end
    % ------------------------------------------------

    % call fmincon
    [xopt, fopt, exitflag, output] = fmincon(@obj, x0, A, b, Aeq, beq, lb, ub, @con, options);

    output.opt = opt;
    output.funcCallCount = funcCallCount;
    
%     figure()
%     plot(exp(xopt)./1000,y./1000)
%     title("Trajectory")
%     xlabel("X (km)")
%     ylabel("Y (km)")
    
end
