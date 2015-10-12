#! /usr/bin/perl
#######################################################
#     Mixel Confidential                              #
#     Version : 1.0                                   #
#######################################################

# This program is to check pins consistency among different IP views
# LEF, multiple LIB's, SPICE, Verilog 

$progname = "ip_pin_check";

#$rel = $ARGV[0];
#$design = $ARGV[1];
#$ref_file = $ARGV[2];

$next_arg = 0;
foreach $arg (@ARGV)
{
    if ($arg eq "-rel") {$next_arg = "rel";}
    elsif ($arg eq "-top") {$next_arg = "top";}
    elsif ($arg eq "-ref") {$next_arg = "ref";}
    elsif ($arg eq "-views") {$next_arg = "views";}
    elsif ($next_arg eq "rel") {$rel = $arg;}
    elsif ($next_arg eq "top") {$design = $arg;}
    elsif ($next_arg eq "ref") {$ref_file = $arg;}
    elsif ($next_arg eq "views") {$views = uc($arg);}
}


## -----------------------------------------------------------------------------
## Invocation:
##
## ip_pin_check.pl release_directory ip_name
##
## Notes:
##    -rel    RELEASE_DIRECTORY: location where all the views of the ip exist in the release structure format
##    -top    IP_NAME: THE TOP CELL NAME OF THE IP (E.G. X001T001)
##    -ref    REFERENCE_FILE: file with list of IO's of the ip. e.g (D0_HSTXEN INPUT)
##            You can use one of the IP views as your reference e.g. (-ref LEF) or (-ref LIB) or (-ref RTL)
##    -views  VIEWS TO COMPARE: all | lef | lib | spi | rtl
## -----------------------------------------------------------------------------

use Getopt::Long;

