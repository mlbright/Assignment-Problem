#!perl -T

use Test::Simple tests => 1;
use Algorithm::Kuhn::Munkres qw( assign );

my @matrix = ([1,2,3,4],[2,4,6,8],[3,6,9,12],[4,8,12,16]);
my ($cost,$mapping) = assign(@matrix);
ok( $cost eq '30');
