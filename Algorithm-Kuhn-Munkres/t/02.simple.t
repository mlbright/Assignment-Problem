#!perl -T

use Test::Simple tests => 1;
use Algorithm::Kuhn::Munkres qw( assign );

my @matrix = ([1,2,3],[3,3,3],[3,3,2]);
my ($cost,$mapping) = assign(@matrix);
ok($cost eq '9');
