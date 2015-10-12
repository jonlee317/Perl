#! /usr/bin/env perl
#######################################################
#     Mixel Confidential                              #
#     Author  : Ahmed F. Aboulella                    #
#     Version : 1.0                                   #
#######################################################
                                                       

## -----------------------------------------------------------------------------
## Invocation:
##
## create_svrf.pl
##   <layers.txt>
## -----------------------------------------------------------------------------


$cmd = $0;
use Getopt::Long;

$errors = $warnings = 0;

$arg_txt_file = $ARGV[0];

if (($GetOptionsStatus == -1) ||
    ($#ARGV != 0) ||
    ($arg_txt_file !~ /.txt$/))
{
    print("Command usage is:\n");
    print("  create_svrf.pl\n");
    print("    <layers.txt>\n");
    print("    \n");
    Fatal("Aborting\n");
}

## -----------------------------------------------------------------------------
## Pre-check stuff
## -----------------------------------------------------------------------------

($out_file = $arg_txt_file) =~ s/\.txt$/\.svrf/;

system("rm -rf $tmp_file $out_file");

if ( ! -f $arg_txt_file ) {
  print "create_svrf.pl: ... Error!\n";
  print "create_svrf.pl: ... Input file $arg_txt_file does not exist.\n";
  print "create_svrf.pl: ... Output svrf file has not been generated.\n";
  exit 1
}

@txt_file_array = ();

open(txt_FILE, "< $arg_txt_file") ||
  Fatal("Unable to read file $arg_txt_file.");

while ($line = <txt_FILE>) {
  $txt_file_array[($#txt_file_array+1)] = $line;
}




open(OUT_FILE, "> $out_file") ||
  Fatal("Unable to create <out_file> $out_file.");
print OUT_FILE "/////////////////////////////////////////////////\n";
print OUT_FILE "/// Mixel Confidential                        ///\n";
print OUT_FILE "/// Script to Merge all layers in a given GDS ///\n";
print OUT_FILE "/// Author: Ahmed Aboulella                   ///\n";
print OUT_FILE "/////////////////////////////////////////////////\n";
print OUT_FILE "\n";
print OUT_FILE "LAYOUT PATH X109T001_IP.gds\n";
print OUT_FILE "LAYOUT PRIMARY X109T001\n";
print OUT_FILE "LAYOUT SYSTEM GDS\n";
print OUT_FILE "DRC RESULTS DATABASE X109T001_IP_flat_merged.gds GDSII\n";
print OUT_FILE "DRC SUMMARY REPORT merged.report\n";
print OUT_FILE "DRC MAXIMUM RESULTS ALL\n";
print OUT_FILE "\n";

  for ($line_num = 0; $line_num <= $#txt_file_array; $line_num++) {
    if ($line =~ /nothing for now/) {
    } else {
    $line = $txt_file_array[$line_num];
    @layer_array = ();
    $#layer_array = -1;
    @line_array = split( /\s+/, $line );
    @layer_array = split( /\./, $line_array[0] );
        if ($layer_array[1] eq "" ) { 
            $layer_array[1] = 0;
        }    
    $layer_num_tmp = 0;
    $layer_num_tmp = $line_num + 500;
    $layer_name_tmp = (tmp).($line_num);
    $layer_name_tmp2 = (tmp2).($line_num);
    print OUT_FILE "LAYER $layer_name_tmp  $layer_num_tmp\n";  
    print OUT_FILE "LAYER MAP $layer_array[0] DATATYPE $layer_array[1] $layer_num_tmp\n";  
    print OUT_FILE "$layer_name_tmp2 { MERGE  $layer_name_tmp }\n";  
    print OUT_FILE "DRC CHECK MAP $layer_name_tmp2 $layer_array[0] $layer_array[1]\n";  
    print OUT_FILE "\n";
    }
  }





## -----------------------------------------------------------------------------
## Misc utilities
## -----------------------------------------------------------------------------

sub Fatal {
  printf STDERR "FATAL: %s\n","@_";
  exit(1);
}
sub Error {
  printf STDERR "ERROR: %s\n","@_";
  $errors++;
}
sub Warn {
  printf STDERR "WARNING: %s\n","@_";
  $warnings++;
}
sub Info {
  printf STDERR "INFO: %s\n","@_";
}
