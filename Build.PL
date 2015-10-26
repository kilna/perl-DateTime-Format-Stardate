use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'DateTime::Format::Stardate',
    license             => 'perl',
    dist_author         => 'Anthony Kilna <anthony@kilna.com>',
    dist_version_from   => 'lib/DateTime/Stardate.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'DateTime-Format-Stardate-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
