
package DateTime::Format::Stardate:Sidereal;
use base 'DateTime::Format::Stardate';

use warnings;
use strict;

use Carp qw(croak);

# Stardate -> DateTime
# This is a utility function for translating fractional solar year calendars
# to gregorian dates
sub parse_datetime
{
    my $self = shift; # Object or classname
    my $stardate = shift;

    unless ($stardate =~ m/^\-?\d+(?:\.\d+)$/)
    {
        croak "Provided stardate formatted incorrectly";
    }
    
    # How many stardates difference between the epoch
    # stardate and the provided one
    my $delta_stardates = ($stardate - $self->epoch_stardate);
    
    # How many years difference  between the epoch 
    # stardate and the provided one
    my $delta_years = $delta_stardates / $self->stardates_per_year;
    
    # How many days difference  between the epoch
    # stardate and the provided one
    my $delta_days = $delta_years * $self->days_per_year;
    
    # How many seconds difference  between the epoch    
    #  stardate and the provided one
    my $delta_seconds = $delta_days * 86400;
    
    # DateTime::Duration object representing the difference 
    # between the epoch stardate and the provided one
    my $delta = DateTime::Duration->new( 'seconds' => $delta_seconds, );
    
    # DateTime object representing this stardate
    my $datetime = $self->epoch_datetime->clone; # Take the epoch stardate
    
    # And add the delta we calculated and any temporal adjustment
    $datetime->add( $delta - $self->slingshot_effect);
    
    return $datetime;
}

# DateTime -> Stardate
# This is a utility function for translating gregorian dates to fractional
# solar years calendar entries
sub format_datetime
{
    my $self = shift; # Object or classname
    my $dt = shift;
    
    my $isa_check = eval { $dt->isa('DateTime') };
    if ($@ || not $isa_check)
    {
        croak "Provided datetime must be a DateTime object";
    }
    
    # DateTime::Duration object representing the difference between the epoch
    # and provided datetimes
    my $delta = $dt->subtract_datetime_absolute($self->epoch_datetime)
        + $self->slingshot_effect;
    
    # How many days difference between the epoch datetime and the provided one
    my $delta_days = $delta->in_units('days');
    
    # How many years difference between the epoch datetime and the provided one
    my $delta_years = $delta_days / $self->solar_days_per_year;

    # How many stardates difference between the epoch datetime and the provided
    # one
    my $delta_stardates = $delta_years * $self->stardates_per_year;
    
    # The end result stardate
    my $stardate = $self->epoch_stardate + $delta_stardates;
    
    return sprintf '%.'.$self->precision.'f', $stardate;
}

sub check {
    my $self = shift;
    $self->stardates_per_year;
    $self->days_per_year;
    $self->epoch_stardate;
    $self->epoch_datetime;
}

sub stardates_per_year  {
    my $self = shift;
    my $newval = shift;
    return $self->_resolve('stardates_per_year', $newval, 1000 );
}

sub days_per_year {
    my $self = shift;
    my $newval = shift;
    return $self->_resolve('days_per_year', $newval, 365.256363004 );
}

sub epoch_stardate {
    my $self = shift;
    my $newval = shift;
    return $self->_resolve('epoch_stardate', $newval );
}

sub epoch_datetime {
    my $self = shift;
    my $newval = shift;
    return $self->_resolve('epoch_datetime', $newval );
}

sub slingshot_effect {
    my $self   = shift;
    my $newval = shift;
    my $value = $self->_resolve(
        'slingshot_effect',
        $newval,
        $DateTime::Format::Stardate::no_slingshot
    );
    unless ( blessed($value) eq 'DateTime::Duration' ) {
        my $formatter = $self->clone( 'slingshot_effect' => undef );
        $self->{'slingshot_effect'} = $formatter->parse_datetime( $value )
             - $formatter->parse_datetime( 0 );
        return $self->{'slingshot_effect'};
    }
    return $value;
}

1;
