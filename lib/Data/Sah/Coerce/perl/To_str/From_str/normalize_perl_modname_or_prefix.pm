package Data::Sah::Coerce::perl::To_str::From_str::normalize_perl_modname_or_prefix;

# AUTHOR
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

sub meta {
    +{
        v => 4,
        summary => 'Coerce perl::modname_or_prefix from str',
        prio => 50,
    };
}

sub coerce {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};

    $res->{expr_match} = "!ref($dt)";
    $res->{expr_coerce} = join(
        "",
        "do { my \$tmp = $dt; \$tmp = \$1 if \$tmp =~ m!\\A(\\w+(?:/\\w+)*)\.pm\\z!; \$tmp =~ s!::?|/|\\.|-!::!g; \$tmp }",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|coerce)$

=head1 DESCRIPTION

This rule can normalize strings in the form of:

 Foo::Bar
 Foo:Bar
 Foo-Bar
 Foo/Bar
 Foo/Bar.pm
 Foo.Bar

into `Foo::Bar`, while normalizing strings in the form of:

 Foo:Bar:
 Foo-Bar-
 Foo/Bar/
 Foo.Bar.

into:

 Foo::Bar::
