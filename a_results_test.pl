#!/home/s/ap/bin/perl

# Automatically create measurement table


$list_filename = "x163bgr_ac_test.lis"; #Enter your *.lis file
$meas_filename = "x163bgr_ac_test.meas";            #Enter your measurement file
$result_filename = "result_x163bgr_ac_test.txt"; #Enter your Result file name
$num_corners = 10;   #Define the number of corners and modify the names below

&get0;

sub get0 {
  #----------- grep measured data ---------------------------------
  #open(fin, "< x163bgr_up_test.lis");
  open(fin, "<", $list_filename);
  open(fin_meas, "< $meas_filename");
  open(fout, "> temp_perl") ||
  die "Error opening file!";

  @ext_data=<fin>;
  @ext_meas=<fin_meas>;

  foreach $meas (@ext_meas) {
    if ($meas =~ m/meas/) {
      @meas_array = split (/\s+/, $meas);

      $meas_name = "^ *$meas_array[2]=";
      #print $meas_name;
      push @list_values, $meas_name;
      push @list_raws, $meas_array[2];
    }
  }

 # @list_values = (
 #   '^ *vbc_800ns=',
 #   '^ *vsh_b_800ns=',
  #  '^ *zidh=',
  #  );

  $list_size = @list_values;

  foreach $value (@list_values) {
    foreach $ext_data (@ext_data) {
      if ($ext_data=~/$value/) {
        print fout "$ext_data";
      }
    }
  }

  close fin;
  close fin_meas;
  close fout;

  #----------- open files ---------------
  open(fh, "<temp_perl") ||
  die "Error opening file!";

  #print "$list_size\n";

  #---Store opened files in associative array ----
  @tmp=<fh>;
  for ($i=0; $i<($list_size*$num_corners); $i++)
  {
      $spec{$i}=$tmp[$i];
      $spec{$i} =~ s/\=-/\= -/;
  }
  close fh;

  #---------- Define process -----------
  $title = "Process\tVdd(V)\tTemp(C)\tRscale";
  $sep_line = "================================";
  $process{0}=("TT\t1.0\t85\tTT_RES");
  $process{1}=("TT\t0.85\t-40\tSS_RES");
  $process{2}=("SS\t0.85\t125\tSS_RES");
  $process{3}=("SS\t0.85\t125\tFF_RES");
  $process{4}=("SS\t0.85\t-40\tSS_RES");
  $process{5}=("FF\t1.1\t-40\tFF_RES");
  $process{6}=("FF\t1.1\t125\tFF_RES");
  $process{7}=("FF\t0.85\t125\tFF_RES");
  $process{8}=("FS\t0.85\t125\tTT_RES");
  $process{9}=("SF\t0.85\t125\tTT_RES");

  #---------- Extract data -------------
  for ($i=0; $i<$num_corners; $i++) {
    $count = 0;
    $data[$i]=$process{$i};
    while ($count < $list_size) {
      @field = split(' ', $spec{2*$i+1+$count*$num_corners*2});
      $data[$i] = $data[$i]."\t".($field[1]);
      $count = $count + 1;
    }
    #$cleaned_up = $list_values[$i];
    #$cleaned_up =~ s/\^ \*//;
    #$cleaned_up =~ s/\=//;
    $title = $title."\t".$list_raws[$i];
    
    #$title = $title."\t".$cleaned_up;
  }

  $cnt_sep_len = 0;
  while ($cnt_sep_len < $list_size) {
    $sep_line = $sep_line."================";
    $cnt_sep_len = $cnt_sep_len + 1;
  }  

  #print "$title\n";
  #print "$data[0]\n";
  #print "$data[1]\n";
  #print @data;

  #---------- Open output file & write spec ------------
  open(RESULT0,"> $result_filename") ||
  die "Error opening file!";
  print RESULT0 "\n\n              x1371 Rterm AC Simulation Result  \n";
  print RESULT0 "$sep_line\n";
  print RESULT0 "$title\n";
  print RESULT0 "$sep_line\n";
  foreach $data (@data) {
    print RESULT0 "$data\n";
  }
  close RESULT0;
  #system "del temp_perl";
  print "Finished with no problems!\n\nPlease check your result file.\n";
}
