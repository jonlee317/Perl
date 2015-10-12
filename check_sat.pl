#!/cirrus/bin/perl5
#------ Set default value --------------------
$min_ids=10e-9;
$vdsat_mrg=0;

#------ Ask user to input log file name ------
open(input, ">checksat.txt") || die ("Cannot open file!");
print input "(Enter Hspice LIS File name below)\n";
print input "Name->\n";
print input "Ids(min)->$min_ids\n";
print input "Vdsat margin ->$vdsat_mrg\n";
close input;

system ("notepad", "checksat.txt");

open(input, "<checksat.txt") || die ("Cannot open file!");
@hold1=<input>;
@field=split("->",$hold1[1]);
$file=$field[1];
@field=split("->",$hold1[2]);
$min_ids=$field[1];
@field=split("->",$hold1[3]);
$vdsat_mrg=$field[1];
close input;

#----------- open files ---------------
open(fh, "<$file") ||
die "Error opening file!";

#--- Store opened files in an array ----
@main=<fh>;

#--- Seperate array to different corners ---
$valid=0;
$corner=0;
$count=0;
foreach $main (@main)
{
  if ($main =~ /^\s\*\*\*\*\s\svoltage sources/)
    {
      $corner=$corner+1;
      $valid=1;
    }
  if ($valid==1)
  {
     if ($main !~ /^\s*\*\*\*\*\*\sjob concluded/)
       {
         $data1[$count]=$main;
         $count=$count+1;
       }
     else
       {
	 $valid=0;
         $data1[$count]="corners_end\n";
         $count=$count+1;
       }
  }
}
$valid=0;
$corner=0;
$count=0;
foreach $data1 (@data1)
{
  if ($data1 =~ /^\s\*\*\*\*\smosfets/)
    {
      $corner=$corner+1;
      $valid=1;
    }
  if ($valid==1)
  {
     if ($data1 !~ /^corners_end/)
       {
         $data[$count]=$data1;
         $count=$count+1;
       }
     else
       {
	 $valid=0;
         $data[$count]=$data1;
         $count=$count+1;
       }
  }
}

#foreach $data (@data)
#{
#   print "$data";
#}

#---------------------------------------------------------
#           Generate element Array
#--------------------------------------------------------
$count=0;
ELEMENT: foreach $data (@data)
{
  if ($data =~ /^corners_end/ )
    {
      last ELEMENT;
    }
  if ($data =~ /^\selement/)
    {
      $hold[$count]=$data;
      $count=$count+1;
    }
}

$count=0;
#foreach $hold (@hold)
#{
#   print "$hold";
#}

foreach $hold (@hold)
{
   @field=split(" ",$hold);
   shift @field;
   foreach $field (@field)
   {
    $element[$count]=$field;
    $count=$count+1;
   }
}
$element_size=@element;

#---------------------------------------------------------
#           Generate Id Array
#---------------------------------------------------------
$count=0;
foreach $data (@data)
{
  if ($data =~ /^\s\sid/)
    {
      $hold[$count]=$data;
      $count=$count+1;
    }
}

$count=0;
#foreach $hold (@hold)
#{
#   print "$hold";
#}

foreach $hold (@hold)
{
   @field=split(" ",$hold);
   shift @field;
   foreach $field (@field)
   {
    $Id[$count]=&sci2fl($field);
    $count=$count+1;
   }
}
$Id_size=@Id;

#---------------------------------------------------------
#           Generate vdsat Array
#---------------------------------------------------------
$count=0;
foreach $data (@data)
{
  if ($data =~ /^\s\svdsat/)
    {
      $hold[$count]=$data;
      $count=$count+1;
    }
}

$count=0;
foreach $hold (@hold)
{
   @field=split(" ",$hold);
   shift @field;
   foreach $field (@field)
   {
    $vdsat[$count]=&sci2fl($field);
    $count=$count+1;
   }
}
$vdsat_size=@vdsat;

#---------------------------------------------------------
#           Generate vth Array
#---------------------------------------------------------
$count=0;
foreach $data (@data)
{
  if ($data =~ /^\s\svth/)
    {
      $hold[$count]=$data;
      $count=$count+1;
    }
}

$count=0;
foreach $hold (@hold)
{
   @field=split(" ",$hold);
   shift @field;
   foreach $field (@field)
   {
    $vth[$count]=&sci2fl($field);
    $count=$count+1;
   }
}
$vth_size=@vth;

#---------------------------------------------------------
#           Generate vgs Array
#---------------------------------------------------------
$count=0;
foreach $data (@data)
{
  if ($data =~ /^\s\svgs\s/)
    {
      $hold[$count]=$data;
      $count=$count+1;
    }
}

$count=0;
foreach $hold (@hold)
{
   @field=split(" ",$hold);
   shift @field;
   foreach $field (@field)
   {
    $vgs[$count]=&sci2fl($field);
    $count=$count+1;
   }
}
$vgs_size=@vgs;

#---------------------------------------------------------
#           Generate vds Array
#---------------------------------------------------------
$count=0;
foreach $data (@data)
{
  if ($data =~ /^\s\svds\s/)
    {
      $hold[$count]=$data;
      $count=$count+1;
    }
}

$count=0;
foreach $hold (@hold)
{
   @field=split(" ",$hold);
   shift @field;
   foreach $field (@field)
   {
    $vds[$count]=&sci2fl($field);
    $count=$count+1;
   }
}
$vds_size=@vds;

#foreach $vds (@vds)
#{
#   print "$vds\n";
#}
#print "size=$vds_size\n";

