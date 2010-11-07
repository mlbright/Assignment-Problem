package Algorithm::Kuhn::Munkres;

use warnings;
use strict;
use Carp;
use List::Util qw( sum );
use base 'Exporter';
our @EXPORT_OK = qw( max_weight_perfect_matching assign );
our $VERSION = '0.0.3';

my $N;
my %S;
my %T;
my @labels_u;
my @labels_v;
my @min_slack;
my %matching_u;
my %matching_v;
my @weights;


sub _improve_labels {
    my ($val) = @_;

    foreach my $u (keys %S) {
        $labels_u[$u] -= $val;
    }

    for (my $v = 0; $v < $N; $v++) {
        if (exists($T{$v})) {
            $labels_v[$v] += $val;
        } else {
            $min_slack[$v]->[0] -= $val;
        }
    }
}

sub _improve_matching {
    my ($v) = @_;
    my $u = $T{$v};
    if (exists($matching_u{$u})) {
        _improve_matching($matching_u{$u});
    }
    $matching_u{$u} = $v;
    $matching_v{$v} = $u;
}

sub _slack {
    my ($u,$v) = @_;
    my $val = $labels_u[$u] + $labels_v[$v] - $weights[$u][$v];
    return $val;
}

sub _augment {

    while (1) {
        my ($val, $u, $v);
        for (my $x = 0; $x < $N; $x++) {
            if (!exists($T{$x})) {
                if (!defined($val) || ($min_slack[$x]->[0] < $val)) {
                    $val = $min_slack[$x]->[0]; 
                    $u = $min_slack[$x]->[1];
                    $v = $x;
                }
            }
        }
        die "wtf" if (!exists($S{$u}));
        if ($val > 0) {
            _improve_labels($val);
        }
        die "wtf2" if (_slack($u,$v) != 0);
        $T{$v} = $u;
        if (exists($matching_v{$v})) {
            my $u1 = $matching_v{$v};
            die "wtf3" if (exists($S{$u1}));
            $S{$u1} = 1;
            for (my $x = 0; $x < $N; $x++) {
                my $s = _slack($u1,$x);
                if (!exists($T{$x}) && $min_slack[$x]->[0] > $s) {
                    $min_slack[$x] = [$s, $u1];
                }
            }                 
        } else {
            _improve_matching($v);
            return;
        }
    }

}

sub max_weight_perfect_matching {

    @weights = @_;
    $N = scalar @weights;
    for (my $i = 0; $i < $N; $i++) {
        $labels_v[$i] = 0;    
    }
    for (my $i = 0; $i < $N; $i++) {
        my $max = 0;
        for (my $j = 0; $j < $N; $j++) {
            if ($weights[$i][$j] > $max) {
                $max = $weights[$i][$j];
            }        
        }
        $labels_u[$i] = $max;
    }    


    while ($N > scalar keys %matching_u) {
        my $free;
        for (my $x = 0; $x < $N; $x++) {
            if (!exists($matching_u{$x})) {
                $free = $x;
                last;
            }                         
        }

        %S = ($free => 1);
        %T = ();
        @min_slack = ();
        for (my $i = 0; $i < $N; $i++) {
            my $x = [_slack($free,$i), $free];
            push @min_slack, $x;
        }
        _augment();
    }

    my $val = sum(@labels_u) + sum(@labels_v);
    return ($val, \%matching_u);

}

sub assign {
    max_weight_perfect_matching(@_);
}

1; # Magic true value required at end of module
__END__

=head1 NAME

Algorithm::Kuhn::Munkres - Determining the maximum weight perfect matching in a weighted complete bipartite graph


=head1 VERSION

This document describes Algorithm::Kuhn::Munkres version 0.0.3


=head1 SYNOPSIS

    use Algorithm::Kuhn::Munkres;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
Algorithm::Kuhn::Munkres requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-algorithm-kuhn-munkres@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Martin-Louis Bright  C<< <mlbright@gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Martin-Louis Bright C<< <mlbright@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
