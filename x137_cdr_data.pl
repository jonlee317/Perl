#!/usr/local/bin/perl



#----------- open file ---------------
open (netlist_org, "<input.cir") ||
die "Error opening file!";

open (netlist_mod, ">output.cir") ||
die "Error opening file!";


#--- Store opened file in an array ----
@data=<netlist_org>;
close netlist_org;


#---------- Processing data  -------------


foreach $data (@data)
{

	#Set the correct chargepump and resistor settings
	$data=~s/\.PARAM Ci3\=0 Ci2\=0 Ci1\=0 Ci0\=1/\.PARAM Ci3\=0 Ci2\=1 Ci1\=1 Ci0\=1/ig;
	$data=~s/\.PARAM cr1\=1 cr0\=1/\.PARAM cr1\=1 cr0\=0/ig;

	#Set the datarate, might not be necessary if you get to choose the vector file
	$data=~s/\*\.param BIT_RATE\=6e9/\.param BIT_RATE\=6e9/ig;
	$data=~s/\*\.param UI\='1\/BIT_RATE\*1e9'/\.param UI\='1\/BIT_RATE\*1e9'/ig;
	$data=~s/\*\.param TRF\=0.05/\.param TRF\=0.05/ig;
	$data=~s/\*\.param TDLY\=0/\.param TDLY\=0/ig;

	#ENAble CDRLS and CDRMODE	
	$data=~s/V0 CDRLS VSS PWL \( 0 0 1NS 0 1.2NS 0 \)/V0 CDRLS VSS PWL \( 0 0 1NS 0 1.2NS 'VDDL' \)/ig;
	$data=~s/VCDRMODE CDRMODE VSS PWL \( 0 0 1NS 0 1.2NS 0 \)/VCDRMODE CDRMODE VSS PWL \( 0 0 1NS 0 1.2NS 'VDDL' \)/ig;

	#Change the vector file
	$data=~s/\*\.vec '\/mnt\/y\/Projects\/x137\/x1371\/Design\/files\/vec\/x1371hsrx_tran_test.vec'/\.vec '\/mnt\/y\/Projects\/x137\/x1371\/Design\/files\/vec\/x1371hsrx_tran_test.vec'/ig;

	#Disable the previous source
	$data=~s/VRXP RXP VSS PWL \( 0 0 1NS 0 1.2NS 0 \)/\*VRXP RXP VSS PWL \( 0 0 1NS 0 1.2NS 0 \)/ig;
	$data=~s/VRXN RXN VSS PWL \( 0 'VDDL' 1NS 'VDDL' 1.2NS 'VDDL' \)/\*VRXN RXN VSS PWL \( 0 'VDDL' 1NS 'VDDL' 1.2NS 'VDDL' \)/ig;

	chomp($data);
	print netlist_mod "$data\n";

}