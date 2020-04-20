function [gX,info] = esfit_swarm(funfcn,nParameters,FitOpt,varargin)

if ~isfield(FitOpt,'maxTime'), FitOpt.maxTime = inf; end
if ~isfield(FitOpt,'PrintLevel'); FitOpt.PrintLevel = 1; end
if ~isfield(FitOpt,'TolFun'), FitOpt.TolFun = 1e-5; end
if ~isfield(FitOpt,'IterationPrintFunction') || ...
  isempty(FitOpt.IterationPrintFunction), FitOpt.IterationPrintFunction = @(str)0; end
if ~isfield(FitOpt,'nParticles'); FitOpt.nParticles = 30; end
if ~isfield(FitOpt,'SwarmParams'), FitOpt.SwarmParams = [0.2 0.5 2 1]; end

global UserCommand
if isempty(UserCommand), UserCommand = NaN; end

nParticles = FitOpt.nParticles;

if FitOpt.PrintLevel
  fprintf('Particle swarm size %d.\n',nParticles);
end

k = FitOpt.SwarmParams(1); % velocity clamping
w = FitOpt.SwarmParams(2); % inertial coefficient
c1 = FitOpt.SwarmParams(3); % cognitive coefficient
c2 = FitOpt.SwarmParams(4); % social coefficient

if FitOpt.PrintLevel
  fprintf('Particle swarm parameters:  k = %g, w = %g, c1 = %g, c2 = %g.\n',k,w,c1,c2);
end

X = 2*rand(nParameters,nParticles) - 1;
bestX = X;
gX = bestX(:,1);
v = (2*rand(nParameters,nParticles)-1)*k;
besterror = inf(1,nParticles);
thiserror = inf(1,nParticles);
globalbesterror = inf;
startTime = cputime;

if FitOpt.PrintLevel
  FitOpt.IterationPrintFunction('initial iteration');
end

iIteration = 1;
stopCode = 0;
while stopCode==0
  
  iIteration = iIteration + 1;
  
  % Evaluate objective functions for all particles
  for p = 1:nParticles
    if UserCommand==1, stopCode = 2; break; end
    thiserror(p) = funfcn(X(:,p),varargin{:});
  end
  
  % Update best fit so far for each particle
  for p = 1:nParticles
    if thiserror(p)<besterror(p)
      besterror(p) = thiserror(p);
      bestX(:,p) = X(:,p);
    end
  end
  
  % Find overall best fit so far
  [~,idx] = min(thiserror);
  if thiserror(idx)<globalbesterror
    globalbesterror = thiserror(idx);
    gX = X(:,idx);
  end
  
  % Move all particles
  for p = 1:nParticles
    v(:,p) = w*v(:,p) + c1*rand*(bestX(:,p)-X(:,p)) + c2*rand*(gX-X(:,p));
    X(:,p) = X(:,p) + v(:,p);
    X(:,p) = min(max(X(:,p),-1),+1); % constrain to [-1 +1]
  end
  
  if FitOpt.PrintLevel
    str = sprintf('  Iteration %4d:   error %0.5e  best so far',iIteration,globalbesterror);
    FitOpt.IterationPrintFunction(str);
  end
  
  elapsedTime = (cputime-startTime)/60;
  if elapsedTime>FitOpt.maxTime, stopCode = 1; end
  if UserCommand==1, stopCode = 2; end
  if globalbesterror<FitOpt.TolFun, stopCode = 3; end
  
end

if FitOpt.PrintLevel>1
  switch stopCode
    case 1, msg = sprintf('Terminated: Time limit of %f minutes reached.',FitOpt.maxTime);
    case 2, msg = 'Terminated: Stopped by user.';
    case 3, msg = sprintf('Terminated: Found a parameter set with error less than %g.',FitOpt.TolFun);
  end
  disp(msg);
end

return
