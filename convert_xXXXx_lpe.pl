#!/usr/local/bin/perl
# This program is to replace the resistor
# values from the LPE netlist which is a wrong syntax
# 

$netlist="X1211G002_hspice_ccw.pex.netlist";

$new_netlist = $netlist;
$new_netlist =~ s/.netlist/_lpe.netlist/ig;
#----------- open file ---------------
open (netlist_org, "<$netlist") ||
die "Error opening file!";
open (netlist_mod, ">$new_netlist") ||
die "Error opening file!";

#--- Store opened file in an array ----
@data=<netlist_org>;
close netlist_org;

#---------- Processing data  -------------


foreach $data (@data)
{

  $data=~s/ opppcres [0-9]+\.[0-9]+/ opppcres /ig;

  chomp($data);
  print netlist_mod "$data\n";
}
system "del $netlist";
system "cp $new_netlist $netlist";
