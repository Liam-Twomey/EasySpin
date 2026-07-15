function easyspin_compile()

% Determine directory containing mex source files
%-------------------------------------------------------------------------------
esPath = fileparts(which(mfilename));
esPrivateFolder = esPath;
octDirectory = esPrivateFolder;
disp(['  directory: ' octDirectory]);
disp(['  version: ' version]);

% Change directory
olddir = pwd;
cd(octDirectory);

% Determine mex configuration
%-------------------------------------------------------------------------------
fprintf("The C compiler available to mkoctfile is:")
cc = mkoctfile -p CC
if numel(cc)==0
  error('MEX is not configured for C. Run mex -setup C.');
else
  fprintf('  oct C compiler: %s\n',cc(1).Name); 
end


% Get list of *.c files
%-------------------------------------------------------------------------------
SourceFiles = dir('*.c');
nFiles = numel(SourceFiles);


% Compile and link mex files
%-------------------------------------------------------------------------------
fprintf('  compiling %d c-files...\n',nFiles);
fprintf('  compiling %d c-files...\n',nFiles);
for f = 1:nFiles
  fprintf('  (%d/%d) %-25s ',f,nFiles,SourceFiles(f).name);
  try
	mkoctfile SourceFiles(f).name;
    fprintf('  complete\n');
    ok(f) = true;
  catch
    fprintf('  failed\n');
    disp(lasterr);
	disp("Please make sure that a C compiler such as gcc and the development headers ...
		for Octave are installed. Depending on you system, this may be called `octave-devel` ...
		or `octave-dev`. Please consult your package manager.")
    ok(f) = false;  %#ok
  end
end

cd(olddir);

% A hack that was needed at the EasySpin workshop at Cornell 2007, no idea why.
% it works. Needed when the C compiler for mex files was not configured.
clear functions
