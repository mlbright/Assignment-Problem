#!perl -T

use Test::Simple tests => 4;
use Algorithm::Kuhn::Munkres qw( assign );

my @matrix = ([1,2,3,4],[2,4,6,8],[3,6,9,12],[4,8,12,16]);
my ($cost,$mapping) = assign(@matrix);
ok($cost == 30);

@matrix = ([1,2,3],[3,3,3],[3,3,2]);
($cost,$mapping) = assign(@matrix);
ok($cost == 9);

@matrix = ([7,4,3],[3,1,2],[3,0,0]);
($cost,$mapping) = assign(@matrix);
ok($cost == 9);

@matrix = ([-1,-2,-3],[-3,-3,-3],[-3,-3,-2]);
($cost,$mapping) = assign(@matrix);
ok($cost == -6);
