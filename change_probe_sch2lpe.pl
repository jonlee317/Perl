#!/usr/local/bin/perl
# How to quickly change a schematic probing to lpe probing


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

	#First change every . to a /
	$data=~s/\./\//ig;

	#now we change the ones we don't want to be a / back to a .
	$data=~s/\/probe/\.probe/ig;

	$data=~s/v\(xi0\//v\(xi0\./ig;
	$data=~s/i\(xi0\//i\(xi0\./ig;
	$data=~s/p\(xi0\//p\(xi0\./ig;

	#now we print the new line 
	chomp($data);
	print netlist_mod "$data\n";

}