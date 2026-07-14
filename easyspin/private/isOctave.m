function r = isOctave()
	% Check if EasySpin is being run in Octave. If it is, this function will return
	% 5 (which is truthy) else it will return 0, which is not. Used for dealing with
	% differences in MATLAB and Octave syntax.
	persistent x;
	if (isempty(x))
		x = exist('OCTAVE_VERSION','builtin');
	end 
	r = x;
end
