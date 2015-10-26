
package DateTime::Format::Stardate::TNG;
use base 'DateTime::Format::Stardate::Sidereal';

use strict;
use warnings;

use DateTime;

# Premier of Star Trek: The Next Generation on September 28th, 1987 at 8pm
our $epoch_datetime = DateTime->new(
	'year'      => 1987,
	'month'     => 9,
	'day'       => 28,
	'hour'      => 20,
	'time_zone' => 'America/New_York',
);

our $epoch_stardate = 41153.7;

1;
