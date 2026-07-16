function easyspin_compile_octave()

% Determine directory containing mex source files
%-------------------------------------------------------------------------------
%a = mfilename("fullpath")
%fprintf('0: %s\n',a)
esPrivateFolder = fileparts(mfilename("fullpath"));
%fprintf(esPrivateFolder)
%fprintf('1: %s\n',which(a))
%fprintf('1: %s\n',fileparts(a))
%esPrivateFolder = esPath;
octDirectory = esPrivateFolder;
disp(['  directory: ' octDirectory]);
disp(['  version: ' version]);

% Change directory
olddir = pwd;
cd(octDirectory);
fprintf('in dir: %s',pwd)

% Determine mex configuration
%-------------------------------------------------------------------------------
cc = mkoctfile('-p','CC');
if numel(cc)==0
  error('No C compiler is available. Please install one or make sure it is available on $PATH');
else
  fprintf('  oct C compiler: %s\n',cc); 
end

% Get list of *.c files
%-------------------------------------------------------------------------------
SourceFiles = dir('*.c');
nFiles = numel(SourceFiles);

% Compile and link mex files
%-------------------------------------------------------------------------------
if nFiles==0
	error('No C files found to compile.')
else 
	fprintf('  compiling %d c-files...\n',nFiles);
end

for f = 1:nFiles
  fprintf('  (%d/%d) %-25s ',f,nFiles,SourceFiles(f).name);
  try
	mkoctfile(char(SourceFiles(f).name));
    fprintf('  complete\n');
    ok(f) = true;
  catch
    fprintf('  failed\n');
    disp(lasterr);
	disp("Please make sure that a C compiler such as gcc and the development headers for Octave are installed. Depending on you system, this may be called `octave-devel` or `octave-dev`. Please consult your package manager.")
    ok(f) = false;  %#ok
  end
end

cd(olddir);

% A hack that was needed at the EasySpin workshop at Cornell 2007, no idea why.
% it works. Needed when the C compiler for mex files was not configured.
clear functions
