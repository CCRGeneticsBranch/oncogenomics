use DBI;
use Getopt::Long qw(GetOptions);


sub getDBI {
  my $script_dir = dirname(__FILE__);
  my $cmd = "php $script_dir/getDBConfig.php";
  my @db_config = readpipe($cmd);
  my ($host, $sid, $username, $passwd, $port) = split(/\t/, $db_config[0]);

  my $dbh = DBI->connect( "dbi:Oracle:host=$host;port=$port;sid=$sid", $username, $passwd, {
      AutoCommit => 0,
      RaiseError => 1,    
  }) || die( $DBI::errstr . "\n" );
  return $dbh;
}

sub getDBConfig {
  my $script_dir = dirname(__FILE__);  
  my $cmd = "php $script_dir/getDBConfig.php";
  my @db_config = readpipe($cmd);
  my @results = split(/\t/, $db_config[0]);
  return @results;
}

sub getDBHost {
  my $script_dir = dirname(__FILE__);  
  my $cmd = "php $script_dir/getDBConfig.php";
  my @db_config = readpipe($cmd);
  my ($host, $sid, $username, $passwd, $port) = split(/\t/, $db_config[0]);

  return $host;
}

sub getDBSID {
  my $script_dir = dirname(__FILE__);
  my $cmd = "php $script_dir/getDBConfig.php";
  my @db_config = readpipe($cmd);
  my ($host, $sid, $username, $passwd, $port) = split(/\t/, $db_config[0]);

  return $sid;
}


sub getConfig {
  my ($key) = @_;
  my $script_dir = dirname(__FILE__);
  my $cmd = "php $script_dir/getSiteConfig.php $key";
  my @values = readpipe($cmd);
  return $values[0];  
}

sub formatDir {
    my ($dir) = @_;
    if ($dir !~ /\/$/) {
        $dir = $dir."/";
    }
    return $dir;
}
1