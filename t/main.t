#!perl

use strict;
use warnings;

use Test::More 'no_plan';

my @classes;
BEGIN {
#    @classes = qw( TOS TNG XI Ordinal Sidereal );
    @classes = qw( TOS );
    use_ok "DateTime";
    use_ok "DateTime::Format::Stardate::$_" foreach @classes;
}

my %class_tests = (
    'TOS' => {
        '1314.4' => {
            'year'      => 1966,
            'month'     => 9,
            'day'       => 8,
            'hour'      => 20,
            'minute'    => 30,
            'time_zone' => 'America/New_York',
        },
    },
    'TNG' => {
    },
    'XI'  => {
    },
    'Ordinal' => {
    },
    'Sidereal' => {
    }
);
    
foreach my $short (@classes) {
    my $class = "DateTime::Format::Stardate::$short";
    foreach my $stardate (keys %{$class_tests{$short}}) {
        my %params = %{$class_tests{$short}->{$stardate}};
        my $f = $class->new( 'precision' => 1 );
        my $dt = DateTime->new( %params, formatter => $f );
        is(
            $dt.'',
            $stardate,
            "$short gregorian -> stardate"
        );
print $dt."\n";
        my $sd = $f->;
        is(
            $dt->ymd.' '.$dt->hms,
            $sd->ymd.' '.$sd->hms,
            "$short stardate -> gregorian"
        );
print $sd."\n";
    }
}
