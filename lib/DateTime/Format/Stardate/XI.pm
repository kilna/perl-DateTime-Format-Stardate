
package DateTime::Format::Stardate::XI;
use base 'DateTime::Format::Stardate::Ordinal';

use strict;
use warnings;

use Carp qw(croak);
use DateTime;

our $slingshot_effect = DateTime->new( # "Present day" in Star Trek XI
        'year'      => 2258,
        'month'     => 2,
        'day'       => 11,
        'time_zone' => 'UTC',
    )
    -
    DateTime->new(                     # Premiere date of Star Trek XI
        'year'      => 2009,
        'month'     => 5,
        'day'       => 8,
        'time_zone' => 'UTC',
    );

1;
