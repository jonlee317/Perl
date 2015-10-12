#!/home/s/ap/bin/perl
# This program is to extract parasitic caps
# data from XRC netlist files
#

&get0;
sub get0
{
# Enter Node name here, make sure to leave space at
# begining and  end of the node
$node=" CKP ";
system "cls";

#----------- grep measured data ---------------------------------
#
# ENTER FIRST FILENAME HERE
open(fin, "< X143M001C.pex_CCW1.netlist");
open(fout, "> output.txt") ||
die "Error opening file!";
$total = 0;
$total1 = 0;
$total2 = 0;
print fout "Node name: $node\n\n";
print "Node name: $node\n\n";
@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/$node/i)
        {
	    @line=split(" ",$ext_data);
	    $line[3]=~s/f//ig;
	    print fout "$ext_data";
	    print "$ext_data";
	    $total1 = $total1 + $line[3];

        }
  }
  print fout "\n";
  print fout "total of cc = $total1\n";
  print fout "-----------------------------------------\n\n";
  print "\n";
  print "total of cc = $total1\n";
  print "-----------------------------------------\n\n";
close fin;
close fout;
#
# ENTER 2nd FILE NAME HERE
open(fin, "< X143M001C.pex_CCW1.netlist.X143M001C.pxi");
open(fout, ">> output.txt") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/c_*/)
	  {
	      if ($ext_data=~/$node/i)
	      {
		  @line=split(" ",$ext_data);
		  $line[3]=~s/f//ig;
		  print fout "$ext_data";
		  print "$ext_data";
		  $total2 = $total2 + $line[3];
	      }
	  }
  }
$total = $total1 + $total2;
  print fout "\n";
  print fout "total of c  = $total2\n";
  print fout "-----------------------------------------\n\n";
  print fout "Total parasitic at node $node is $total fF\n";
  print fout "-------------------------------------------------\n\n";
  print "\n";
  print "total of c  = $total2\n";
  print "-----------------------------------------\n\n";
  print "Total parasitic at node $node is $total fF\n";
  print "-------------------------------------------------\n\n";
close fin;
close fout;

}
