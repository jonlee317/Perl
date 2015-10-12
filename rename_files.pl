#!/usr/local/bin/perl



#----------- open directory ---------------

### set the correct director here:
my $directory = 'Y:\Projects\X145\Design\sym';

opendir(DIR, $directory) or die "couldn't open $directory: $!\n";

#-------- open files text --------------
open (netlist_mod, ">files.txt") ||
die "Error opening file!";


#--- Store opened file in an array ----
my @files= readdir DIR;
closedir DIR;

#---------- Processing data  -------------


foreach $files (@files)
{
	$files_new = $files;

	### depending what project number you want to change, do it here.
	$files_new =~ s/x122/x145/ig;

	rename($files, $files_new) or  
        warn "Couldn't rename $files to $files_new: $!\n";

  	print netlist_mod "$files\n";
}