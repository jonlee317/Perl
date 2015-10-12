#!/usr/local/bin/perl
#
# This script simply converts the Y:\ into /mnt/y/
#                and
# it also converts \  into   /
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

	if ($data =~ /Y\:/)
	{
		$data =~ s/Y\:/\/mnt\/y/ig;
		$data =~ s/\\/\//ig;
	}
	

	chomp($data);
	print netlist_mod "$data\n";

}