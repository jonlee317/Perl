#!/usr/local/bin/perl



#----------- open file ---------------
open (netlist_org, "<input.cir") ||
die "Error opening file!";

open (netlist_mod, ">output.cir") ||
die "Error opening file!";


#--- Store opened file in an array ----
@data=<netlist_org>;
close netlist_org;


#---------- Processing data  -------------


foreach $data (@data)
{

	$data=~s/\./\//ig;

	$data=~s/\/ic/\.ic/ig;
	$data=~s/v\(xi0\//v\(xi0\./ig;

	$data=~s/\)\=1\//\)\=1\./ig;
	$data=~s/\)\=2\//\)\=2\./ig;
	$data=~s/\)\=3\//\)\=3\./ig;
	$data=~s/\)\=4\//\)\=4\./ig;
	$data=~s/\)\=5\//\)\=5\./ig;
	$data=~s/\)\=6\//\)\=6\./ig;
	$data=~s/\)\=7\//\)\=7\./ig;
	$data=~s/\)\=8\//\)\=8\./ig;
	$data=~s/\)\=9\//\)\=9\./ig;
	$data=~s/\)\=0\//\)\=0\./ig;


	chomp($data);
	print netlist_mod "$data\n";

}