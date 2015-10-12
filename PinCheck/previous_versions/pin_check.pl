#!/usr/local/bin/perl
# This program is to check pins from LEF
# and LIB files 


#----------- open file ------------------
print "\nEnter LEF file name?\t";
chomp($input_lef = <STDIN>);
print "Enter LIB file name?\t";
chomp($input_lib = <STDIN>);
print "\nLEF file is $input_lef\n";
print "LIB file is $input_lib\n\n";
print "Press Enter to Continue\n";
$input_anykey = <STDIN>;

open (lef_org, "<$input_lef") ||
die "Error opening file!";
open (lib_org, "<$input_lib") ||
die "Error opening file!";

open (lef_mod, ">pin_lef.txt") ||
die "Error opening file!";
open (lib_mod, ">pin_lib.txt") ||
die "Error opening file!";

#--- Store opened file in an array ------
@lef=<lef_org>;
close lef_org;
@lib=<lib_org>;
close lib_org;

#---------- Processing lef  -------------

foreach $lef (@lef)
{
       if ($lef =~ /\bPIN\b/)
       {
	   @hold=split(" ",$lef);
           $hold[0]=~s/PIN//g;
           $lef=$hold[1]."\n";
       }
       else{
	   $lef="";
       }
      print lef_mod "$lef";
}

#---------- Processing lib  -------------
foreach $lib (@lib)
{
       if ($lib =~ /\bpin\b/)
       {
	   @hold1=split(" ",$lib);
           $hold1[0]=~s/pin\(//g;
           $hold1[0]=~s/\)//g;
           $lib=$hold1[0]."\n";
       }
      elsif ($lib =~ /\bbus\b/)
       {
	   @hold1=split(" ",$lib);
           $hold1[1]=~s/\(//g;
           $hold1[1]=~s/\)//g;
           $lib1=$hold1[1];
	   $lib="";
	   $bus=1;
       }
       elsif ($bus == 1 )
       {
	   @hold1=split(" ",$lib);
           $hold1[2]=~s/bus//g;
           $hold1[2]=~s/;//g;
           $busw= $hold1[2];
	   $bus = 0;
	   for ($i=0; $i< $busw; $i++)
	   {
	       $lib=$lib1."[".$i."]\n";
	       print lib_mod "$lib";
	   }
	   $lib="";
       }
       else{
	   $lib="";
       }
      print lib_mod "$lib";
}

close lef_mod;
close lib_mod;

#---------- Comparing Pins ----------------

open (lef_pin, "<pin_lef.txt") ||
die "Error opening file!";
open (lib_pin, "<pin_lib.txt") ||
die "Error opening file!";


@lefpin=<lef_pin>;
close lef_pin;
@libpin=<lib_pin>;
close lib_pin;

chomp(@lefpin);
chomp(@libpin);


foreach $lefpin (@lefpin)
{
   $match=0;
    foreach $libpin (@libpin)
    {
	if ($lefpin eq $libpin)
	{
	    $data=$lefpin."\t|\t".$libpin;
	    push @matched, $data;
	    $match=1;
	}
    }
 
    if ($match == 0)
    {
	push @mismatch1, "\n".$lefpin;
    }
}

foreach $libpin (@libpin)
{
   $match=0;
    foreach $lefpin (@lefpin)
    {
	if ($libpin eq $lefpin)
	{
	    $match=1;
	}
    }
 
    if ($match == 0)
    {
	push @mismatch2, "\n".$libpin;
    }
}

$lefpins = @lefpin;
$libpins = @libpin;
$matchs = @matched;
$mismatchs1 = @mismatch1;
$mismatchs2 = @mismatch2;

open(RESULT0,">result_pin_check.txt") ||
die "Error opening file!";
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "*\t\t\t Summary\t\t\t    *\n";
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "*\t\t\t\t\t\t\t    *\n";
print RESULT0 "*\t  Number of LEF Pins \t\t= ".$lefpins."\t\t    *\n";
print RESULT0 "*\t  Number of LIB Pins \t\t= ".$libpins."\t\t    *\n";
print RESULT0 "*\t  Number of Matched Pins \t= ".$matchs."\t\t    *\n";
print RESULT0 "*\t  Number of Unmatched LEF Pins    = ".$mismatchs1."\t\t    *\n";
print RESULT0 "*\t  Number of Unmatched LIB Pins    = ".$mismatchs2."\t\t    *\n";
print RESULT0 "*\t\t\t\t\t\t\t    *\n";
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "\n\n-------------------------------------------------------------\n";
print RESULT0 "*\t\t\tMatched Pins\t\t\t    *\n";
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "LEF                          |                LIB\n";
print RESULT0 "                             |\n";

format RESULT0 =
@<<<<<<<<<<<<<<<<<           @<<              @<<<<<<<<<<<<<<<<<
$leff,                       $tt,             $libb,
.

foreach $matched (@matched)
{
    chomp;
    ($leff, $tt, $libb)=split(" ",$matched);
    write RESULT0;
}  
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "\n\n-------------------------------------------------------------\n";
print RESULT0 "*\t\t     Unmatched LEF Pins\t\t\t    *\n";
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "@mismatch1";
print RESULT0 "\n-------------------------------------------------------------\n";
print RESULT0 "\n\n-------------------------------------------------------------\n";
print RESULT0 "*\t\t     Unmatched LIB Pins\t\t\t    *\n";
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "@mismatch2";
print RESULT0 "\n-------------------------------------------------------------\n";              
close RESULT0;

print  "-------------------------------------------------------------\n";
print  "*\t\t\t Summary\t\t\t    *\n";
print  "-------------------------------------------------------------\n";
print  "*\t\t\t\t\t\t\t    *\n";
print  "*\t  Number of LEF Pins \t\t= ".$lefpins."\t\t    *\n";
print  "*\t  Number of LIB Pins \t\t= ".$libpins."\t\t    *\n";
print  "*\t  Number of Matched Pins \t= ".$matchs."\t\t    *\n";
print  "*\t  Number of Unmatched LEF Pins    = ".$mismatchs1."\t\t    *\n";
print  "*\t  Number of Unmatched LIB Pins    = ".$mismatchs2."\t\t    *\n";
print  "*\t\t\t\t\t\t\t    *\n";
print  "-------------------------------------------------------------\n";
print  "\nPlease see result_pin_check.txt for details\n";

system "del pin_lef.txt";
system "del pin_lib.txt";
