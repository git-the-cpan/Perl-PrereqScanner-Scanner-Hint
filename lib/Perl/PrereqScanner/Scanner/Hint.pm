#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#   file: lib/Perl/PrereqScanner/Scanner/Hint.pm
#

#pod =encoding UTF-8
#pod
#pod =head1 COPYRIGHT AND LICENSE
#pod
#pod Copyright © 2015 Van de Bugger
#pod
#pod This file is part of perl-Perl-PrereqScanner-Scanner-Hint.
#pod
#pod perl-Perl-PrereqScanner-Scanner-Hint is free software: you can redistribute it and/or modify it
#pod under the terms of the GNU General Public License as published by the Free Software Foundation,
#pod either version 3 of the License, or (at your option) any later version.
#pod
#pod perl-Perl-PrereqScanner-Scanner-Hint is distributed in the hope that it will be useful, but
#pod WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
#pod PARTICULAR PURPOSE. See the GNU General Public License for more details.
#pod
#pod You should have received a copy of the GNU General Public License along with
#pod perl-Perl-PrereqScanner-Scanner-Hint. If not, see <http://www.gnu.org/licenses/>.
#pod
#pod =cut

#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#pod =for :this This is C<Perl::PrereqScanner::Scanner::Hint> module documentation. Read this if you are going to hack or
#pod extend C<Manifest::Write>.
#pod
#pod =for :those If you want to specify implicit prerequisites directly in your Perl code, read the L<user manual|Perl::PrereqScanner::Scanner::Hint::Manual>.
#pod General topics like getting source, building, installing, bug reporting and some others are covered
#pod in the F<README>.
#pod
#pod =for test_synopsis my $path;
#pod
#pod =head1 SYNOPSIS
#pod
#pod     use Perl::PrereqScanner;
#pod     my $scanner = Perl::PrereqScanner->new( {
#pod         extra_scanners => [ qw{ Hint } ],
#pod     } );
#pod     my $prereqs = $scanner->scan_file( $path );
#pod
#pod =head1 DESCRIPTION
#pod
#pod TODO
#pod
#pod =cut

package Perl::PrereqScanner::Scanner::Hint;

use Moose;
use namespace::autoclean;

# ABSTRACT: Plugin for C<Perl::PrereqScanner> looking for C<# REQUIRE:> comments
our $VERSION = 'v0.0.0_01'; # TRIAL VERSION

use Module::Runtime qw{ is_module_name };
use Try::Tiny;

with 'Perl::PrereqScanner::Scanner';

# --------------------------------------------------------------------------------------------------

my $error = sub {
    my ( $what, $elem ) = @_;
    my ( undef, undef, undef, $line, $file ) = @{ $elem->location };
    chomp( $what );
    if ( not defined( $file ) ) {
        $file = '(*UNKNOWN*)';
    };
    die "$what at $file line $line.\n";
};

# --------------------------------------------------------------------------------------------------

#pod =method scan_for_prereqs
#pod
#pod TODO
#pod
#pod =cut

sub scan_for_prereqs {
    my ( $self, $doc, $req ) = @_;
    my $comments = $doc->find( 'Token::Comment' ) || [];
    for my $comment ( @$comments ) {
        if ( $comment->content =~ m{ ^ \s* \# \s* REQUIRES? \s* : \s* (.*) \s* $ }x ) {
            my $requirement = $1;
            $requirement =~ s{ \s* \# .* \z }{}x;  # Strip trailing comment, if any.
            my ( $mod, $ver ) = ( split( m{\s+}x, $requirement, 2 ), '0' );
            if ( is_module_name( $mod ) ) {
                try {
                    $req->add_string_requirement( $mod, $ver );
                } catch {
                    my $ex = $_;
                    $error->( "$ex", $comment );
                };
            } else {
                $error->( "'$mod' is not a valid module name", $comment );
            };
        };
    };
    return;
};

# --------------------------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

1;

# --------------------------------------------------------------------------------------------------

#pod =pod
#pod
#pod =encoding UTF-8
#pod
#pod =head1 WHAT?
#pod
#pod C<Perl::PrereqScanner::Scanner::Hint> (or just C<Scanner::Hint> for brevity) is a plugin for C<Perl::PrereqScanner>
#pod tool. C<Scanner::Hint> looks for C<# REQUIRE: I<ModuleName> I<VersionRange>> comments in the code.
#pod
#pod =cut


# end of file #

__END__

=pod

=encoding UTF-8

=head1 NAME

Perl::PrereqScanner::Scanner::Hint - Plugin for C<Perl::PrereqScanner> looking for C<# REQUIRE:> comments

=head1 VERSION

Version v0.0.0_01, released on 2015-10-21 23:22 UTC.
This is a B<trial release>.

=head1 WHAT?

C<Perl::PrereqScanner::Scanner::Hint> (or just C<Scanner::Hint> for brevity) is a plugin for C<Perl::PrereqScanner>
tool. C<Scanner::Hint> looks for C<# REQUIRE: I<ModuleName> I<VersionRange>> comments in the code.

This is C<Perl::PrereqScanner::Scanner::Hint> module documentation. Read this if you are going to hack or
extend C<Manifest::Write>.

If you want to specify implicit prerequisites directly in your Perl code, read the L<user manual|Perl::PrereqScanner::Scanner::Hint::Manual>.
General topics like getting source, building, installing, bug reporting and some others are covered
in the F<README>.

=head1 SYNOPSIS

    use Perl::PrereqScanner;
    my $scanner = Perl::PrereqScanner->new( {
        extra_scanners => [ qw{ Hint } ],
    } );
    my $prereqs = $scanner->scan_file( $path );

=head1 DESCRIPTION

TODO

=head1 OBJECT METHODS

=head2 scan_for_prereqs

TODO

=for test_synopsis my $path;

=head1 AUTHOR

Van de Bugger <van.de.bugger@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright © 2015 Van de Bugger

This file is part of perl-Perl-PrereqScanner-Scanner-Hint.

perl-Perl-PrereqScanner-Scanner-Hint is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free Software Foundation,
either version 3 of the License, or (at your option) any later version.

perl-Perl-PrereqScanner-Scanner-Hint is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
perl-Perl-PrereqScanner-Scanner-Hint. If not, see <http://www.gnu.org/licenses/>.

=cut
