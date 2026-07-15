function ok = test(opt)

% Test gn values of common isotopes

Isotopes = {'1H','2H','13C','14N','15N','33S','59Co','63Cu'};

gn = [5.585694702, 0.857438231, 1.404738, 0.403573, -0.5661138, 0.428833, 1.3186, 1.48246];

for k = 1:numel(Isotopes)
  ngn(k) = nucgval(Isotopes{k});
end

if opt.Display
  ngn-gn
end

ok = areequal(ngn,gn,1e-5,'rel');
