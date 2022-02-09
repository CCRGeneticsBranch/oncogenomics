#!/usr/bin/env perl

use strict;
use warnings;
use DBI;
use Getopt::Long qw(GetOptions);
use File::Basename;
use Time::Piece;
use Time::Seconds;
use Cwd 'abs_path';
require(dirname(abs_path($0))."/../lib/Onco.pm");

my $script_dir = dirname(__FILE__);
my $app_dir=abs_path($script_dir."/../..");

my $project_id;
my $replace=0;

my $usage = <<__EOUSAGE__;

Usage:

$0 [options]

Options:

  -p  <string>  project ID
  -r            replace old data
  
__EOUSAGE__



GetOptions (
  'p=s' => \$project_id,
  'r' => \$replace
);

if (!$project_id) {
	print "$usage\n";
	exit(0);
}

my $dbh = getDBI();

my $out_file = "$app_dir/storage/project_data/$project_id/gt.txt";
system("mkdir -p $app_dir/storage/project_data/$project_id");
my %sample_pairs = ();
if ( -e $out_file) {
	open(FH, $out_file) || die "cannot open file $out_file\n";
	my $header_str = <FH>;
	chomp $header_str;
	my @samples = split(/\t/, $header_str);
	while(<FH>) {
		chomp;
		my @values = split(/\t/);
		next if ($#values<1);
		my $s2 = $values[0];
		for (my $i=1;$i<=$#values;$i++) {
			$sample_pairs{$samples[$i]}{$s2} = $values[$i];
		}
	}
}
close(FH);

my $sql = "select distinct s.path,s.patient_id,s.sample_id,s.sample_name,s.case_id from project_samples p, processed_sample_cases s where project_id=$project_id and p.sample_id=s.sample_id order by sample_id";
my $sth_samples = $dbh->prepare($sql);
$sth_samples->execute();
my %files = ();
while (my ($path, $patient_id, $sample_id, $sample_name, $case_id) = $sth_samples->fetchrow_array) {
	my $file = "$app_dir/storage/ProcessedResults/$path/$patient_id/$case_id/$sample_id/qc/$sample_id.star.gt";
	if ( -e $file ) {		
		$files{$sample_name}{$case_id} = $file;
		next;
	}
	$file = "$app_dir/storage/ProcessedResults/$path/$patient_id/$case_id/$sample_name/qc/$sample_name.star.gt";
	if ( -e $file ) {
		$files{$sample_name}{$case_id} = $file;
		next;
	}
	$file = "$app_dir/storage/ProcessedResults/$path/$patient_id/$case_id/$sample_id/qc/$sample_id.bwa.gt";
	if ( -e $file ) {
		$files{$sample_name}{$case_id} = $file;
		next;
	}
	$file = "$app_dir/storage/ProcessedResults/$path/$patient_id/$case_id/$sample_name/qc/$sample_name.bwa.gt";
	if ( -e $file ) {
		$files{$sample_name}{$case_id} = $file;
		next;
	}
}
$sth_samples->finish;
$dbh->disconnect();

my %new_list = ();
foreach my $sample_name (sort keys %files) {
	my @case_keys = sort keys %{$files{$sample_name}};
	foreach my $case_id (@case_keys) {
		my $file = $files{$sample_name}{$case_id};
		if ($#case_keys > 0) {
			$new_list{"$sample_name/$case_id"} = $file;
		} else {
			$new_list{"$sample_name"} = $file;
		}
	}
}

my @sample_list = sort keys %new_list;
if ($#sample_list <= 1) {
	print "Number of samples <= 1, no genotyping results generated!";
	exit(0);
}

open (OF, ">$out_file") || die "cannot open file $out_file\n" ;
print OF "Sample\t".join("\t", @sample_list)."\n";

foreach my $sample1 (@sample_list) {
	print OF "$sample1";
	my $file1 = $new_list{$sample1};
	foreach my $sample2 (@sample_list) {
		my $file2 = $new_list{$sample2};
		my $res = 0;
		if ($sample1 eq $sample2) {
			print OF "\t1";
		} else {
			if (exists($sample_pairs{$sample2}{$sample1})) {
				$res = $sample_pairs{$sample2}{$sample1};
			} elsif (exists($sample_pairs{$sample1}{$sample2})) {
				$res = $sample_pairs{$sample1}{$sample2};
			} else {
				$res = `perl $script_dir/scoreGenotypes.pl $file1 $file2`;
			}
			$sample_pairs{$sample1}{$sample2} = $res;
			chomp $res;
			print OF "\t$res";
		}
	}
	print OF "\n";
}
close(OF);

