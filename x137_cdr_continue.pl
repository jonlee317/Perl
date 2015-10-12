#!/usr/local/bin/perl



#----------- open file ---------------
open (netlist_org, "<x1371mrx_cdr_hsg2a_test_20u.cir") ||
die "Error opening file!";

open (netlist_mod, ">output.cir") ||
die "Error opening file!";


#--- Store opened file in an array ----
@data=<netlist_org>;
close netlist_org;


#---------- Processing data  -------------


foreach $data (@data)
{
	
	$data=~s/ 0 0 1NS 0 1.2NS 'VDDL' / 0 'VDDL' 1NS 'VDDL' 1.2NS 'VDDL' /ig;
	$data=~s/ 0 'VDDL' 1NS 'VDDL' 1.2NS 0 / 0 0 1NS 0 1.2NS 0 /ig;

	chomp($data);
	print netlist_mod "$data\n";

}