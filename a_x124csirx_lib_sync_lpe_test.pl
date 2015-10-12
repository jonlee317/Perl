#!/home/s/ap/bin/perl
# This program is to extract measured
# data from *hsp.log files by using grep
# function with perl

&get0;
&get1;
&get2;
&get3;
&get4;
&get5;
&get6;
&get7;
&get8;
&get9;
&get10;
&get11;

sub get0
{
#----------- grep measured data ---------------------------------
open(fin, "< x124csirx_lib_sync_lpe_test.lis");
open(fout, "> temp_perl") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/^ *data_tdr/)
        {
          print fout "$ext_data";
        }
  }

close fin;
close fout;

#----------- open files ---------------
open(fh, "<temp_perl") ||
die "Error opening file!";

open(RESULT0,">result_x124csirx_lib_sync_lpe_test.txt") ||
die "Error opening file!";

#---Store opened files in associative array ----
@tmp=<fh>;
$corner=3;
$array_size_x=6; 
$array_size_y=1; 
$array_end=$array_size_y-1;
$array_size=$array_size_x*$array_size_y;
$total=$array_size_x*$array_size_y*3;
for ($i=0; $i<$total; $i++)
{
    $spec{$i}=$tmp[$i];
}
close fh;

#---------- Extract data -------------
print RESULT0 "----------------------------------------\n";
print RESULT0 "TDR (Parallel data to CKN)\n";
print RESULT0 "----------------------------------------\n";

