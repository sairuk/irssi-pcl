use Irssi;
use strict;
use vars qw($VERSION %IRSSI);
$VERSION = '0.0.1';
%IRSSI = (
        authors     => 'sairuk',
        contact     => '',
        name        => 'pcl',
        description => 'process server commands from file, effect mass bans etc',
        license     => 'GPLv2',
);

my $server_name = '';

sub pcl_stop {
    my ( $data, $server, $witem ) = @_;
    if ( $data ) {
        Irssi::print($data);
    }
    Irssi::signal_stop();
}

sub pcl {
    my ( $data, $server, $witem ) = @_;
    my $line = "";
    if ( $server->{tag} == $server_name ) {
        if ( ! $data ) { pcl_stop('Pass an absolute file path'); }
        open FILE, "<".$data or pcl_stop("Couldn't open " . $data);
        while (my $line = <FILE>) {
            chomp($line);
            Irssi::print($line);
            $server->send_raw($line);
        }
    } else {
        pcl_stop('Wrong server: ' . $server->{tag});
    }
}

Irssi::command_bind('pcl', \&pcl);