if (($#ARGV != 7))
{
    print("Command usage is:\n");
    print("  ip_pin_check.pl\n");
    print("    -rel    RELEASE_DIRECTORY: location where all the views of the ip exist in the release structure format\n");
    print("    -top    IP_NAME: THE TOP CELL NAME OF THE IP (E.G. X001T001)\n");
    print("    -ref    REFERENCE_FILE: file with list of IO's of the ip. e.g (D0_HSTXEN INPUT)   \n");
    print("            You can use one of the IP views as your reference e.g. (-ref LEF) or (-ref LIB) or (-ref RTL)\n");
    print("    -views  VIEWS TO COMPARE: all | lef | lib | spi | rtl \n");
    print("    \n");
    Fatal("Aborting\n");
}

$lefdir   = "$rel/LEF";
$libdir   = "$rel/LIB";
$spidir   = "$rel/CDL";
$rtldir   = "$rel/Verilog";

$dat = `date`;
$pwd = `pwd`;

chop $dat; chop $pwd; 

#---------- Processing lef  -------------
if (($views eq "ALL") || ($views eq "LEF"))
{
open (lef_org, "< $lefdir/${design}.LEF") ||
die "Error opening file! $lefdir/${design}.LEF";
open (lef_mod, ">pin_lef.txt") ||
die "Error opening file! pin_lef.txt";
@lef=<lef_org>;
close lef_org;
foreach $lef (@lef)
{
       if ($lef =~ /\bMACRO\b/)
       {       
	   @hold=split(/\s+/,$lef);
           $top_lef = shift @hold;
           $top_lef = shift @hold;
           if ($top_lef ne $design)
           { 
                print lef_mod "WRONG IP NAME IN VIEW: $top_lef \n";
	        $lef="";
           }
           else 
           {
	        $lef="";
           }
       
       }
       elsif ($lef =~ /\bPIN\b/)
       {
	   @hold=split(" ",$lef);
           $hold[0]=~s/PIN//g;
           $lef=$hold[1]." ";
           $next_line = 1;
       }
       elsif (($next_line == 1) && ($lef =~ /\bDIRECTION\b/i))
       {
	   @pin_direction=split(/\s+/,$lef);
           $lef=$pin_direction[2]."\n";
       }
       else{
	   $lef="";
           $next_line = 0;
       }
      print lef_mod "$lef";
}
close lef_mod;
}


#---------- Processing lib  -------------
if (($views eq "ALL") || ($views eq "LIB"))
{
open (lib_org, "< $libdir/${design}_typ.lib") ||
die "Error opening file! $libdir/${design}_typ.lib";
open (lib_mod, ">pin_lib.txt") ||
die "Error opening file! pin_lib.txt";
@lib=<lib_org>;
close lib_org;
foreach $lib (@lib)
{
       if ($lib =~ /^library/)
       {
	   @hold1=split(/\s+/,$lib);
           $top_lib = shift @hold1;
           $top_lib = shift @hold1;
           $top_lib =~s/\(//g;
           $top_lib =~s/_typ\)//g;
           if ($top_lib ne $design)
           { 
                print lib_mod "WRONG IP NAME IN VIEW: $top_lib \n";
           }
           $lib="";
       
       }
       elsif ($lib =~ /\bpin\b/)
       {
	   @hold1=split(" ",$lib);
           $hold1[0]=~s/pin\(//g;
           $hold1[0]=~s/\)//g;
           $lib=$hold1[0]." ";
           $next_line1 = 1;
       }
      elsif (($next_line1 == 1) && ($lib =~ /\bdirection\b/i))
      {
	   @pin_direction_lib=split(/\s+/,$lib);
           $lib=uc($pin_direction_lib[3])."\n";
           $lib=~s/;//g;
           $next_line1 = 0;
       }
       elsif ($lib =~ /\bbus\b/)
       {
           @hold1=split(" ",$lib);
           $hold1[1]=~s/\(//g;
           $hold1[1]=~s/\)//g;
           $lib1=$hold1[1];
           $lib="";
           $bus = 1;
       }
       elsif ($lib =~ /\bbus_type\b/ )
       {
           @holdbus=split(" ",$lib);
           $holdbus[2]=~s/bus//g;
           $holdbus[2]=~s/;//g;
           $busw= $holdbus[2];
           $next_bus_line = 1; 
           $lib="";
       }
       elsif (($next_bus_line == 1) && ($lib =~ /\bdirection\b/i))
       {
	   @pin_direction_lib=split(/\s+/,$lib);
           $lib=uc($pin_direction_lib[3])."\n";
           $lib=~s/;//g;
           for ($i=0; $i< $busw; $i++)
           {
                $lib2=$lib1."[".$i."]"." $lib";
                print lib_mod "$lib2";
	   }
	   $lib="";
           $busw= 0;
	   $bus = 0;
           $next_line1 = 0;
       }
       else
       {
	   $lib="";
           $next_line1 = 0;
       }
      print lib_mod "$lib";
}
close lib_mod;
}

#---------- Processing SPICE -------------
if (($views eq "ALL") || ($views eq "SPI"))
{
open (spi_org, "< $spidir/${design}.spi") ||
die "Error opening file! $spidir/${design}.spi";
open (spi_mod, ">pin_spi.txt") ||
die "Error opening file! pin_spi.txt";
@spi=<spi_org>;
close spi_org;
foreach $spi (@spi)
{
       if ($spi =~ /.subckt $design/i)
       {
	   $spi =~s/\s+/ /g;
	   $spi =~s/^ //g;
	   @hold2=split(/\s+/,$spi);
           $top_spi = shift @hold2;
           $top_spi = uc(shift @hold2);
           if ($top_spi ne $design)
           { 
                print spi_mod "WRONG IP NAME IN VIEW: $top_spi \n";
                $end_pin_list = 0;
           }
           for ($i=0; $i< $#hold2+1; $i++) 
           {
	        print spi_mod "@hold2[$i]"."\n";
	   } 
            $next_spi_line = 1;
       }
       elsif (($next_spi_line == 1) && ($spi =~ /\+/i))
       {
	   $spi =~s/\s+/ /g;
	   $spi =~s/^ //g;
	   @hold2=split(/\s+/,$spi);
           $dummy = shift @hold2;
           for ($i=0; $i< $#hold2+1; $i++) 
           {
	        print spi_mod "@hold2[$i]"."\n";
	   } 
       }
       else{
	   $spi="";
           $next_spi_line = 0;
       }
}
close spi_mod;
}

#---------- Processing Verilog Model -------------
if (($views eq "ALL") || ($views eq "RTL"))
{
open (rtl_org, "< $rtldir/${design}.v") ||
die "Error opening file! $rtldir/${design}.v";
open (rtl_mod, ">pin_rtl.txt") ||
die "Error opening file! pin_rtl.txt";
@rtl=<rtl_org>;
close rtl_org;
$end_pin_list = 1;
foreach $rtl (@rtl)
{
        if ($rtl =~ /^module/)
       {
	   @hold3=split(/\s+/,$rtl);
           $top_rtl = shift @hold3;
           $top_rtl = shift @hold3;
           $top_rtl =~s/\(//g;
           if (($top_rtl eq $design) && ($rtl_top ne OK))
           { 
                $end_pin_list = 0;
                $rtl_top = OK;
                $top_rtl_ok = $top_rtl;
           }
           $rtl="";
       }
       elsif (($rtl =~ /^input/) && ($end_pin_list == 0))
       {
	   $rtl=~ s/\s+//g;
	   $rtl=~ s/input//g;
	   @hold3=split(/\;/,$rtl);
            if ($hold3[0] =~ /\[/)
            {
                @hold3_tmp=split(/\]/,$rtl);
                $hold3_tmp[0]=~s/\[//g;
                $hold3_tmp[0]=~s/:0//g;
	        @hold3_tmp2=split(/\;/,$hold3_tmp[1]);
                $rtlbusw= $hold3_tmp[0] + 1;
	        $rtlbus = 0;
	       for ($i=0; $i< $rtlbusw; $i++) {
	            $rtl=$hold3_tmp2[0]."[".$i."]"." INPUT"."\n";
	            print rtl_mod "$rtl";
	        }
	        $rtl="";
        
            }
            else
            {
                $hold3[0]=~s/;//g;
                $rtl=$hold3[0]." INPUT"."\n";
	        $rtlbus=0;
            }
       }
       elsif (($rtl =~ /^output/) && ($end_pin_list == 0))
       {
	   $rtl=~ s/\s+//g;
	   $rtl=~ s/output//g;
	   @hold3=split(/\;/,$rtl);
            if ($hold3[0] =~ /\[/)
            {
                @hold3_tmp=split(/\]/,$rtl);
                $hold3_tmp[0]=~s/\[//g;
                $hold3_tmp[0]=~s/:0//g;
	        @hold3_tmp2=split(/\;/,$hold3_tmp[1]);
                $rtlbusw= $hold3_tmp[0] + 1;
	        $rtlbus = 0;
	       for ($i=0; $i< $rtlbusw; $i++) {
	            $rtl=$hold3_tmp2[0]."[".$i."]"." OUTPUT"."\n";
	            print rtl_mod "$rtl";
	        }
	        $rtl="";
        
            }
            else
            {
                $hold3[0]=~s/;//g;
                $rtl=$hold3[0]." OUTPUT"."\n";
	        $rtlbus=0;
            }
       }
       elsif (($rtl =~ /^inout/) && ($end_pin_list == 0))
       {
	   $rtl=~ s/\s+//g;
	   $rtl=~ s/inout//g;
	   @hold3=split(/\;/,$rtl);
            if ($hold3[0] =~ /\[/)
            {
                @hold3_tmp=split(/\]/,$rtl);
                $hold3_tmp[0]=~s/\[//g;
                $hold3_tmp[0]=~s/:0//g;
	        @hold3_tmp2=split(/\;/,$hold3_tmp[1]);
                $rtlbusw= $hold3_tmp[0] + 1;
	        $rtlbus = 0;
	       for ($i=0; $i< $rtlbusw; $i++) {
	            $rtl=$hold3_tmp2[0]."[".$i."]"." INOUT"."\n";
	            print rtl_mod "$rtl";
	        }
	        $rtl="";
        
            }
            else
            {
                $hold3[0]=~s/;//g;
                $rtl=$hold3[0]." INOUT"."\n";
	        $rtlbus=0;
            }
       }
       elsif (($rtl =~ /^endmodule/) && ($end_pin_list == 0))
       {
            $end_pin_list = 1;
	    $rtl="";
       }
       else
       {
	   $rtl="";
       }
      print rtl_mod "$rtl";
}
close rtl_mod;
}

#---------- Identifying the Reference ----------------
      if ($ref_file =~ /lef/i)
      {
        open (ref_pin, "<pin_lef.txt") || die "Error opening LEF file!";
        system "/bin/cp pin_lef.txt ref.txt";
      }
      elsif  ($ref_file =~ /lib/i)
      {
        open (ref_pin, "<pin_lib.txt") || die "Error opening LIB file!";
        system "/bin/cp pin_lib.txt ref.txt";
      }
      elsif  ($ref_file =~ /rtl/i)
      {
        open (ref_pin, "<pin_rtl.txt") || die "Error opening RTL file!";
        system "/bin/cp pin_rtl.txt ref.txt";
      }
      else
      {
        open (ref_pin, "< $ref_file") || die "Error opening REF file!";
      } 
@refpin=<ref_pin>;
close ref_pin;
chomp(@refpin);


#---------- Comparing Pins ----------------
if (($views eq "ALL") || ($views eq "LEF"))
{
open (lef_pin, "<pin_lef.txt") ||
die "Error opening file! pin_lef.txt";
@lefpin=<lef_pin>;
close lef_pin;
chomp(@lefpin);
foreach $lefpin (@lefpin)
{
   $match=0;
    foreach $refpin (@refpin)
    {
	if ($lefpin eq $refpin)
	{
	    $data=$lefpin."\t|\t".$refpin;
	    push @matched, $data;
	    $match=1;
	}
    }
 
    if ($match == 0)
    {
	push @mismatch1, "\n".$lefpin;
    }
}
}


if (($views eq "ALL") || ($views eq "LIB"))
{
open (lib_pin, "<pin_lib.txt") ||
die "Error opening file! pin_lib.txt";
@libpin=<lib_pin>;
close lib_pin;
chomp(@libpin);
foreach $libpin (@libpin)
{
   $match=0;
    foreach $refpin (@refpin)
    {
	if ($libpin eq $refpin)
	{
	    $match=1;
	}
    }
 
    if ($match == 0)
    {
	push @mismatch2, "\n".$libpin;
    }
}
}


if (($views eq "ALL") || ($views eq "SPI"))
{
open (spi_pin, "<pin_spi.txt") ||
die "Error opening file! pin_spi.txt";
@spipin=<spi_pin>;
close spi_pin;
chomp(@spipin);
foreach $spipin (@spipin)
{
   $match=0;
    foreach $refpin (@refpin)
    {
    $refpinspi = $refpin;
    $refpinspi =~ s/ INPUT//g;
    $refpinspi =~ s/ OUTPUT//g;
    $refpinspi =~ s/ INOUT//g;
	if ($spipin eq $refpinspi)
	{
	    $match=1;
	}
    }
 
    if ($match == 0)
    {
	push @mismatch3, "\n".$spipin;
    }
}
}


if (($views eq "ALL") || ($views eq "RTL"))
{
open (rtl_pin, "<pin_rtl.txt") ||
die "Error opening file! pin_rtl.txt";
@rtlpin=<rtl_pin>;
close rtl_pin;
chomp(@rtlpin);

foreach $rtlpin (@rtlpin)
{
   $match=0;
    foreach $refpin (@refpin)
    {
	if ($rtlpin eq $refpin)
	{
	    $match=1;
	}
    }
 
    if ($match == 0)
    {
	push @mismatch4, "\n".$rtlpin;
    }
}
}


$refpins = @refpin;
$lefpins = @lefpin;
$libpins = @libpin;
$spipins = @spipin;
$rtlpins = @rtlpin;
$matchs = @matched;
$mismatchs1 = @mismatch1;
$mismatchs2 = @mismatch2;
$mismatchs3 = @mismatch3;
$mismatchs4 = @mismatch4;

open(RESULT0,">IP_pin_check.rpt") ||
die "Error opening file! IP_pin_check.rpt";
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "- MIXEL LIBRARY \n";
print RESULT0 "- Copyright (c) 2012 Mixel, Inc.  All Rights Reserved \n";
print RESULT0 "- CONFIDENTIAL AND PROPRIETARY SOFTWARE/DATA OF MIXEL, INC.\n";
print RESULT0 "- IP VERIFICATION REPORT \n";
print RESULT0 "- MIXEL IP: $design \n";
print RESULT0 "- DATE: $dat\n";
print RESULT0 "--------------------------------------------------------------------------------\n";
print RESULT0 "- STATEMENT OF USE\n";
print RESULT0 "- This information contains confidential and proprietary information of MIXEL.\n";
print RESULT0 "- No part of this information may be reproduced, transmitted, transcribed,\n";
print RESULT0 "- stored in a retrieval system, or translated into any human or computer\n";
print RESULT0 "- language, in any form or by any means, electronic, mechanical, magnetic,\n";
print RESULT0 "- optical, chemical, manual, or otherwise, without the prior written permission\n";
print RESULT0 "- of MIXEL.  This information was prepared for informational purpose and is for\n";
print RESULT0 "- use by MIXEL's customers only.  MIXEL reserves the right to make changes in the\n";
print RESULT0 "- information at any time and without notice.\n";
print RESULT0 "---------------------------------------------------------------------------------\n";
print RESULT0 "-\t\t  Mixel, Inc.\n";
print RESULT0 "- 97 E. Brokaw Road, Suite 250, San Jose, CA 95112\n";
print RESULT0 "-     Ph.: (408) 436-8500, Fax: (408) 436-8400\n";
print RESULT0 "-\t\t www.mixel.com \n";
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "-\t\t\t Summary\t\t\t    \n";
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "*\t\t\t\t\t\t\t    \n";
print RESULT0 "*\t  Number of Pins as reference \t\t= ".$refpins."\t    \n";
print RESULT0 "*\t  List of reference Pins: \t\t\t    \n";
foreach $refpin (@refpin)
{
print RESULT0 "*\t\t $refpin\n"
}
print RESULT0 "-------------------------------------------------------------\n";
if (($views eq "ALL") || ($views eq "LEF"))
{
print RESULT0 "*\t  Number of LEF Pins \t\t= ".$lefpins."\t\t    *\n";
print RESULT0 "*\t  Number of Unmatched LEF Pins    = ".$mismatchs1."\t\t    *\n";
print RESULT0 "*\t  IP NAME IN LEF VIEW: $top_lef \t\t    *\n";
print RESULT0 "-------------------------------------------------------------\n";
}
if (($views eq "ALL") || ($views eq "LIB"))
{
print RESULT0 "*\t  Number of LIB Pins \t\t= ".$libpins."\t\t    *\n";
print RESULT0 "*\t  Number of Unmatched LIB Pins    = ".$mismatchs2."\t\t    *\n";
print RESULT0 "*\t  IP NAME IN LIB VIEW: $top_lib \t\t    *\n";
print RESULT0 "-------------------------------------------------------------\n";
}
if (($views eq "ALL") || ($views eq "SPI"))
{
print RESULT0 "*\t  Number of SPI Pins \t\t= ".$spipins."\t\t    *\n";
print RESULT0 "*\t  Number of Unmatched SPI Pins    = ".$mismatchs3."\t\t    *\n";
print RESULT0 "*\t  IP NAME IN SPI VIEW: $top_spi \t\t    *\n";
print RESULT0 "-------------------------------------------------------------\n";
}
if (($views eq "ALL") || ($views eq "RTL"))
{
print RESULT0 "*\t  Number of RTL Pins \t\t= ".$rtlpins."\t\t    *\n";
print RESULT0 "*\t  Number of Unmatched RTL Pins    = ".$mismatchs4."\t\t    *\n";
print RESULT0 "*\t  IP NAME IN RTL VIEW: $top_rtl_ok \t\t    *\n";
print RESULT0 "-------------------------------------------------------------\n";
}
print RESULT0 "\n";
print RESULT0 "\n";
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "*\t\t Mismatches between views\t\t    *\n";
print RESULT0 "-------------------------------------------------------------\n";
if ((($views eq "ALL") || ($views eq "LEF")) && $mismatchs1 != "")
{
print RESULT0 "\n\n-------------------------------------------------------------\n";
print RESULT0 "*\t\t     Unmatched LEF Pins\t\t\t    *\n";
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "@mismatch1";
print RESULT0 "\n\n-------------------------------------------------------------\n";
}
if ((($views eq "ALL") || ($views eq "LIB")) && $mismatchs2 != "")
{
print RESULT0 "\n\n-------------------------------------------------------------\n";
print RESULT0 "*\t\t     Unmatched LIB Pins\t\t\t    *\n";
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "@mismatch2";
print RESULT0 "\n\n-------------------------------------------------------------\n";              
}
if ((($views eq "ALL") || ($views eq "SPI")) && $mismatchs3 != "")
{
print RESULT0 "\n\n-------------------------------------------------------------\n";
print RESULT0 "*\t\t     Unmatched SPI Pins\t\t\t    *\n";
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "@mismatch3";
print RESULT0 "\n\n-------------------------------------------------------------\n";
}
if ((($views eq "ALL") || ($views eq "RTL")) && $mismatchs4 != "")
{
print RESULT0 "\n\n-------------------------------------------------------------\n";
print RESULT0 "*\t\t     Unmatched RTL Pins\t\t\t    *\n";
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "@mismatch4";
print RESULT0 "\n\n-------------------------------------------------------------\n";
}
print RESULT0 "\n";
print RESULT0 "\n";
print RESULT0 "\n";
print RESULT0 "-------------------------------------------------------------\n";
print RESULT0 "-\t\t END OF REPORT\t\t    \n";
print RESULT0 "-------------------------------------------------------------\n";
close RESULT0;

print  "-------------------------------------------------------------\n";
print  "*\t\t\t Summary\t\t\t    *\n";
print  "-------------------------------------------------------------\n";
print  "*\t\t\t\t\t\t\t    *\n";
print  "*\t  Number of REF Pins \t\t= ".$refpins."\t\t    *\n";
print  "-------------------------------------------------------------\n";
if (($views eq "ALL") || ($views eq "LEF"))
{
print  "*\t  Number of LEF Pins \t\t= ".$lefpins."\t\t    *\n";
print  "*\t  Number of Unmatched LEF Pins    = ".$mismatchs1."\t\t    *\n";
print  "*\t  IP NAME IN LEF VIEW: $top_lef\t\t    *\n";
print  "-------------------------------------------------------------\n";
}
if (($views eq "ALL") || ($views eq "LIB"))
{
print  "*\t  Number of LIB Pins \t\t= ".$libpins."\t\t    *\n";
print  "*\t  Number of Unmatched LIB Pins    = ".$mismatchs2."\t\t    *\n";
print  "*\t  IP NAME IN LIB VIEW: $top_lib\t\t    *\n";
print  "-------------------------------------------------------------\n";
}
if (($views eq "ALL") || ($views eq "SPI"))
{
print  "*\t  Number of SPI Pins \t\t= ".$spipins."\t\t    *\n";
print  "*\t  Number of Unmatched SPI Pins    = ".$mismatchs3."\t\t    *\n";
print  "*\t  IP NAME IN SPI VIEW: $top_spi\t\t    *\n";
print  "-------------------------------------------------------------\n";
}
if (($views eq "ALL") || ($views eq "RTL"))
{
print  "*\t  Number of RTL Pins \t\t= ".$rtlpins."\t\t    *\n";
print  "*\t  Number of Unmatched RTL Pins    = ".$mismatchs4."\t\t    *\n";
print  "*\t  IP NAME IN RTL VIEW: $top_rtl_ok\t\t    *\n";
print  "-------------------------------------------------------------\n";
}
print  "*\t\t\t\t\t\t\t    *\n";
print  "-------------------------------------------------------------\n";
print  "\nPlease see IP_pin_check.rpt for details\n";

#system "/bin/rm -rf pin_lef.txt";
#system "/bin/rm -rf pin_lib.txt";
#system "/bin/rm -rf pin_spi.txt";
#system "/bin/rm -rf pin_rtl.txt";
