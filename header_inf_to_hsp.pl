#!/usr/local/bin/perl
#
# This script simply converts the /mnt/y to y:\
#                and
# it also converts /  into   \
#
#----------- open file ---------------
open (netlist_org, "<input.txt") ||
die "Error opening file!";

open (netlist_mod, ">output.txt") ||
die "Error opening file!";


#--- Store opened file in an array ----
@data=<netlist_org>;
close netlist_org;


#---------- Processing data  -------------


foreach $data (@data)
{	

	if ($data =~ /\/mnt\/y\//)
	{
		$data =~ s/\/mnt\/y/Y\:/ig;
		$data =~ s/\//\\/ig;
	}
	


	chomp($data);
	print netlist_mod "$data\n";

}