#!/usr/local/bin/perl
# This program is to replace the transistors
# parameterized width & length with real 
# value for LVS purpose.

# ------ Enter the name -------
# -----  of your netlist ------

$netlist="x1171pll_rx_testb.cir";

#----------- open file ---------------
open (netlist_org, "<$netlist") ||
die "Error opening file!";
open (netlist_mod, ">output.txt") ||
die "Error opening file!";

#--- Store opened file in an array ----
@data=<netlist_org>;
close netlist_org;

#---------- Processing data  -------------

foreach $data (@data)
{
	if ($data =~ /^M/)
	{
  		$data=~s/^/X/ig;
	}
	
	chomp($data);
	print netlist_mod "$data\n";
}

system "del $netlist";
system "copy output.txt $netlist";
system "del output.txt";