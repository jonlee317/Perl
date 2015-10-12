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
$comment_out = 0;



foreach $data (@data)
{
	if ($comment_out == 1)
	{
		$data =~ s/^/\*/ig;
		$comment_out = 0;
	}

	if ($data =~/ PARASITIC_NWD /)
	{
		$data =~ s/^/\*/ig;

		my @section = split(' ', $data);
		my $count = @section;

		if ($count < 7)
		{
			$comment_out =1;
		}

	}

  	chomp($data);
  	print netlist_mod "$data\n";
}