print RESULT0 "\n\n";
for ($c=0; $c<$corner; $c++)
{
    $m=$c*$array_size;
   for ($i=0; $i<$array_size_y; $i++)
    {
     $k=$i*$array_size_x;
     @field1=split(" ",$spec{$k+$m});
     @field2=split(" ",$spec{$k+1+$m});
     @field3=split(" ",$spec{$k+2+$m});
     @field4=split(" ",$spec{$k+3+$m});
     @field5=split(" ",$spec{$k+4+$m});
     @field6=split(" ",$spec{$k+5+$m});
     $data1=$field1[1]*1e9;
     $data2=$field2[1]*1e9;
     $data3=$field3[1]*1e9;
     $data4=$field4[1]*1e9;
     $data5=$field5[1]*1e9;
     $data6=$field6[1]*1e9;
     if ($i==0)
     {
       printf RESULT0 "        values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     elsif ($i==$array_end)
     {
       printf RESULT0 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\");\n\n\n\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     else
     {
       printf RESULT0 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
   }
}

close RESULT0;
system "del temp_perl";

}



sub get1
{
#----------- grep measured data ---------------------------------
open(fin, "< x124csirx_lib_sync_lpe_test.lis");
open(fout, "> temp_perl") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/^ *data_slew_r/)
        {
          print fout "$ext_data";
        }
  }

close fin;
close fout;

#----------- open files ---------------
open(fh, "<temp_perl") ||
die "Error opening file!";

open(RESULT1,">>result_x124csirx_lib_sync_lpe_test.txt") ||
die "Error opening file!";

#---Store opened files in associative array ----
@tmp=<fh>;
$corner=3;
$array_size_x=6; 
$array_size_y=1; 
$array_end=$array_size_y-1;
$array_size=$array_size_x*$array_size_y;
$total=$array_size_x*$array_size_y*3;
for ($i=0; $i<$total; $i++)
{
    $spec{$i}=$tmp[$i];
}
close fh;

#---------- Extract data -------------
print RESULT1 "----------------------------------------\n";
print RESULT1 "Slew Rise (Parallel data to CKN)\n";
print RESULT1 "----------------------------------------\n";

print RESULT1 "\n\n";
for ($c=0; $c<$corner; $c++)
{
    $m=$c*$array_size;
   for ($i=0; $i<$array_size_y; $i++)
    {
     $k=$i*$array_size_x;
     @field1=split(" ",$spec{$k+$m});
     @field2=split(" ",$spec{$k+1+$m});
     @field3=split(" ",$spec{$k+2+$m});
     @field4=split(" ",$spec{$k+3+$m});
     @field5=split(" ",$spec{$k+4+$m});
     @field6=split(" ",$spec{$k+5+$m});
     $data1=$field1[1]*1e9;
     $data2=$field2[1]*1e9;
     $data3=$field3[1]*1e9;
     $data4=$field4[1]*1e9;
     $data5=$field5[1]*1e9;
     $data6=$field6[1]*1e9;
     if ($i==0)
     {
       printf RESULT1 "        values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     elsif ($i==$array_end)
     {
       printf RESULT1 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\");\n\n\n\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     else
     {
       printf RESULT1 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
   }
}

close RESULT1;
system "del temp_perl";

}



sub get2
{
#----------- grep measured data ---------------------------------
open(fin, "< x124csirx_lib_sync_lpe_test.lis");
open(fout, "> temp_perl") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/^ *data_tdf/)
        {
          print fout "$ext_data";
        }
  }

close fin;
close fout;

#----------- open files ---------------
open(fh, "<temp_perl") ||
die "Error opening file!";

open(RESULT2,">>result_x124csirx_lib_sync_lpe_test.txt") ||
die "Error opening file!";

#---Store opened files in associative array ----
@tmp=<fh>;
$corner=3;
$array_size_x=6; 
$array_size_y=1; 
$array_end=$array_size_y-1;
$array_size=$array_size_x*$array_size_y;
$total=$array_size_x*$array_size_y*3;
for ($i=0; $i<$total; $i++)
{
    $spec{$i}=$tmp[$i];
}
close fh;

#---------- Extract data -------------
print RESULT2 "----------------------------------------\n";
print RESULT2 "TDF ((Parallel data to CKN)\n";
print RESULT2 "----------------------------------------\n";

print RESULT2 "\n\n";
for ($c=0; $c<$corner; $c++)
{
    $m=$c*$array_size;
   for ($i=0; $i<$array_size_y; $i++)
    {
     $k=$i*$array_size_x;
     @field1=split(" ",$spec{$k+$m});
     @field2=split(" ",$spec{$k+1+$m});
     @field3=split(" ",$spec{$k+2+$m});
     @field4=split(" ",$spec{$k+3+$m});
     @field5=split(" ",$spec{$k+4+$m});
     @field6=split(" ",$spec{$k+5+$m});
     $data1=$field1[1]*1e9;
     $data2=$field2[1]*1e9;
     $data3=$field3[1]*1e9;
     $data4=$field4[1]*1e9;
     $data5=$field5[1]*1e9;
     $data6=$field6[1]*1e9;
     if ($i==0)
     {
       printf RESULT2 "        values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     elsif ($i==$array_end)
     {
       printf RESULT2 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\");\n\n\n\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     else
     {
       printf RESULT2 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
   }
}

close RESULT2;
system "del temp_perl";

}



sub get3
{
#----------- grep measured data ---------------------------------
open(fin, "< x124csirx_lib_sync_lpe_test.lis");
open(fout, "> temp_perl") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/^ *data_slew_f/)
        {
          print fout "$ext_data";
        }
  }

close fin;
close fout;

#----------- open files ---------------
open(fh, "<temp_perl") ||
die "Error opening file!";

open(RESULT3,">>result_x124csirx_lib_sync_lpe_test.txt") ||
die "Error opening file!";

#---Store opened files in associative array ----
@tmp=<fh>;
$corner=3;
$array_size_x=6; 
$array_size_y=1; 
$array_end=$array_size_y-1;
$array_size=$array_size_x*$array_size_y;
$total=$array_size_x*$array_size_y*3;
for ($i=0; $i<$total; $i++)
{
    $spec{$i}=$tmp[$i];
}
close fh;

#---------- Extract data -------------
print RESULT3 "----------------------------------------\n";
print RESULT3 "Slew Fall (Parallel data to CKN)\n";
print RESULT3 "----------------------------------------\n";

print RESULT3 "\n\n";
for ($c=0; $c<$corner; $c++)
{
    $m=$c*$array_size;
   for ($i=0; $i<$array_size_y; $i++)
    {
     $k=$i*$array_size_x;
     @field1=split(" ",$spec{$k+$m});
     @field2=split(" ",$spec{$k+1+$m});
     @field3=split(" ",$spec{$k+2+$m});
     @field4=split(" ",$spec{$k+3+$m});
     @field5=split(" ",$spec{$k+4+$m});
     @field6=split(" ",$spec{$k+5+$m});
     $data1=$field1[1]*1e9;
     $data2=$field2[1]*1e9;
     $data3=$field3[1]*1e9;
     $data4=$field4[1]*1e9;
     $data5=$field5[1]*1e9;
     $data6=$field6[1]*1e9;
     if ($i==0)
     {
       printf RESULT3 "        values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     elsif ($i==$array_end)
     {
       printf RESULT3 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\");\n\n\n\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     else
     {
       printf RESULT3 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
   }
}

close RESULT3;
#system "del temp_perl";

}

sub get4
{
#----------- grep measured data ---------------------------------
open(fin, "< x124csirx_lib_sync_lpe_test.lis");
open(fout, "> temp_perl") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/^ *byte_clk_tdr/)
        {
          print fout "$ext_data";
        }
  }

close fin;
close fout;

#----------- open files ---------------
open(fh, "<temp_perl") ||
die "Error opening file!";

open(RESULT4,">>result_x124csirx_lib_sync_lpe_test.txt") ||
die "Error opening file!";

#---Store opened files in associative array ----
@tmp=<fh>;
$corner=3;
$array_size_x=6; 
$array_size_y=1; 
$array_end=$array_size_y-1;
$array_size=$array_size_x*$array_size_y;
$total=$array_size_x*$array_size_y*3;
for ($i=0; $i<$total; $i++)
{
    $spec{$i}=$tmp[$i];
}
close fh;

#---------- Extract data -------------
print RESULT4 "\n\n";
print RESULT4 "#################################################################################\n\n";
print RESULT4 "----------------------------------------\n";
print RESULT4 "TDR (D0_HS_BYTE_CLKD to CKN)\n";
print RESULT4 "----------------------------------------\n";

print RESULT4 "\n\n";
for ($c=0; $c<$corner; $c++)
{
    $m=$c*$array_size;
   for ($i=0; $i<$array_size_y; $i++)
    {
     $k=$i*$array_size_x;
     @field1=split(" ",$spec{$k+$m});
     @field2=split(" ",$spec{$k+1+$m});
     @field3=split(" ",$spec{$k+2+$m});
     @field4=split(" ",$spec{$k+3+$m});
     @field5=split(" ",$spec{$k+4+$m});
     @field6=split(" ",$spec{$k+5+$m});
     $data1=$field1[1]*1e9;
     $data2=$field2[1]*1e9;
     $data3=$field3[1]*1e9;
     $data4=$field4[1]*1e9;
     $data5=$field5[1]*1e9;
     $data6=$field6[1]*1e9;
     if ($i==0)
     {
       printf RESULT4 "        values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     elsif ($i==$array_end)
     {
       printf RESULT4 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\");\n\n\n\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     else
     {
       printf RESULT4 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
   }
}

close RESULT4;
system "del temp_perl";

}



sub get5
{
#----------- grep measured data ---------------------------------
open(fin, "< x124csirx_lib_sync_lpe_test.lis");
open(fout, "> temp_perl") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/^ *byte_clk_slew_r/)
        {
          print fout "$ext_data";
        }
  }

close fin;
close fout;

#----------- open files ---------------
open(fh, "<temp_perl") ||
die "Error opening file!";

open(RESULT5,">>result_x124csirx_lib_sync_lpe_test.txt") ||
die "Error opening file!";

#---Store opened files in associative array ----
@tmp=<fh>;
$corner=3;
$array_size_x=6; 
$array_size_y=1; 
$array_end=$array_size_y-1;
$array_size=$array_size_x*$array_size_y;
$total=$array_size_x*$array_size_y*3;
for ($i=0; $i<$total; $i++)
{
    $spec{$i}=$tmp[$i];
}
close fh;

#---------- Extract data -------------
print RESULT5 "----------------------------------------\n";
print RESULT5 "Slew Rise (D0_HS_BYTE_CLKD to CKN)\n";
print RESULT5 "----------------------------------------\n";

print RESULT5 "\n\n";
for ($c=0; $c<$corner; $c++)
{
    $m=$c*$array_size;
   for ($i=0; $i<$array_size_y; $i++)
    {
     $k=$i*$array_size_x;
     @field1=split(" ",$spec{$k+$m});
     @field2=split(" ",$spec{$k+1+$m});
     @field3=split(" ",$spec{$k+2+$m});
     @field4=split(" ",$spec{$k+3+$m});
     @field5=split(" ",$spec{$k+4+$m});
     @field6=split(" ",$spec{$k+5+$m});
     $data1=$field1[1]*1e9;
     $data2=$field2[1]*1e9;
     $data3=$field3[1]*1e9;
     $data4=$field4[1]*1e9;
     $data5=$field5[1]*1e9;
     $data6=$field6[1]*1e9;
     if ($i==0)
     {
       printf RESULT5 "        values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     elsif ($i==$array_end)
     {
       printf RESULT5 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\");\n\n\n\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     else
     {
       printf RESULT5 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
   }
}

close RESULT5;
system "del temp_perl";

}



sub get6
{
#----------- grep measured data ---------------------------------
open(fin, "< x124csirx_lib_sync_lpe_test.lis");
open(fout, "> temp_perl") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/^ *byte_clk_tdf/)
        {
          print fout "$ext_data";
        }
  }

close fin;
close fout;

#----------- open files ---------------
open(fh, "<temp_perl") ||
die "Error opening file!";

open(RESULT6,">>result_x124csirx_lib_sync_lpe_test.txt") ||
die "Error opening file!";

#---Store opened files in associative array ----
@tmp=<fh>;
$corner=3;
$array_size_x=6; 
$array_size_y=1; 
$array_end=$array_size_y-1;
$array_size=$array_size_x*$array_size_y;
$total=$array_size_x*$array_size_y*3;
for ($i=0; $i<$total; $i++)
{
    $spec{$i}=$tmp[$i];
}
close fh;

#---------- Extract data -------------
print RESULT6 "----------------------------------------\n";
print RESULT6 "TDF ((D0_HS_BYTE_CLKD to CKN)\n";
print RESULT6 "----------------------------------------\n";

print RESULT6 "\n\n";
for ($c=0; $c<$corner; $c++)
{
    $m=$c*$array_size;
   for ($i=0; $i<$array_size_y; $i++)
    {
     $k=$i*$array_size_x;
     @field1=split(" ",$spec{$k+$m});
     @field2=split(" ",$spec{$k+1+$m});
     @field3=split(" ",$spec{$k+2+$m});
     @field4=split(" ",$spec{$k+3+$m});
     @field5=split(" ",$spec{$k+4+$m});
     @field6=split(" ",$spec{$k+5+$m});
     $data1=$field1[1]*1e9;
     $data2=$field2[1]*1e9;
     $data3=$field3[1]*1e9;
     $data4=$field4[1]*1e9;
     $data5=$field5[1]*1e9;
     $data6=$field6[1]*1e9;
     if ($i==0)
     {
       printf RESULT6 "        values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     elsif ($i==$array_end)
     {
       printf RESULT6 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\");\n\n\n\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     else
     {
       printf RESULT6 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
   }
}

close RESULT6;
system "del temp_perl";

}



sub get7
{
#----------- grep measured data ---------------------------------
open(fin, "< x124csirx_lib_sync_lpe_test.lis");
open(fout, "> temp_perl") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/^ *byte_clk_slew_f/)
        {
          print fout "$ext_data";
        }
  }

close fin;
close fout;

#----------- open files ---------------
open(fh, "<temp_perl") ||
die "Error opening file!";

open(RESULT7,">>result_x124csirx_lib_sync_lpe_test.txt") ||
die "Error opening file!";

#---Store opened files in associative array ----
@tmp=<fh>;
$corner=3;
$array_size_x=6; 
$array_size_y=1; 
$array_end=$array_size_y-1;
$array_size=$array_size_x*$array_size_y;
$total=$array_size_x*$array_size_y*3;
for ($i=0; $i<$total; $i++)
{
    $spec{$i}=$tmp[$i];
}
close fh;

#---------- Extract data -------------
print RESULT7 "----------------------------------------\n";
print RESULT7 "Slew Fall (D0_HS_BYTE_CLKD to CKN)\n";
print RESULT7 "----------------------------------------\n";

print RESULT7 "\n\n";
for ($c=0; $c<$corner; $c++)
{
    $m=$c*$array_size;
   for ($i=0; $i<$array_size_y; $i++)
    {
     $k=$i*$array_size_x;
     @field1=split(" ",$spec{$k+$m});
     @field2=split(" ",$spec{$k+1+$m});
     @field3=split(" ",$spec{$k+2+$m});
     @field4=split(" ",$spec{$k+3+$m});
     @field5=split(" ",$spec{$k+4+$m});
     @field6=split(" ",$spec{$k+5+$m});
     $data1=$field1[1]*1e9;
     $data2=$field2[1]*1e9;
     $data3=$field3[1]*1e9;
     $data4=$field4[1]*1e9;
     $data5=$field5[1]*1e9;
     $data6=$field6[1]*1e9;
     if ($i==0)
     {
       printf RESULT7 "        values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     elsif ($i==$array_end)
     {
       printf RESULT7 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\");\n\n\n\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     else
     {
       printf RESULT7 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
   }
}

close RESULT7;
#system "del temp_perl";

}

sub get8
{
#----------- grep measured data ---------------------------------
open(fin, "< x124csirx_lib_sync_lpe_test.lis");
open(fout, "> temp_perl") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/^ *sync_tdr/)
        {
          print fout "$ext_data";
        }
  }

close fin;
close fout;

#----------- open files ---------------
open(fh, "<temp_perl") ||
die "Error opening file!";

open(RESULT8,">>result_x124csirx_lib_sync_lpe_test.txt") ||
die "Error opening file!";

#---Store opened files in associative array ----
@tmp=<fh>;
$corner=3;
$array_size_x=6; 
$array_size_y=1; 
$array_end=$array_size_y-1;
$array_size=$array_size_x*$array_size_y;
$total=$array_size_x*$array_size_y*3;
for ($i=0; $i<$total; $i++)
{
    $spec{$i}=$tmp[$i];
}
close fh;

#---------- Extract data -------------
print RESULT8 "\n\n";
print RESULT8 "#################################################################################\n\n";
print RESULT8 "----------------------------------------\n";
print RESULT8 "TDR (SYNC to CKN)\n";
print RESULT8 "----------------------------------------\n";

print RESULT8 "\n\n";
for ($c=0; $c<$corner; $c++)
{
    $m=$c*$array_size;
   for ($i=0; $i<$array_size_y; $i++)
    {
     $k=$i*$array_size_x;
     @field1=split(" ",$spec{$k+$m});
     @field2=split(" ",$spec{$k+1+$m});
     @field3=split(" ",$spec{$k+2+$m});
     @field4=split(" ",$spec{$k+3+$m});
     @field5=split(" ",$spec{$k+4+$m});
     @field6=split(" ",$spec{$k+5+$m});
     $data1=$field1[1]*1e9;
     $data2=$field2[1]*1e9;
     $data3=$field3[1]*1e9;
     $data4=$field4[1]*1e9;
     $data5=$field5[1]*1e9;
     $data6=$field6[1]*1e9;
     if ($i==0)
     {
       printf RESULT8 "        values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     elsif ($i==$array_end)
     {
       printf RESULT8 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\");\n\n\n\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     else
     {
       printf RESULT8 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
   }
}

close RESULT8;
system "del temp_perl";

}



sub get9
{
#----------- grep measured data ---------------------------------
open(fin, "< x124csirx_lib_sync_lpe_test.lis");
open(fout, "> temp_perl") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/^ *sync_slew_r/)
        {
          print fout "$ext_data";
        }
  }

close fin;
close fout;

#----------- open files ---------------
open(fh, "<temp_perl") ||
die "Error opening file!";

open(RESULT9,">>result_x124csirx_lib_sync_lpe_test.txt") ||
die "Error opening file!";

#---Store opened files in associative array ----
@tmp=<fh>;
$corner=3;
$array_size_x=6; 
$array_size_y=1; 
$array_end=$array_size_y-1;
$array_size=$array_size_x*$array_size_y;
$total=$array_size_x*$array_size_y*3;
for ($i=0; $i<$total; $i++)
{
    $spec{$i}=$tmp[$i];
}
close fh;

#---------- Extract data -------------
print RESULT9 "----------------------------------------\n";
print RESULT9 "Slew Rise (SYNC to CKN)\n";
print RESULT9 "----------------------------------------\n";

print RESULT9 "\n\n";
for ($c=0; $c<$corner; $c++)
{
    $m=$c*$array_size;
   for ($i=0; $i<$array_size_y; $i++)
    {
     $k=$i*$array_size_x;
     @field1=split(" ",$spec{$k+$m});
     @field2=split(" ",$spec{$k+1+$m});
     @field3=split(" ",$spec{$k+2+$m});
     @field4=split(" ",$spec{$k+3+$m});
     @field5=split(" ",$spec{$k+4+$m});
     @field6=split(" ",$spec{$k+5+$m});
     $data1=$field1[1]*1e9;
     $data2=$field2[1]*1e9;
     $data3=$field3[1]*1e9;
     $data4=$field4[1]*1e9;
     $data5=$field5[1]*1e9;
     $data6=$field6[1]*1e9;
     if ($i==0)
     {
       printf RESULT9 "        values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     elsif ($i==$array_end)
     {
       printf RESULT9 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\");\n\n\n\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     else
     {
       printf RESULT9 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
   }
}

close RESULT9;
system "del temp_perl";

}



sub get10
{
#----------- grep measured data ---------------------------------
open(fin, "< x124csirx_lib_sync_lpe_test.lis");
open(fout, "> temp_perl") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/^ *sync_deser_en_tdf/)
        {
          print fout "$ext_data";
        }
  }

close fin;
close fout;

#----------- open files ---------------
open(fh, "<temp_perl") ||
die "Error opening file!";

open(RESULT10,">>result_x124csirx_lib_sync_lpe_test.txt") ||
die "Error opening file!";

#---Store opened files in associative array ----
@tmp=<fh>;
$corner=3;
$array_size_x=6; 
$array_size_y=1; 
$array_end=$array_size_y-1;
$array_size=$array_size_x*$array_size_y;
$total=$array_size_x*$array_size_y*3;
for ($i=0; $i<$total; $i++)
{
    $spec{$i}=$tmp[$i];
}
close fh;

#---------- Extract data -------------
print RESULT10 "----------------------------------------\n";
print RESULT10 "TDF (SYNC to HS_DESER_EN)\n";
print RESULT10 "----------------------------------------\n";

print RESULT10 "\n\n";
for ($c=0; $c<$corner; $c++)
{
    $m=$c*$array_size;
   for ($i=0; $i<$array_size_y; $i++)
    {
     $k=$i*$array_size_x;
     @field1=split(" ",$spec{$k+$m});
     @field2=split(" ",$spec{$k+1+$m});
     @field3=split(" ",$spec{$k+2+$m});
     @field4=split(" ",$spec{$k+3+$m});
     @field5=split(" ",$spec{$k+4+$m});
     @field6=split(" ",$spec{$k+5+$m});
     $data1=$field1[1]*1e9;
     $data2=$field2[1]*1e9;
     $data3=$field3[1]*1e9;
     $data4=$field4[1]*1e9;
     $data5=$field5[1]*1e9;
     $data6=$field6[1]*1e9;
     if ($i==0)
     {
       printf RESULT10 "        values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     elsif ($i==$array_end)
     {
       printf RESULT10 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\");\n\n\n\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     else
     {
       printf RESULT10 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
   }
}

close RESULT10;
system "del temp_perl";

}



sub get11
{
#----------- grep measured data ---------------------------------
open(fin, "< x124csirx_lib_sync_lpe_test.lis");
open(fout, "> temp_perl") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/^ *sync_deser_en_slew_f/)
        {
          print fout "$ext_data";
        }
  }

close fin;
close fout;

#----------- open files ---------------
open(fh, "<temp_perl") ||
die "Error opening file!";

open(RESULT11,">>result_x124csirx_lib_sync_lpe_test.txt") ||
die "Error opening file!";

#---Store opened files in associative array ----
@tmp=<fh>;
$corner=3;
$array_size_x=6; 
$array_size_y=1; 
$array_end=$array_size_y-1;
$array_size=$array_size_x*$array_size_y;
$total=$array_size_x*$array_size_y*3;
for ($i=0; $i<$total; $i++)
{
    $spec{$i}=$tmp[$i];
}
close fh;

#---------- Extract data -------------
print RESULT11 "----------------------------------------\n";
print RESULT11 "Slew Fall (SYNC to HS_DESER_EN)\n";
print RESULT11 "----------------------------------------\n";

print RESULT11 "\n\n";
for ($c=0; $c<$corner; $c++)
{
    $m=$c*$array_size;
   for ($i=0; $i<$array_size_y; $i++)
    {
     $k=$i*$array_size_x;
     @field1=split(" ",$spec{$k+$m});
     @field2=split(" ",$spec{$k+1+$m});
     @field3=split(" ",$spec{$k+2+$m});
     @field4=split(" ",$spec{$k+3+$m});
     @field5=split(" ",$spec{$k+4+$m});
     @field6=split(" ",$spec{$k+5+$m});
     $data1=$field1[1]*1e9;
     $data2=$field2[1]*1e9;
     $data3=$field3[1]*1e9;
     $data4=$field4[1]*1e9;
     $data5=$field5[1]*1e9;
     $data6=$field6[1]*1e9;
     if ($i==0)
     {
       printf RESULT11 "        values(\" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     elsif ($i==$array_end)
     {
       printf RESULT11 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\");\n\n\n\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
     else
     {
       printf RESULT11 "               \" %.4f, %8.4f, %8.4f, %8.4f, %8.4f, %8.4f\", \\\n", $data1, $data2, $data3, $data4, $data5, $data6;
     }
   }
}

close RESULT11;
#system "del temp_perl";

}


