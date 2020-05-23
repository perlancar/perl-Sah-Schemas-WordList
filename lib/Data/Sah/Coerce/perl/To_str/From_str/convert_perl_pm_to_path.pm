package Data::Sah::Coerce::perl::To_str::From_str::convert_perl_pm_to_path;

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
        summary => 'Convert module name existing in @INC to its filesystem path',
        prio => 50,
    };
}

sub coerce {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};

    $res->{modules}{'Module::Path::More'} //= {version=>0, core=>0, pp=>1};
    $res->{expr_match} = "1";
    $res->{expr_coerce} = join(
        "",
        "do { ",
        "my \$_sahc_orig = $dt; ",
        "if (\$_sahc_orig =~ m!\\A\\w+((?:/|::)\\w+)*(?:\\.pm)?\\z!) {",
        "  (my \$tmp = \$_sahc_orig) =~ s!/!::!g; my \$ext; \$tmp =~ s/\\.(pm)\\z// and \$ext = \$1;",
        "  Module::Path::More::module_path(module=>\$tmp, find_pm=>!\$ext || \$ext eq 'pm', find_pod=>0, find_prefix=>0, find_pmc=>0) || \$_sahc_orig ",
        "} else {",
        "  \$_sahc_orig ",
        "} ",
        "}",
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|coerce)$

=head1 DESCRIPTION

This rule can convert strings in the form of:

 Foo::Bar
 Foo/Bar
 Foo/Bar.pm

into the filesystem path (e.g.
C</home/ujang/perl5/perlbrew/perls/perl-5.24.0/lib/site_perl/5.24.0/Foo/Bar.pm>)
when the module exists in C<@INC>. Otherwise, it leaves the string as-is.
