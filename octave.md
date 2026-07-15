
# EasySpin in Octave

## Differences between MATLAB and Octave

GNU [Octave](octave.org) provides a free and open source alternative to MATLAB,
which implements the MATLAB syntax. However, it implements an older version of
the MATLAB syntax, and not all MATLAB commands are implemented yet. Generally,
there are equivalent functions available, but it requires a bit of tweaking.
The resulting code is still able to run in MATLAB, but sometimes is a
suboptimal or deprecated approach.

Some important parts of EasySpin utilize functions which are not implemented in Octave:
|Function | Location | Octave equivalent | Notes| 
|---------|----------|-------------------|------|
|`table`   | isotopes | ?                 | |
|`mustBeFile(<filename>)`   | matlab-functions| `assert(exist(<filename>,"file")==2, <msg>)`                 | |
|`mustBeTextScalarElement(<string>)`   | matlab-functions | `assert(ischar(<string>),<msg>)`                 | | 


## Path additions

To add the easyspin folder to Path in Octave, `Edit -> Set Path -> Add` and select
`EasySpin/easyspin`, equivalently to MATLAB. When files in the path change, it
does not appear to actually reload file contents. As far as I can tell, Octave
has to be closed and reopened to reflect changes to files in the path.

## C-accelerated functions

The prebuilt `.oct` C binaries are included in the git repo for x86_64 devices.
If on a machine with a different architecture, recompiling these binaries will
be necessary. Install all packages needed for C compilation and octave
development. On Fedora linux, this is `sudo dnf install octave octave-devel 
octave-general gcc redhat-rpm-config`; this will vary based on your OS and
distribution.

To recompile the binaries for your architecture, go to `EasySpin/easyspin/private`
and use `ls *.c` to show all the C-accelerated functions. This C code is compiled differently based on its use: the various `.mex*` files are MATLAB files for each architecture, and the `.oct` files are files compiled for Octave.
If necessary libraries and headers are installed,
running `mkoctfile <file>.c` should compile correctly, outputting only warnings
and no errors, and generating a `<file>.oct` file. If this works, then you are
done.

## Debugging the LaTeX renderer

The Latex renderer is kinda buggy, and appears to default to an empty string.  
For normal usage, add the following to `.octaverc`:  
```
setenv("OCTAVE_LATEX_BINARY","latex")
setenv("OCTAVE_DVISVG_BINARY","dvisvgm")
setenv("OCTAVE_DVIPNG_BINARY","dvipng")
```
...where `<NAME>` is the executable command. On *NIX systems, this can be found 
with `which latex` (it is generally just `latex`). To check the environment
variable values, use `getenv()`.

The packages I had to install for texlive are: `texlive-standalone texlive-media4svg`

If there is any issue with the latex renderer (for instance when trying to render
Latex in a plot title or axis label), the initial error message is
`warning: latex_renderer: a runtime test has failed and the 'latex' interpreter
has been disabled.` This generally means that there is a dependency which is
unmet by your latex installation. Run `setenv("OCTAVE_LATEX_DEBUG_FLAG","1")`
in the octave command line to enable latex debugging. This will print the full
Latex debug info. Lines prefixed with `!` are the ones you want to pay attention
to.


Note that for some reason, only single-quoted strings get passed correctly to
the tex and latex interpreters, due to some
[idiosyncracy](https://stackoverflow.com/questions/46247629/using-latex-in-legends-and-labels-of-plots)
of Octave.

For more information, see: [documentation](https://docs.octave.org/latest/_0022latex_0022-interpreter.html),
[forum](https://stackoverflow.com/questions/79963361/latex-interpreter-in-octave-fails-a-run-time-test-again).