#---------------------------------------------------------
#           Generate gds Array
#---------------------------------------------------------
$count=0;
foreach $data (@data)
{
  if ($data =~ /^\s\sgds/)
    {
      $hold[$count]=$data;
      $count=$count+1;
    }
}

$count=0;
foreach $hold (@hold)
{
   @field=split(" ",$hold);
   shift @field;
   foreach $field (@field)
   {
    $gds[$count]=&sci2fl($field);
    $count=$count+1;
   }
}
$gds_size=@gds;

#---------------------------------------------------------
#           Generate region Array
#---------------------------------------------------------
$count=0;
foreach $data (@data)
{
  if ($data =~ /^\sregion/)
    {
      $hold[$count]=$data;
      $count=$count+1;
    }
}

$count=0;
foreach $hold (@hold)
{
   @field=split(" ",$hold);
   shift @field;
   foreach $field (@field)
   {
    $region[$count]=$field;
    $count=$count+1;
   }
}
$region_size=@region;


#---------------------------------------------------------
#           Generate vds-vdsat
#---------------------------------------------------------
$count=0;
foreach $vds (@vds)
{
  $vdelta[$count]=$vds-$vdsat[$count]-$vdsat_mrg;
  $count=$count+1;
}
$vdelta_size=@vdelta;

#---------------------------------------------------------
#           Print Report
#---------------------------------------------------------
#$corner=$Id_size/$element_size;
#for ($i=0; $i<$corner; $i++)
#  {
#     print ("corners \n");
#
#     for ($j=0; $j<$element_size; $j++)
#       {
#         $pos=$element_size*$i+$j;
#         printf "%-30s %15s %10s %10s %10s\n", $element[$j], $region[$pos], &fl2sci($vdsat[$pos]), &fl2sci(abs($vdelta[$pos])), &fl2sci($Id[$pos]);
# #       print "$element[$j], $region[$pos], $vdsat[$pos], $vdelta[$pos], $Id[$pos]\n";
#       }
#  }

#---------------------------------------------------------
#           Put Data in EXCEL WorkBook
#---------------------------------------------------------
$corner=$Id_size/$element_size;
use OLE;

$app=CreateObject OLE 'Excel.Application' || die $!;

$app -> {'Visible'} =1;

$workbook=$app -> Workbooks-> Add();

for ($i=0; $i<$corner-3; $i++)
 {
     $workbook -> Worksheets -> Add();
 }

for ($i=0; $i<$corner; $i++)
 {

   $worksheet=$workbook -> Worksheets($i+1);
  
   $worksheet -> Range("A1:I1") -> {'Value'} = ["transistor", "region of operation", "vdsat", "amount in saturation/triode", "vth", "vds", "vgs", "gds", "current(ids)"];

   $worksheet -> Range("A1:B1") -> {'ColumnWidth'}=20;
   $worksheet -> Range("C1") -> {'ColumnWidth'}=15;
   $worksheet -> Range("D1") -> {'ColumnWidth'}=25;
   $worksheet -> Range("E1") -> {'ColumnWidth'}=15;
   $worksheet -> Range("F1") -> {'ColumnWidth'}=15;
   $worksheet -> Range("G1") -> {'ColumnWidth'}=15;
   $worksheet -> Range("H1") -> {'ColumnWidth'}=15;
   $worksheet -> Range("I1") -> {'ColumnWidth'}=15;

   $row=2;
   for ($j=0; $j<$element_size; $j++)
    {
      $pos=$element_size*$i+$j;
      if ($Id[$j]>= $min_ids)
       {
        $worksheet -> Range("A".$row.":I".$row) -> {'Value'} = [$element[$j], $region[$pos], &fl2sci($vdsat[$pos]), &fl2sci(abs($vdelta[$pos])), &fl2sci($vth[$pos]), &fl2sci($vds[$pos]),&fl2sci($vgs[$pos]), &fl2sci($gds[$pos]), &fl2sci($Id[$pos])];
        $row=$row+1;
       }
    }
   $worksheet -> Range("A".$row) -> {'Value'} = "corner $i";
  }
  
#---------------------------------------------------------
#           Unit Conversion Subroutine
#---------------------------------------------------------
sub sci2fl
{
  my($data);
  $data=@_[0];
  $data=~ s/meg/e6/i;
  $data=~ s/k/e3/i;
  $data=~ s/m/e-3/i;
  $data=~ s/u/e-6/i;
  $data=~ s/n/e-9/i;
  $data=~ s/p/e-12/i;
  $data=~ s/f/e-15/i;
  $data=abs($data);
  return($data);
}

sub fl2sci
{
  my($data);
  $data=@_[0];
  if ($data >=1E9)
    { 
     $data=($data/1e9)."g";
     return($data);
    }
  elsif ($data >=1E6)
    { 
     $data=($data/1e6)."meg";
     return($data);
    }
  elsif ($data >=1E3)
    { 
     $data=($data/1e3)."k";
     return($data);
    }
  elsif ($data >=1)
    { 
     return($data);
    }
  elsif ($data >=1E-3)
    { 
     $data=($data/1e-3)."m";
     return($data);
    }
  elsif ($data >=1E-6)
    { 
     $data=($data/1e-6)."u";
     return($data);
    }
  elsif ($data >=1E-9)
    { 
     $data=($data/1e-9)."n";
     return($data);
    }
  elsif ($data >=1E-12)
    { 
     $data=($data/1e-12)."p";
     return($data);
    }
  elsif ($data >=1E-15)
    { 
     $data=($data/1e-15)."f";
     return($data);
    }
  else
    {
     return($data);
    }
}
