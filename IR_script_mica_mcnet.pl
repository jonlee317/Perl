#!/usr/bin/perl
# function with perl

use Getopt::Long;
my $user_inputs = GetOptions (
 	"probe"	    =>		\$probe,
 	"i=s"       =>      \$in_file,
 	"o=s"       =>      \$output_directory,
    "help"      =>      \$help,
	"hspice"    =>      \$hspice,
	"eldo"      =>      \$hspice,
    "supply0=s" =>      \$supply0,
    "supply1=s" =>      \$supply1,
	);
         
if ($help) {
	red("usage ::
		Define the following parameters to the script:
	    -i        Define input netlist file
	    -o        Define output file
	    -supply0  Define the ground net (ex: vss or vssa ....)
	    -supply1  Define the supply net (ex: vdd or vdda ....)
	    -probe    if yes ,generate .probe statements at the output (default no probes)
	    -hspice   if yes ,generate the output file based on hspice netlist (default dspf netlist)
	    -eldo     if yes ,generate the output file based on eldo netlist (default dspf netlist)\n
	    Notes :
	    	1- You Should define t1 and t2 parameters in the simulation file.
	    	2- You Should define the top level cell as XI0
	    	3- Pass the .pxi netlist to the script in case of the input file is hspice or eldo netlist"
	);
	exit;
}


&get0;
&get1;

