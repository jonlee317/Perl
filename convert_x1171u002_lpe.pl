#!/usr/local/bin/perl
# This program is to replace the transistors
# parameterized width & length with real 
# value for LVS purpose.

$netlist="X1171U002_CCW.pex.netlist";

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

  $data=~s/VDDAC/VDDA/ig;
  $data=~s/VSSAC/VSSA/ig;
  $data=~s/VDDC/VDD/ig;
  $data=~s/VSSC/VSS/ig;
  $data=~s/VDDG/VDD/ig;
  $data=~s/VSSG/VSS/ig;
  $data=~s/ ncap_25_lp / nmoscap_25 /ig;
  $data=~s/ INV / INV_IN /ig;
  $data=~s/ NAND2 / NAND2_IN /ig;
  $data=~s/ NAND2LT / NAND2LT_IN /ig;
  $data=~s/ NOR2 / NOR2_IN /ig;
  $data=~s/ NAND3 / NAND3_IN /ig;
  $data=~s/ NOR3 / NOR3_IN /ig;
  $data=~s/ INVLT / INVLT_IN /ig;

  $data=~s/ X1171U002 / X1171U002_LPE /ig;
  $data=~s/ n_25_lp / NH /ig;
  $data=~s/ p_25_lp / PH /ig;
  $data=~s/ n_11_lprvt/ N/ig;
  $data=~s/ p_11_lprvt/ P/ig;
  $data=~s/ n_11_lplvt/ NLT/ig;
  $data=~s/ p_11_lplvt/ PLT/ig;
  $data=~s/ n_11_lphvt/ NHT/ig;
  $data=~s/ p_11_lphvt/ PHT/ig;
  $data=~s/ RNPPO_2T_LP/ RPPOLYWO/ig;  
  $data=~s/ RNNPO_2T_LP/ RNPOLYWO/ig;

  chomp($data);
  print netlist_mod "$data\n";
}
system "del input.cir";
