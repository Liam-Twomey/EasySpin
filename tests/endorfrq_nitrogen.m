function ok = test()

% Check ENDOR frequencies for 14N system

Sys = struct('S',1/2,'g',[2 2 2],...
  'Nucs','14N',...
  'A',[3 4 5],...
  'Q',[-1 2 -1],'QFrame',[0 -pi/4 0]);
Par = struct('Field',350,'SampleFrame',[0 0 0]);

nu0 = [5.378426905685956; 2.379065444270964; 3.567972274126987; 4.135307368869690; 0.567335094742702; 7.757492349956919];
nu = endorfrq(Sys,Par);

ok = areequal(sort(nu),sort(nu0),1e-7,'rel');

