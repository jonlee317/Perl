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

$flag_next=0;

foreach $data (@data)
{
	if ($flag_next == 1)
	{
		my @section = split(' ', $data);
		$section[1] = "";
		$data = join(" ", @section);
		$flag_next =0;
	}

	if ($data =~/ opppcres /)
	{

		my @section = split(' ', $data);
		$count = @section;

		if ($section[4]=~/opppcres/)
		{
			$section[5] = "";
			$data = join(" ", @section);
		}

		if ($section[1]=~/opppcres/)
		{
			$section[2] = "";
			$data = join(" ", @section);
		}


	}

	if ($data =~/ opppcres/)
	{
		my @section = split(' ', $data);
		$count = @section;
		
		if ($count == 5)
		{
			if ($section[4]=~/opppcres/)
			{
				$flag_next=1;
			}
		}
	}

  	chomp($data);
  	print netlist_mod "$data\n";
}