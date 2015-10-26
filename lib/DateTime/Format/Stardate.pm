
package DateTime::Format::Stardate;

use warnings;
use strict;

use Class::ISA;
use Scalar::Util qw(blessed);
use Carp qw(croak);

=pod

=head1 NAME

DateTime::Format::Stardate - Calculate DateTimes into Star Trek stardates

=head1 VERSION

Version 1.0.0

=cut

our $VERSION = '1.0.0';

=pod

=head1 SYNOPSIS

This is the base class that the other DateTime::Format::Stardate::* modules
inherit from, you can use it to create your own custom stardate calculators.
What you probably want is one of the already configured subclasses below.

=head2 Contemporary Formatters

These DateTime formatters use an epoch in contemporary times of the premier
of a given series or film, using 22nd/23rd century stardates to represent
modern dates.

=over 4

=item L<DateTime::Format::Stardate::TOS>

Star Trek the original series (TOS), permiered in 1966 at stardate 1312.4

=item L<DateTime::Format::Stardate::TNG>

Star Trek: The Next Genertion premiered in 1987 at stardate 41153.7

=item L<DateTime::Format::Stardate::XI>

The 11th Star Trek movie, by J.J.Abrams, released in 2009 at stardate 2258.42,
using ordinal dates instead of 1000 stardates per year.

=back

=head2 General Purpose Formatters

=item L<DateTime::Format::Stardate::Sidereal>

Base class for star-year floating point style stardates

=item L<DateTime::Format::Stardate::Ordinal>

Base class for ordinal date style stardates

=cut

sub new
{
	my $class = shift;
    my $self = bless { @_ }, $class;
    $self->check;
    return $self;
}

sub clone
{
    my $self = shift;
    return bless { %{$self}, @_ }, ref($self);
}

# This is a utility function for translating fractional solar year calendars
# to gregorian dates
sub parse_datetime
{
    croak "DateTime::Format::Stardate must be subclassed.  "
        . "Use one of the DateTime::Format::Stardate modules instead.";
}

# This is a utility function for translating gregorian dates to fractional solar years calendar entries
sub format_datetime
{
    croak "DateTime::Format::Stardate must be subclassed.  "
        . "Use one of the DateTime::Format::Stardate modules instead.";
}

# Integer describing how granular the datetimes being formatted into stardates
# will be
sub precision {
    my $self = shift;
    return $self->_resolve( 'precision', shift(@_), 1 );
}

sub _resolve {
    my $self    = shift;
    my $field   = shift;
    my $newval  = shift;
    my $default = shift;
    if (defined $newval) { $self->{$field} = $newval; }
    if (defined $self->{$field}) { return $self->{'field'}; }
    foreach my $this_class ( Class::ISA::self_and_super_path( ref($self) ) ) {
        no strict 'refs';
        next unless defined( ${ $this_class . '::' . $field } );
        return ${ $this_class . '::' . $field };
    }
    if (defined $default) { return $default; }
    croak "DateTime::Format::Stardate has been inproperly subclassed or "
         . "instantiated, ($field must be set)";
}

# Zero-length duration object
our $no_slingshot = DateTime::Duration->new();

sub slingshot_effect {
    my $self   = shift;
    my $newval = shift;
    return eval { $self->_resolve( 'slingshot_effect', $newval ) };
}


=pod

=head1 AUTHOR

Anthony Kilna, C<< <anthony at kilna dot com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-date-stardate at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DateTime-Format-Stardate>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DateTime::Format::Stardate


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DateTime-Format-Stardate>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DateTime-Format-Stardate>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DateTime-Format-Stardate>

=item * Search CPAN

L<http://search.cpan.org/dist/DateTime-Format-Stardate>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2012 Kilna Companies, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of DateTime::Format::Stardate
