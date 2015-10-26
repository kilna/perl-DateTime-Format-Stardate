
package DateTime::Format::Stardate::Ordinal;
use base 'DateTime::Format::Stardate';

use strict;
use warnings;

use DateTime::Duration;

# Stardate -> DateTime
sub parse_datetime
{
	my $source = shift;
	my $class = ref($source) || $source;

	my $stardate = shift;
	unless ($stardate =~ m/
            ^
            (\-?\d+) # Year
            (\.\d+)? # Ordinal day
            (?:      # Optional HH:MM:SS.SS
                \s+
                (\d+) \: (\d+) # Hour and minutes
                (?: \: ( \d+(?:\.\d+)? ) )? # Optional seconds
            )?
            $
        
        /x
    )
	{
		croak "Provided stardate was formatted incorrectly"
	}
    
	my $dt = DateTime->new( 'year' => $1, 'month' => 1, 'day' => 1 );
	$dt->add(
        DateTime::Duration->new(
            'days'  => ( ($2 - 1) || 0 ),
            'hours' => ($3 || 0),
            'mins'  => ($4 || 0),
            'secs'  => ($5 || 0),
        )
    );

    $dt->subtract_duration( $self->slingshot_effect );
    
	return $dt;
}

# DateTime -> Stardate
sub format_datetime
{
	my $source = shift;
	my $class = ref($source) || $source;
    
	my $dt = shift;
	my $isa_check = eval { $dt->isa('DateTime') };
	if ($@ || not $isa_check)
	{
		croak "Provided datetime must be a DateTime object";
	}

    my $adj_dt = $dt->clone;
    $adj_dt->add_duration( $self->slingshot_effect );
	
	my $year_dt = DateTime->new(
        'year'  => $dt->year,
        'month' => 1,
        'day'   => 1,
    );
    
	my $ord_day = int(
        $adj_dt->subtract_datetime_absolute( $year_dt )->in_units('days')
    );

    # Precision
    #  0 = YYYY
    #  1 = YYYY.DDD
    #  2 = YYYY.DDD HH:MM
    #  3 = YYYY.DDD HH:MM:SS
    #  4 = YYYY.DDD HH:MM:SS.S
    #  5 = YYYY.DDD HH:MM:SS.SS
    #      ...
    # 12 = YYYY.DDD HH:MM:SS.SSSSSSSSS
    my $out = $adj_dt->year;
    if ($self->precision > 1) { $out .= '.' . $ord_days; }
    if ($self->precision == 2) {
        $out .= ' ' . $adj_dt->hms;
        $out =~ s/\:\d+$//;
    }
    elsif ($self->precision == 3) {
        $out .= ' ' . $adj_dt->hms;
    }
    elsif ($self->precision >= 4) {
        $out .= ' ' . $adj_dt->hms;
        $out =~ s/\:\d+$//;
        $out .= sprintf '%.'.($self->precision-3).'f', $dt->fractional_second;
    }
	return $out;
}

sub check {
    my $self = shift;
    $self->slingshot_effect;
}

1;
