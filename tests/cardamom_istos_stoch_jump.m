function [ok,data] = test(opt,olddata)
% Regression test for cardamom using ISTOs method and a jump simulation

rng(1)

% Calculate spectrum using cardamom
% -------------------------------------------------------------------------
Sys.Nucs = '14N';

Sys.g = [2.009, 2.006, 2.002];
Sys.A = unitconvert([6, 36]/10,'mT->MHz');
Sys.TransProb = [ 0.2,  0.8;
                 0.55, 0.45 ];
Sys.Orientations = pi*rand(2,3);
Sys.B = 0.34;  % T
Sys.lw = [0.0, 0.1];

Par.dtSpatial = 1e-9;
Par.dtSpin = 1e-9;
Par.nSteps = ceil(150e-9/Par.dtSpin);
Par.nTraj = 50;
Par.Model = 'jump';

Exp.mwFreq = 9.4;

Opt.Verbosity = 0;
Opt.Method = 'ISTOs';

[B,spc] = cardamom(Sys,Exp,Par,Opt);

data.spc = spc;

if ~isempty(olddata)
  ok = areequal(olddata.spc,spc,1e-10,'abs');
else
  ok = [];
end

% Plotting
if opt.Display
  if ~isempty(olddata)
    plot(B,spc,B,olddata.spc);
    legend('new','old');
    axis tight
  end
end