sub get0 {
	open(fin, "< $in_file");
	open(total, "> $output_directory") || die "Error opening file!";
	###### START #######
	###### Extract VDD #######
	#### hspice or eldo
	if ($hspice) {
		#open(fout, "> temp_perl1") || die "Error opening file!";
		#@ext_data=<fin>;

		#foreach (@ext_data) {
		#	s/ /\n/g;    
	  	#	print fout;
	  	#}

		#close fin;
		#close fout;

	#----------- extract transistors source nodes ---------------
		#open(fin, "< temp_perl1") || die "Error opening file!";
		open(fout, "> vdd_nets.txt") || die "Error opening file!";
		@ext_data=<fin>;

		foreach $ext_data (@ext_data) {
			my @mos = split(' ', $ext_data);
		    if ((($mos[5]=~m/psvtlp/) || ($mos[5]=~m/nsvtlp/)) && (($mos[3]=~m/${supply1}/i))) {
		    	print fout "$mos[3]\n";
		    	#print fout "$ext_data";
		    }
		}

		close fin;
		close fout;
	#### END hspice and eldo
	} else {
		####DSPF
		###### Remove the new lines #######
		open(fout, "> temp_perl") || die "Error opening file!";
		open(spi_mod, "> temp_perl99") || die "Error opening file!";

		@spi=<fin>;
		close fin;
		foreach $spi (@spi) {
			if (($spi =~ /rvdd/i) || ($spi =~ /rvss/i)) {
				@hold2=split(/\s+/,$spi);
			    for ($i=0; $i< $#hold2+1; $i++) {
				    print spi_mod "@hold2[$i]"." ";
				} 
			    $next_spi_line = 1;           
			}
			elsif (($next_spi_line == 1) && ($spi =~ /\+/i)) {
				@hold2=split(/\s+/,$spi);
			    $dummy = shift @hold2;
			    for ($i=0; $i< $#hold2+1; $i++) {
			        print spi_mod "@hold2[$i]"." @hold2[$i+1]"." \n";
			    } 
			} else {
				$spi="";
			    $next_spi_line = 0;
			    }
		}

		open(fin, "< temp_perl99");
		open(spi_mod2, "> temp_perl100") || die "Error opening file!"; 
		@spi2=<fin>;
		                 
		foreach $spi2 (@spi2) {
			$spi2=~ s/ rvdd/\nrvdd/gi;
			$spi2=~ s/ rvss/\nrvss/gi;       
			print spi_mod2 "$spi2" unless ($spi2 =~/^\d/) ;
		}
		###### Extract VDD #######

		open(fin, "< temp_perl100");
		@ext_data=<fin>;

		foreach $ext_data (@ext_data) {
		    if (($ext_data=~/^ *r${supply1}\//i) && ($ext_data=~ m/\:s/)) {      
		        print fout "$ext_data";
		    }                   
		}

		close fin;
		close fout;

		#----------- extract transistors source nodes ---------------
		open(fin2, "<temp_perl") || die "Error opening file!";
		open(f2out, "> vdd_nets.txt") || die "Error opening file!";

		while(<fin2>) {

			@field1=split(/ /);

			if (($field1[1]=~ m/\:s/)) {
				$data=$field1[1];
			} else {
				$data=$field1[2];
			}
			print f2out "$data\n";
		}

		close fin2;
		close f2out;
	}
	### END DSPF

	#----------- Adding probe file ---------------
	open(fin3, "<vdd_nets.txt") || die "Error opening file!";
	open(f3out, "> vdd_probe.spi") || die "Error opening file!";

	@source_nodes=<fin3>;
	foreach (@source_nodes) {
		s/^/.probe tran V\(xI0./gi;
		s/$/\)/i;
		print f3out;
	} 
	close f3out;
	 
	#----------- Adding Peak meas file ---------------
	open(fin4, "<vdd_nets.txt") || die "Error opening file!";
	open(f4out, "> vdd_peak_meas.spi") || die "Error opening file!";

	@source_nodes=<fin4>;
	foreach (@source_nodes) {
		@field2=split();
		$data2=@field2[0];

		s/^/meas ${supply1}_peak_${data2} min V\(xI0./gi;    
		s/$/\) from=t1 to=t2 >> \$measfile /i;
		print f4out;
	}
	close fin4;
	close f4out;

	#----------- Adding RMS meas file ---------------
	open(fin5, "<vdd_nets.txt") || die "Error opening file!";
	open(f5out, "> vdd_rms_meas.spi") || die "Error opening file!";

	@source_nodes=<fin5>;
	foreach (@source_nodes) {
		@field2=split();
		$data2=@field2[0];

		s/^/meas ${supply1}_rms_${data2} rms V\(xI0./gi;
		s/$/\) from=t1 to=t2 >> \$measfile /i;
		print f5out;
	}  
	close f5out;


	###### Extract VSS #######

	#----------- grep supply resistors ---------------------------------

	#### hspice or eldo
	if ($hspice){
		open(fin, "< $in_file") || die "Error opening file!";
		#open(fin, "< temp_perl1") || die "Error opening file!";
		open(fout, "> vss_nets.txt") || die "Error opening file!";
		@ext_data=<fin>;

		foreach $ext_data (@ext_data) {
			my @mos = split(' ', $ext_data);
		    if ((($mos[5]=~m/psvtlp/) || ($mos[5]=~m/nsvtlp/)) && (($mos[3]=~m/${supply0}/i))) {
		    	print fout "$mos[3]\n";
		    	#print fout "$ext_data";
		    }
		}

		#foreach $ext_data (@ext_data) {   
		#	if (($ext_data=~/^ *N_${supply0}_/i) && ($ext_data=~ m/_s/)) {
		#        print fout "$ext_data";
		#    }
		#}
		  
		close fin;
		close fout;
		#### END hspice and eldo
	} else {
	#### DSPF
		open(fout, "> temp_perl") || die "Error opening file!";
		  
		foreach $ext_data (@ext_data) {
			if (($ext_data=~/^ *r${supply0}\//i) && ($ext_data=~ m/\:s/)) {
		        print fout "$ext_data";
		    }
		}

		close fin;
		close fout;

		#----------- extract transistors source nodes ---------------
		open(fin2, "<temp_perl") || die "Error opening file!";
		open(f2out, "> vss_nets.txt") || die "Error opening file!";

		while(<fin2>) {
			@field1=split(/ /);

			if (($field1[1]=~ m/\:s/)) {
				$data=$field1[1];
			} else {
				$data=$field1[2];
			}

			print f2out "$data\n";
		}

		close fin2;
		close f2out;
	}
	#### END DSPF

	#----------- Adding probe file ---------------
	open(fin3, "<vss_nets.txt") || die "Error opening file!";
	open(f3out, "> vss_probe.spi") || die "Error opening file!";

	@source_nodes=<fin3>;
	foreach (@source_nodes) {
		s/^/.probe tran V\(xI0./gi;
		s/$/\)/i;
		print f3out;
	}

	close f3out;  
	#----------- Adding Peak meas file ---------------
	open(fin4, "<vss_nets.txt") || die "Error opening file!";
	open(f4out, "> vss_peak_meas.spi") || die "Error opening file!";

	@source_nodes=<fin4>;
	foreach (@source_nodes) {
		@field2=split();
		$data2=@field2[0];

		s/^/meas ${supply0}_peak_${data2} max V\(xI0./gi;
		s/$/\) from=t1 to=t2 >> \$measfile /i;
		print f4out;
	}  
	close f4out;

	#----------- Adding RMS meas file ---------------
	open(fin5, "<vss_nets.txt") || die "Error opening file!";
	open(f5out, "> vss_rms_meas.spi") || die "Error opening file!";

	@source_nodes=<fin5>;
	foreach (@source_nodes) {
		@field2=split();
		$data2=@field2[0];
	 
		s/^/meas ${supply0}_rms_${data2} rms V\(xI0./gi;
		s/$/\) from=t1 to=t2 >> \$measfile /i;
		print f5out;
	}
	close f5out; 
	#system "del temp_perl";
}



sub get1 {

############ Including all files in one file #################

	open(FILE1, "vdd_probe.spi" ) || die("Cannot Open File1");
	open(FILE2, "vdd_peak_meas.spi" ) || die("Cannot Open File2");
	open(FILE3, "vdd_rms_meas.spi" ) || die("Cannot Open File3");
	open(FILE4, "vss_probe.spi" ) || die("Cannot Open File4");
	open(FILE5, "vss_peak_meas.spi" ) || die("Cannot Open File5");
	open(FILE6, "vss_rms_meas.spi" ) || die("Cannot Open File6");


	my @files;
	my $delimiter = "*****\n";
	my $meas_supply="meas ${supply1}_supply_val find V(xI0.${supply1}) at=t1 >> \$measfile\n";
	my $mica_intro = "\n\n\.control\n\nset measureformat\=list\nset measfile \= ${supply1}\.out\n\necho \" ***** PVT point \$point\" >> \$measfile\n\n";

	push(@files, $mica_intro);

	if ($probe) {
		push(@files,$delimiter,$meas_supply,$delimiter,<FILE6>,$delimiter,<FILE5>,$delimiter,<FILE4>,$delimiter,<FILE3>,$delimiter,<FILE2>,$delimiter,<FILE1>);
	} else {
		push(@files,$delimiter,$meas_supply,$delimiter,<FILE6>,$delimiter,<FILE5>,$delimiter,<FILE3>,$delimiter,<FILE2>);
	}

	push(@files, "\n\n\.endc");
	#push(@files,$delimiter,<FILE6>,$delimiter,<FILE5>,$delimiter,<FILE4>,$delimiter,<FILE3>,$delimiter,<FILE2>,$delimiter,<FILE1>);

	close (FILE1);
	close (FILE2);
	close (FILE3);
	close (FILE4);
	close (FILE5);
	close (FILE6);

	foreach(@files) {
		print total;
	}
	close total;

	@filelist = ("temp_perl", "vdd_probe.spi","vdd_peak_meas.spi","vdd_rms_meas.spi","vss_probe.spi","vss_peak_meas.spi","vss_rms_meas.spi","temp_perl99","temp_perl100","vss_nets.txt"); #removed temp_perl1 and vdd_nets.txt
	#@filelist = ("temp_perl","temp_perl1","vdd_probe.spi","vdd_peak_meas.spi","vdd_rms_meas.spi","vss_probe.spi","vss_peak_meas.spi","vss_rms_meas.spi","temp_perl99","temp_perl100","vdd_nets.txt","vss_nets.txt");
	unlink @filelist;

	green("Done");
	red("Note 1 : You Should define t1 and t2 parameters in the simulation file.");
	red("Note 2 : You Should define the top level cell as XI0 .");

	sub red {
		my $text = shift;
		print  "\e[0;31m$text\e[0m\n";
	}

	sub green {
		my $text = shift;
		print  "\e[0;32m$text\e[0m\n";
	}
}

