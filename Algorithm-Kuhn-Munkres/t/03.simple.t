#!perl -T

use Test::Simple tests => 1;
use Algorithm::Kuhn::Munkres qw( assign );

my @matrix = ([7,4,3],[3,1,2],[3,0,0]);
my ($cost,$mapping) = assign(@matrix);
ok($cost == 9);
