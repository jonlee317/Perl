#!/usr/local/bin/perl

# Rename all the files in the directory specified by the user
# 1) Update the directory information under my $diretory e.g.  C:\Projects
# 2) Under $files_new, change the text "change_from" to the value you want to change from
# 3) Under $files_new, change the the "change_to" to the value you want the files to be changed to
#
# e.g. If you have a list of files with the names:
# super01.txt
# super02.txt
# super03.txt
# super04.txt
# and you want to remove the word super from all of the files
# Set the following line to the following
# $files_new =~ s/super//ig;
# change_from = super
# change_to = "" (essentially nothing)
#
#----------- open directory ---------------

# Set the correct director here:
my $directory = 'C:\Projects';
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

	$files_new =~ s/change_from/change_to/ig;

	rename($files, $files_new) or  
        warn "Couldn't rename $files to $files_new: $!\n";

  	print netlist_mod "$files\n";
}
