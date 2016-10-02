#!/usr/local/bin/perl

# This script will check a log file and find the particular chosen mos in the array below.
# It will create a file called saturation.txt displaying the mosfets operating region according
# to the log file *.lis

$file_name = 'hspicefile.lis';
$fileout_name = 'saturation.txt';

open($fin, '<', $file_name)
	or die "Couldn't open $file_name!";
@data = <$fin>;
close($fin);

open($fout, '>', $fileout_name)
	or die "Couldn't open $fileout_name";

@chosen = ( 

    "m20a", 
    "m21a",
    "m22a", 
    "m23a",
    "m20b", 
    "m21b",
    "m22b", 
    "m23b",
    "m24a", 
    "m24b",
    "m25a",
    "m25b",
    );

foreach $chosen (@chosen) {
	$flag=0;
	print $fout "\n--------------------------------------------------------------\n";


	@first_index = grep { ($data[$_] =~ /subckt/) && ($data[$_] =~ /$chosen/) } 0..$#data;

	foreach $index (@first_index) {
		print "$index\n";
		#print "$data[$index]\n";
		$count = 0;
		while ($count < 12) {
			push @fun_stuff, $data[$index+$count];
			$count = $count + 1;
			#print $count;
		}
	}

	foreach $fun (@fun_stuff) {
		@fun_split = split (/\s+/, $fun);
		push @big_array, [ @fun_split ];
	}
	print $big_array[1][0];

        print $fout "\n$big_array[0][1]\t\t$biga_rray[1][1]\t$big_array[3][1]\t\t$big_array[4][1]\t\t$big_array[5][1]\t\t$big_array[6][1]\t\t$big_array[7][1]\t\t$big_array[8][1]\t\t$big_array[9][1]\t\t$big_array[10][1]\t\t$big_array[11][1]\t\t\n";

        $count = 0;
	for $i ( 0 .. $#big_array ) {
		for $j ( 0 .. $#{$big_array[$i]} ) {
			#print "This is $i and this is $j\n";
			#print "$big_array[$i][$j]\n";
			if ($big_array[$i][$j] =~ /$chosen/ && $flag==0) {
    			print $fout "\n";
                            if ($big_array[$i+3][$j] =~ /Saturati/i) {
                            	print $fout "$big_array[$i][$j]\t$big_array[$i+1][$j]\t$big_array[$i+3][$j]\t$big_array[$i+4][$j]\t$big_array[$i+5][$j]\t$big_array[$i+6][$j]\t$big_array[$i+7][$j]\t$big_array[$i+8][$j]\t$big_array[$i+9][$j]\t$big_array[$i+10][$j]\t$big_array[$i+11][$j]\t\t";
                            } else {
                            	print $fout "$big_array[$i][$j]\t$big_array[$i+1][$j]\t$big_array[$i+3][$j]\t\t$big_array[$i+4][$j]\t$big_array[$i+5][$j]\t$big_array[$i+6][$j]\t$big_array[$i+7][$j]\t$big_array[$i+8][$j]\t$big_array[$i+9][$j]\t$big_array[$i+10][$j]\t$big_array[$i+11][$j]\t\t";
                            }
                            $count = $count + 1;
                            if ($count == 10) {
                            	$flag =1;
                            }
                                
			}

		}
	}
}


close($fout);
