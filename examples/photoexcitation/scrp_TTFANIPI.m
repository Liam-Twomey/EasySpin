% Spin Correlated Radical Pair
%===========================================================
% Singlet-born spin-correlated radical pair generated by
% photoexcitation of the TTF•+-ANI-PI•- triad
% 
% see
%  - Nelson et al, J. Phys. Chem. A 122, 9392–9402 (2018)
%    https://doi.org/10.1021/acs.jpca.8b07556
%

clear; clc; clf;

% Spin system parameters
Sys.S = [1/2 1/2];
Sys.g = [2.01585 2.0069 2.0048;  % tetrathiafulvalene
         2.0060 2.0056 2.0044]; % pyromellitimide
       
Sys.J = 0; % MHz
Sys.dip = 2*mt2mhz(-125e-3); % MHz

Sys.lwpp = 0.38; % mT

% Experimental parameters
Exp.Range = [335 340]; % mT
Exp.mwFreq = 9.5; % GHz
Exp.nPoints = 4096;
Exp.Harmonic = 0;

% Specify singlet-born radical pair
Sys.initState = 'singlet';

[B,spc] = pepper(Sys,Exp);

% Plot result
title('Singlet-born TTF^{•+} - ANI - PI^{•-} radical pair ')
hold on
plot(B,spc,'k')
xlabel('Magnetic Field (mT)')
