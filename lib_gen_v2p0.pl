#!/usr/bin/perl
$next_arg = 0;
$maxcap=0.12;
$area=512109.00;
foreach $arg (@ARGV)
{
    if ($arg eq "-cornername") {$next_arg = "cornername";}
    if ($arg eq "-maxcap") {$next_arg = "maxcap";}
    if ($arg eq "-pinlist") {$next_arg = "pinlist";}
    if ($arg eq "-cornerlist") {$next_arg = "cornerlist";}
    if ($arg eq "-area") {$next_arg = "area";}
    elsif ($next_arg eq "cornername") {$cornername = $arg;}
    elsif ($next_arg eq "maxcap") {$maxcap = $arg;}
    elsif ($next_arg eq "pinlist")  {$pinlist = $arg;}
    elsif ($next_arg eq "cornerlist") {$cornerlist = $arg;}
    elsif ($next_arg eq "area") {$area = $arg;}
}

print "\n";

use Getopt::Long;

if (($#ARGV != 1))
{
    print("Command usage is:\n");
    use Term::ANSIColor;
    print color 'bold blue';
    print("  lib_gen_v0p2\n");
    print("    -cornername   extraction type for example 'CMAX, CMIN, CTYP' \n");
    print("    -pinlist      pinlist for IP  \n");
    print("    -cornerlist   corner list that contains corners, extractions and PVT   \n");
    print("    -area         area of the IP default 520000 \n");
    print("    -maxcap       max cap of the output  \n");
    print("    The directory must contains ' pinlist, cornerlist, extraction netlist for IP for all types, aex file of the testbench and perl file \n");
    print("    netlist should have name toplevel_cell.pex_cornername.netlist e.g 'X144T001C.pex_CCB.netlist' \n");
    print("    Aex file should have extracted data by the same sequence of PVT in cornerlist \n    and name 'projectname'CSI_LIB_SYNC_TOP_TEST_cornername_default.aex e.g 'X144CSI_LIB_SYNC_TOP_TEST_CCW_default.aex' \n");
    print("    \n");
    print color 'reset';
}
#########################################################################################################################################

sub getheader
{
my $param = shift;
my $corner = shift;

#----------- grep measured data ---------------------------------
open(fin3, "< $cornerlist") || die "Error opening file!";
open(fout3, "> temp_perl") || die "Error opening file!";

@ext_data3=<fin3>;
foreach $ext_data3 (@ext_data3)
  {
      if ($ext_data3=~/$param/gi)
        {
          print fout3 "$ext_data3";
        }
  }

close fin3;
close fout3;

#----------- open files ---------------
open(fh3, "<temp_perl") ||
die "Error opening file!";
@tmp3=<fh3>;
$array_size=1;
#---Store opened files in associative array ----
for ($n=0; $n<(1*($corner+1)); $n++)
{
    $spec3{$n}=$tmp3[$n];
}
close fh1;
    $mm=$corner*$array_size;
    for ($a=0; $a<1; $a++)
     {
       @field1a=split(" ",$spec3{0+$mm});
       $datah1=$field1a[0];
       $datah2=$field1a[1];
       $datah3=$field1a[2];
       $datah4=$field1a[3];
       $datah5=$field1a[4];

return ($datah1, $datah2, $datah3, $datah4, $datah5)
     }
close my $fout;
}


####################################################################################################################################

sub getcaps
{
my $fout = shift;
my $param = shift;
my $filename = shift;
my $ext = shift;
if ($ext eq 'CMAX'){$ext='CCW'}
if ($ext eq 'CMIN'){$ext='CCB'}
if ($ext eq 'CTYP'){$ext='CCT'}
#----------- grep measured data ---------------------------------
open(fin2, "< ${filename}C.pex_${ext}.netlist") || die "Error opening file!";
open(fout2, "> temp_perl") || die "Error opening file!";

@ext_data2=<fin2>;
foreach $ext_data2 (@ext_data2)
  {
      if ($ext_data2=~/NET $param/gi)
        {
          print fout2 "$ext_data2";
        }
  }

close fin2;
close fout2;
#----------- open files ---------------
open(fh2, "<temp_perl") ||
die "Error opening file!";
@tmp1=<fh2>;
$corner=1;
$array_size=6;
$array_end=1;
#---Store opened files in associative array ----
for ($k=0; $k<6; $k++)
{
    $spec1{$k}=$tmp1[$k];
}
close fh2;
for ($c=0; $c<$corner; $c++)
{
    $n=$c*$array_size;
    for ($k=0; $k<1; $k++)
     {
       @field11=split(" ",$spec1{0+$n});
       $data11=$field11[2]*1e12;
          printf $fout "   capacitance : $data11\;\n";
   }
}
system "del temp_perl";
}

####################################################################################################################################

sub corners
{ 
my %count;
my $param = shift;
open my $fh, '<', $cornerlist or die "Could not open cornerlist";
while (my $line = <$fh>) {
    chomp $line;
    foreach my $str (split /\s+/, $line) {
        $count{$str}++;
    }
  }
 
foreach my $str (sort keys %count) {
      if ($str=~/$param/gi)
        {
         return ($count{$str});           
        }
    }
}


####################################################################################################################################

sub getdata
{
my $param = shift;
my $filename = shift;
my $corner = shift;
my $ext = shift;

if ($ext eq 'CMAX'){$ext='CCW'}
if ($ext eq 'CMIN'){$ext='CCB'}
if ($ext eq 'CTYP'){$ext='CCT'}

#----------- grep measured data ---------------------------------

open(fin1, "< ${filename}CSI_LIB_SYNC_TOP_TEST_${ext}_default.aex") || die "Error opening file!";
open(fout1, "> temp_perl") || die "Error opening file!";

@ext_data1=<fin1>;
foreach $ext_data1 (@ext_data1)
  {
      if ($ext_data1=~/$param/gi)
        {
          print fout1 "$ext_data1";
        }
  }
foreach $ext_data1 (@ext_data1)
  {
      if ($ext_data1=~/TEMP/gi)
        {
          print fout1 "$ext_data1";
        }
  }

close fin1;
close fout1;
#----------- open files ---------------
open(fh1, "<temp_perl") ||
die "Error opening file!";
@tmp=<fh1>;
$array_size=6;
$array_end=1;
#---Store opened files in associative array ----
for ($i=0; $i<(12*($corner+1)); $i++)
{
    $spec{$i}=$tmp[$i];
}
close fh1;
    $m=$corner*$array_size;
    for ($i=0; $i<2; $i++)
     {
       @field1=split(" ",$spec{0+$m});
       @field2=split(" ",$spec{1+$m});
       @field3=split(" ",$spec{2+$m});
       @field4=split(" ",$spec{3+$m});
       @field5=split(" ",$spec{4+$m});
       @field6=split(" ",$spec{5+$m});
       @field7=split(" ",$spec{6+$m});
       $data1=$field1[2]*1e9;
       $data2=$field2[2]*1e9;
       $data3=$field3[2]*1e9;
       $data4=$field4[2]*1e9;
       $data5=$field5[2]*1e9;
       $data6=$field6[2]*1e9;     
       $data7=$field7[2];
       $temp1=sprintf("%.10g", $data7);
return ($data1, $data2, $data3, $data4, $data5, $data6, $data7);
   }
system "del temp_perl";
}

####################################################################################################################################


sub getpins
{
my $fout = shift;
my $corner = shift;
my $maxcap = shift;

open(fin, "< $pinlist") || die "Error opening file!";
@ext_data=<fin>;
$flag=0;
foreach $ext_data (@ext_data)
{
  last if $flag==1 & $ext_data =~ /========/;
	
  if ($flag == 1) 
  {
     @field=split(/\s+/,$ext_data); 
     $tmp1=$field[0];
     $tmp2=$field[1];
     $tmp3=$field[2];
     $tmp4=$field[3];
     $tmp5=$field[4];
     $tmp6=$field[5];
     $tmp7=$field[6];
     $tmp8=$field[7];
     $tmp9=$field[9];
     my($out1,$out2,$out3,$out4,$out5)=&getheader($cornername,$corner);
     @out1=split(/[_|\.]/,$out1);
     @out11=split(/T/,$out1);
         if ($tmp1 =~ /\:/)
         {
         my($bus_num) = $tmp1 =~ m/(\d+:\d+)/;
         my($first_num) = $bus_num=~ m/(\d+)/;
         $busnum=$first_num+1;
          if (($tmp3 == 0) || ($tmp5 =~ /hold/)){
          $tmp1 =~ s/\[$first_num:0]//g;
          print $fout " bus ($tmp1) {\n";
          print $fout "   bus_type  : bus$busnum\n";
         if ($tmp2 =~ /I$/) 
         { 
         print $fout "   direction : input;  \n";
         if ($tmp8 =~ /\w/){print $fout "   $tmp8 : $tmp9;\n";}

             if (($tmp3 == 1) || ($tmp3 == 2)){
               getcaps($fout,$tmp1,$out1[0],$cornername);
               if ($tmp4 =~ /TRUE/){print $fout "   is_pad : true;\n";}
             }
             else{
               getcaps($fout,$tmp1,$out1[0],$cornername);
               if ($tmp4 =~ /TRUE/){print $fout "   is_pad : true;\n";}
               print $fout "   }\n";
             }

         }

         elsif ($tmp2 =~ /^O/) 
         { 
          print $fout "   direction : output;  \n";
          if ($tmp8 =~ /\w/){print $fout "   $tmp8 : $tmp9;\n";}

             if (($tmp3 == 1) || ($tmp3 == 2)){
              print $fout "   max_capacitance : $maxcap; \n";
             }
             else{
             print $fout "   max_capacitance : $maxcap; \n   }\n";
             }

          if ($tmp4 =~ /TRUE/){print $fout "   is_pad : true;\n";}
         }

         elsif (($tmp2 =~ /PWR/) || ($tmp2 =~ /IO/))          
         {
           print $fout "   direction : inout;  \n";
           if ($tmp8 =~ /\w/){print $fout "   $tmp8 : $tmp9;\n";}
              getcaps($fout,$tmp1,$out1[0],$cornername);
           if ($tmp4 =~ /TRUE/){print $fout "   is_pad : true;\n";}
           print $fout "  }\n";
         }
         else
         {
         last;
         }
         }
         }

         else  
         {
         print $fout " pin($tmp1) { \n";
         if ($tmp2 =~ /I$/) 
         { 
         print $fout "   direction : input;  \n";
         if ($tmp8 =~ /\w/){print $fout "   $tmp8 : $tmp9;\n";}

             if (($tmp3 == 1) || ($tmp3 == 2)){
               getcaps($fout,$tmp1,$out1[0],$cornername);
               if ($tmp4 =~ /TRUE/){print $fout "   is_pad : true;\n";}
             }
             else{
               getcaps($fout,$tmp1,$out1[0],$cornername);
               if ($tmp4 =~ /TRUE/){print $fout "   is_pad : true;\n";}
               print $fout "   }\n";
             }

         }

         elsif ($tmp2 =~ /^O/) 
         { 
          print $fout "   direction : output;  \n";
          if ($tmp8 =~ /\w/){print $fout "   $tmp8 : $tmp9;\n";}

             if (($tmp3 == 1) || ($tmp3 == 2)){
              print $fout "   max_capacitance : $maxcap; \n";
             }
             else{
             print $fout "   max_capacitance : $maxcap; \n   }\n";
             }

          if ($tmp4 =~ /TRUE/){print $fout "   is_pad : true;\n";}
         }

         elsif (($tmp2 =~ /PWR/) || ($tmp2 =~ /IO/))          
         {
           print $fout "   direction : inout;  \n";
           if ($tmp8 =~ /\w/){print $fout "   $tmp8 : $tmp9;\n";}
              getcaps($fout,$tmp1,$out1[0],$cornername);
           if ($tmp4 =~ /TRUE/){print $fout "   is_pad : true;\n";}
           print $fout "  }\n";
         }
         else
         {
         last;
         }
         }
                  

         if (($tmp3 == 1) && ($tmp2 =~ /^O/) && (($tmp5 =~ /rising_edge/) || ($tmp5 =~ /falling_edge/)))
          { 
                if ($tmp1 =~ /\:/)
                 {
                 for ($x=0; $x<$busnum; $x++){
                
                 
                 $num1=$busnum-1;
                    $tmp1 =~ s/\[$num1:0]//g;  
                    print $fout " pin(${tmp1}[${x}]) {\n";
                              $tmp1 =~ s/\[$first_num:0]//g;
                              
         if ($tmp2 =~ /I$/) 
         { 
         print $fout "   direction : input;  \n";
         if ($tmp8 =~ /\w/){print $fout "   $tmp8 : $tmp9;\n";}

             if (($tmp3 == 1) || ($tmp3 == 2)){
               getcaps($fout,$tmp1,$out1[0],$cornername);
               if ($tmp4 =~ /TRUE/){print $fout "   is_pad : true;\n";}
             }
             else{
               getcaps($fout,$tmp1,$out1[0],$cornername);
               if ($tmp4 =~ /TRUE/){print $fout "   is_pad : true;\n";}
               print $fout "   }\n";
             }

         }

         elsif ($tmp2 =~ /^O/) 
         { 
          print $fout "   direction : output;  \n";
          if ($tmp8 =~ /\w/){print $fout "   $tmp8 : $tmp9;\n";}

             if (($tmp3 == 1) || ($tmp3 == 2)){
              print $fout "   max_capacitance : $maxcap; \n";
             }
             else{
             print $fout "   max_capacitance : $maxcap; \n   }\n";
             }

          if ($tmp4 =~ /TRUE/){print $fout "   is_pad : true;\n";}
         }

         elsif (($tmp2 =~ /PWR/) || ($tmp2 =~ /IO/))          
         {
           print $fout "   direction : inout;  \n";
           if ($tmp8 =~ /\w/){print $fout "   $tmp8 : $tmp9;\n";}
              getcaps($fout,$tmp1,$out1[0],$cornername);
           if ($tmp4 =~ /TRUE/){print $fout "   is_pad : true;\n";}
           print $fout "  }\n";
         }
         else
         {
         last;
         }

                    $tmp5=$field[4];
                    print $fout "\n   timing() { \n";
                    print $fout "     related_pin : \"$tmp4\"; \n";
                    print $fout "     timing_type : $tmp5;\n";
                    print $fout "     cell_rise(rx_tmplt_1x6) {\n";

              if ($tmp6 ne NA)
               {               
                print $fout "     timing_sense : $tmp6;\n";
               }
                    my ($data11, $data21, $data31, $data41, $data51, $data61, $data71) =&getdata("${tmp1}${x}_TDR",$out11[0],$corner,$cornername);
                    printf $fout "      values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\"); \n     }\n", $data11, $data21, $data31, $data41, $data51, $data61;
                    print $fout "     rise_transition(rx_tmplt_1x6) {\n";
                    my ($data12, $data22, $data32, $data42, $data52, $data62, $data72) =&getdata("${tmp1}${x}_SLEW_R",$out11[0],$corner,$cornername);
                    printf $fout "      values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\"); \n     }\n", $data12, $data22, $data32, $data42, $data52, $data62;
                    print $fout "     cell_fall(rx_tmplt_1x6) {\n";
                    my ($data13, $data23, $data33, $data43, $data53, $data63, $data73) =&getdata("${tmp1}${x}_TDF",$out11[0],$corner,$cornername);
                    printf $fout "      values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\"); \n     }\n", $data13, $data23, $data33, $data43, $data53, $data63;
                    print $fout "     fall_transition(rx_tmplt_1x6) {\n";
                    my ($data14, $data24, $data34, $data44, $data54, $data64, $data74) =&getdata("${tmp1}${x}_SLEW_F",$out11[0],$corner,$cornername);
                    printf $fout "      values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\"); \n     }\n", $data14, $data24, $data34, $data44, $data54, $data64;
                    print $fout "   }\n  }\n";
                    }
                  }

                  else {
                     $tmp5=$field[4];
                     print $fout "\n   timing() { \n";
                     print $fout "     related_pin : \"$tmp4\"; \n";
                     print $fout "     timing_type : $tmp5;\n";

              if ($tmp6 ne NA)
               {               
                print $fout "     timing_sense : $tmp6;\n";
               }
                    print $fout "     cell_rise(rx_tmplt_1x6) {\n";
                    print $fout "       values(\" 0.1,   0.1,   0.1,   0.1,   0.1,   0.1\");\n     }\n";
                    print $fout "     rise_transition(rx_tmplt_1x6) {\n";
                    my ($data12, $data22, $data32, $data42, $data52, $data62, $data72) =&getdata("${tmp1}_SLEW_R",$out11[0],$corner,$cornername);
                    printf $fout "      values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\"); \n     }\n", $data12, $data22, $data32, $data42, $data52, $data62;
                    print $fout "     cell_fall(rx_tmplt_1x6) {\n";
                    print $fout "       values(\" 0.1,   0.1,   0.1,   0.1,   0.1,   0.1\");\n     }\n";
                    print $fout "     fall_transition(rx_tmplt_1x6) {\n";
                    my ($data14, $data24, $data34, $data44, $data54, $data64, $data74) =&getdata("${tmp1}_SLEW_F",$out11[0],$corner,$cornername);
                    printf $fout "      values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\"); \n     }\n", $data14, $data24, $data34, $data44, $data54, $data64;
                    print $fout "   }\n  }\n";
                   }
          }

         elsif ($tmp3 == 2) 
         {  

            if  (($tmp2 =~ /^O/) && (($tmp5 =~ /rising_edge/) || ($tmp5 =~ /falling_edge/)))   
            {       
         
              if ($tmp5=~ /\//)
              {
               @tmp5=split(/\//,$tmp5);
              }
              for ($j=0; $j<2; $j++)
              {
                    print $fout "\n   timing() { \n";
                    print $fout "     related_pin : \"$tmp4\"; \n";
                    print $fout "     timing_type : $tmp5[$j];\n";
                    print $fout "     timing_sense : $tmp6;\n";
                    print $fout "     cell_rise(rx_tmplt_1x6) {\n";
                    my ($data11, $data21, $data31, $data41, $data51, $data61, $data71) =&getdata("${tmp1}_TDR",$out11[0],$corner,$cornername);
                    printf $fout "      values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\"); \n     }\n", $data11, $data21, $data31, $data41, $data51, $data61;
                    print $fout "     rise_transition(rx_tmplt_1x6) {\n";
                    my ($data12, $data22, $data32, $data42, $data52, $data62, $data72) =&getdata("${tmp1}_SLEW_R",$out11[0],$corner,$cornername);
                    printf $fout "      values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\"); \n     }\n", $data12, $data22, $data32, $data42, $data52, $data62;
                    print $fout "     cell_fall(rx_tmplt_1x6) {\n";
                    my ($data13, $data23, $data33, $data43, $data53, $data63, $data73) =&getdata("${tmp1}_TDF",$out11[0],$corner,$cornername);
                    printf $fout "      values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\"); \n     }\n", $data13, $data23, $data33, $data43, $data53, $data63;
                    print $fout "     fall_transition(rx_tmplt_1x6) {\n";
                    my ($data14, $data24, $data34, $data44, $data54, $data64, $data74) =&getdata("${tmp1}_SLEW_F",$out11[0],$corner,$cornername);
                    printf $fout "      values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\"); \n     }\n", $data14, $data24, $data34, $data44, $data54, $data64;
                    print $fout "   }\n";
              }
                    print $fout "  }\n";
           } 

           elsif (($tmp2 =~ /^I/) && (($tmp5 =~ /setup/) || ($tmp5 =~ /hold/)))
           {
              if ($tmp5=~ /\//)
              {
               @tmp5=split(/\//,$tmp5);
              }
              for ($j=0; $j<2; $j++)
              {
                    print $fout "\n   timing() { \n";
                    print $fout "     related_pin : \"$tmp4\"; \n";
                    print $fout "     timing_type : $tmp5[$j];\n";
                    print $fout "     rise_constraint(scalar) {\n";
                    print $fout "       values(\"0.6\");\n     }\n";
                    print $fout "     fall_constraint(scalar) {\n";
                    print $fout "       values(\"0.6\");\n     }\n";

                    print $fout "   }\n";
              }
                    print $fout "  }\n";
            } 
          }
         else
         {
          print $fout "\n";
         }
close fin;
  }

 $flag=1 if $ext_data =~ /==================/ ;

}
close my $fout;
}

###################################################### Printing the results ###########################################################

my ($num)=&corners($cornername);
$ncorner=$num;
for ($s=0; $s<($ncorner); $s++)
{
my %handle = ();
my($data1a,$data2a,$data3a,$data4a,$data5a)=&getheader($cornername,$s);
@data1a=split(/[_|\.]/,$data1a);
$filename="${data1a[0]}_${data1a[1]}";

open my $RESULT0, ">".$filename.".lib";
$handle{$s} = $RESULT0;

print $RESULT0 '/***********************************************************************************
* MIXEL LIBRARY
* Copyright (c) 2014 Mixel, Inc.  All Rights Reserved.
* CONFIDENTIAL AND PROPRIETARY SOFTWARE/DATA OF MIXEL, INC.';

print $RESULT0 "\n* Technolog   : TSMC 28nm - HPM \n";
print $RESULT0 "* Product Type: Analog IP\n";
print $RESULT0 "* Product Name: $data1a[0]\n";
print $RESULT0 "* Filename    : $data1a\n";
print $RESULT0 "* Version     : 0p4\n";
print $RESULT0 "************************************************************************************/\n\n";

print $RESULT0 "library (${data1a[0]}_${data1a[1]}) { \n";
print $RESULT0 "   technology (cmos) \; \n";
print $RESULT0 "   delay_model : table_lookup \;\n";
print $RESULT0 "    date        : \"Wed. Jun. 04 11:37:02 2014\"\;\n";
print $RESULT0 "    comment     : \"Copyright Mixel, Inc. All Rights Reserved.\" \;\n";
print $RESULT0 "    revision    : 0.0 \;\n";
print $RESULT0 "    simulation   : true \;\n";
print $RESULT0 "    nom_process : 1 \;\n";
print $RESULT0 "    nom_temperature : $data4a\;\n";
print $RESULT0 "    nom_voltage : $data3a\;\n";
print $RESULT0 "    operating_conditions(\"$data1a[1]\"){\n";
print $RESULT0 "        process : 1\;\n";
print $RESULT0 "        temperature : $data4a\;\n";
print $RESULT0 "        voltage : $data3a\;\n";
print $RESULT0 "        tree_type : \"balanced_tree\"\;\n";
print $RESULT0 "    }\n";
print $RESULT0 "    default_operating_conditions : $data1a[1]\;\n";
print $RESULT0 '    capacitive_load_unit (1,pf) ;
    voltage_unit : "1V" ;
    current_unit : "1mA" ;
    time_unit : "1ns" ;
    pulling_resistance_unit : "1kohm";
    leakage_power_unit : "1nW";';
print $RESULT0 "\n\n";

print $RESULT0 '/*----------------------------------------------*/
/* Default Attributes                           */
/*----------------------------------------------*/
    default_inout_pin_cap         : 0.0035;
    default_input_pin_cap         : 0.0035;
    default_output_pin_cap        : 0.0
    default_cell_leakage_power    : 0;
    default_leakage_power_density : 0;
    default_fanout_load	          : 1.0;
    default_max_transition	  : 2.3;

/*----------------------------------------------*/
/* Simulation Condition                         */
/*----------------------------------------------*/
    input_threshold_pct_rise      :  50.00
    output_threshold_pct_rise     :  50.00
    input_threshold_pct_fall      :  50.00
    output_threshold_pct_fall     :  50.00
    slew_derate_from_library      :  1.00
    slew_lower_threshold_pct_rise :  20.00
    slew_upper_threshold_pct_rise :  80.00
    slew_lower_threshold_pct_fall :  20.00
    slew_upper_threshold_pct_fall :  80.00


/*----------------------------------------------*/
/* Please hand edit K factor model !            */
/* Transition K factor                          */
/*----------------------------------------------*/
    k_process_cell_leakage_power	: 0;
    k_temp_cell_leakage_power		: 0;
    k_volt_cell_leakage_power		: 0;
    k_process_internal_power		: 0;
    k_temp_internal_power		: 0;
    k_volt_internal_power		: 0;
    k_process_rise_transition		: 1;
    k_temp_rise_transition		: 0;
    k_volt_rise_transition		: 0;
    k_process_fall_transition		: 1;
    k_temp_fall_transition		: 0;
    k_volt_fall_transition		: 0;
    k_process_setup_rise		: 1;
    k_temp_setup_rise			: 0;
    k_volt_setup_rise			: 0;
    k_process_setup_fall		: 1;
    k_temp_setup_fall			: 0;
    k_volt_setup_fall			: 0;
    k_process_hold_rise			: 1;
    k_temp_hold_rise			: 0;
    k_volt_hold_rise			: 0;
    k_process_hold_fall			: 1;
    k_temp_hold_fall			: 0;
    k_volt_hold_fall			: 0;
    k_process_min_pulse_width_high	: 1;
    k_temp_min_pulse_width_high		: 0;
    k_volt_min_pulse_width_high		: 0;
    k_process_min_pulse_width_low	: 1;
    k_temp_min_pulse_width_low		: 0;
    k_volt_min_pulse_width_low		: 0;
    k_process_recovery_rise		: 1;
    k_temp_recovery_rise		: 0;
    k_volt_recovery_rise		: 0;
    k_process_recovery_fall		: 1;
    k_temp_recovery_fall		: 0;
    k_volt_recovery_fall		: 0;
    k_process_cell_rise			: 1;
    k_temp_cell_rise			: 0;
    k_volt_cell_rise			: 0;
    k_process_cell_fall			: 1;
    k_temp_cell_fall			: 0;
    k_volt_cell_fall			: 0;
    k_process_wire_cap			: 0;
    k_temp_wire_cap			: 0;
    k_volt_wire_cap			: 0;
    k_process_wire_res			: 0;
    k_temp_wire_res			: 0;
    k_volt_wire_res			: 0;
    k_process_pin_cap			: 0;
    k_temp_pin_cap			: 0;
    k_volt_pin_cap			: 0;

/*----------------------------------------------*/
/* Look Up Table                                */
/*----------------------------------------------*/
  lu_table_template(rx_tmplt_1x6) {
    variable_1 : total_output_net_capacitance;
    index_1( " 0.00100, 0.00300, 0.00700, 0.01400, 0.03000, 0.07500");
  }
  lu_table_template(rx1_tmplt_1x6) {
    variable_1 : related_pin_transition;
    index_1( " 0.021, 0.042, 0.084, 0.168, 0.336, 0.672");
  }
/*----------------------------------------------*/
/* Bus Type                                     */
/*----------------------------------------------*/';

print $RESULT0 "\n";

open(input, "< $pinlist") || die "Error opening file!";
@output=<input>;
$flag2=0;
foreach $output (@output)
{
  last if $flag2==1 & $output =~ /========/;
	
  if ($flag2 == 1) 
  {
     @busout=split(/\s+/,$output); 
     $data=$busout[0];

         if ($data =~ /\:/)
         {
         my($b_num) = $data =~ m/(\d+:\d+)/;
         my($bus_fnum) = $b_num=~ m/(\d+)/;
         $busnum=$bus_fnum+1;
         if ($bus_flag ne $busnum){
            print $RESULT0 "type (bus$busnum) {\n";
            print $RESULT0 "  base_type  : array;\n";
            print $RESULT0 "  data_type : bit;\n";
            print $RESULT0 "  bit_width : $busnum;\n";
            print $RESULT0 "  bit_from  : $bus_fnum;\n";
            print $RESULT0 "  bit_to    : 0;\n";
            print $RESULT0 "  downto    : true;\n}\n";
            }
         }
         $bus_flag=$busnum;       
   }
 $flag2=1 if $output =~ /==================/ ;
}

print $RESULT0 '/*----------------------------------------------*/
/* Mixel Library Cell Model                     */
/*----------------------------------------------*/
cell (X141T001) { 
  cell_footprint : X141T001;';
print $RESULT0 "\n";
  
print $RESULT0 "  area : $area;\n";

print $RESULT0 '  dont_use : TRUE;
  dont_touch : TRUE;
  interface_timing : TRUE;
  is_macro_cell : true;
  pad_cell : true;


/********  Generated Output Byte Clock ********/
generated_clock (D0_HS_BYTE_CLKD) {
  clock_pin : D0_HS_BYTE_CLKD ;
  master_pin : CKN ;
  divided_by : 1 ;
}
generated_clock (D1_HS_BYTE_CLKD) {
  clock_pin : D1_HS_BYTE_CLKD ;
  master_pin : CKN ;
  divided_by : 1 ;
}
generated_clock (D2_HS_BYTE_CLKD) {
  clock_pin : D2_HS_BYTE_CLKD ;
  master_pin : CKN ;
  divided_by : 1 ;
}
generated_clock (D3_HS_BYTE_CLKD) {
  clock_pin : D3_HS_BYTE_CLKD ;
  master_pin : CKN ;
  divided_by : 1 ;
}';
  
print $RESULT0 "\n\n";
getpins($RESULT0,$s,$maxcap);
print $RESULT0 "\n  } /* End Of Cell */\n}/* End Library */";
}
map { close $handle{$_} } keys %handle;
close $RESULT0;
system "del temp_perl";
