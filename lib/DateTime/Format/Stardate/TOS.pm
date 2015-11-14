
package DateTime::Format::Stardate::TOS;
use base 'DateTime::Format::Stardate::Sidereal';

use strict;
use warnings;

use DateTime;

# Premiere of Star Trek (the original series) on September 8, 1966 at 8:30pm
our $epoch_datetime = DateTime->new(
    'year'      => 1966,
    'month'     => 9,
    'day'       => 8,
    'hour'      => 20,
    'minute'    => 30,
    'time_zone' => 'America/New_York',
);

our $epoch_stardate = 1312.4;

1;
