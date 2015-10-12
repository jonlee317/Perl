#!/home/s/ap/bin/perl
# This program is to extract measured
# data from *hsp.log files by using grep
# function with perl

&get0;
&get1;
&get2;
&get3;

sub get0
{
#----------- grep measured data ---------------------------------
open(fin, "< x124csirx_lib_errsync_test.lis");
open(fout, "> temp_perl") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/^ *errsync_tdr/)
        {
          print fout "$ext_data";
        }
  }

close fin;
close fout;

#----------- open files ---------------
open(fh, "<temp_perl") ||
die "Error opening file!";

open(RESULT0,">result_x124csirx_lib_errsync_test.txt") ||
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
print RESULT0 "TDR (ERRSYNC to CKN)\n";
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
open(fin, "< x124csirx_lib_errsync_test.lis");
open(fout, "> temp_perl") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/^ *errsync_slew_r/)
        {
          print fout "$ext_data";
        }
  }

close fin;
close fout;

#----------- open files ---------------
open(fh, "<temp_perl") ||
die "Error opening file!";

open(RESULT1,">>result_x124csirx_lib_errsync_test.txt") ||
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
print RESULT1 "Slew Rise (ERRSYNC to CKN)\n";
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
open(fin, "< x124csirx_lib_errsync_test.lis");
open(fout, "> temp_perl") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/^ *errsync_deser_en_tdf/)
        {
          print fout "$ext_data";
        }
  }

close fin;
close fout;

#----------- open files ---------------
open(fh, "<temp_perl") ||
die "Error opening file!";

open(RESULT2,">>result_x124csirx_lib_errsync_test.txt") ||
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
print RESULT2 "TDF (ERRSYNC to HS_DESER_EN)\n";
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
open(fin, "< x124csirx_lib_errsync_test.lis");
open(fout, "> temp_perl") ||
die "Error opening file!";

@ext_data=<fin>;
foreach $ext_data (@ext_data)
  {
      if ($ext_data=~/^ *errsync_deser_en_slew_f/)
        {
          print fout "$ext_data";
        }
  }

close fin;
close fout;

#----------- open files ---------------
open(fh, "<temp_perl") ||
die "Error opening file!";

open(RESULT3,">>result_x124csirx_lib_errsync_test.txt") ||
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
print RESULT3 "Slew Fall (ERRSYNC to HS_DESER_EN)\n";
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



