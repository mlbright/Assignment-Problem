use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Graph::Matching',
    AUTHOR              => 'Joris van Rantwijk <jorispubl@xs4all.nl>',
    VERSION_FROM        => 'lib/Graph/Matching.pm',
    ABSTRACT_FROM       => 'lib/Graph/Matching.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Graph-Matching-*' },
);
