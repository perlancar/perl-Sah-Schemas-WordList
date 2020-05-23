package Data::Sah::Coerce::perl::To_array::From_str_or_array::expand_perl_modname_wildcard;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

sub meta {
    +{
        v => 4,
        summary => 'Expand wildcard of Perl module names',
        prio => 50,
        args => {
            ns_prefix => {
                schema => 'str*',
            },
        },
    };
}

sub coerce {
    require Data::Dmp;

    my %cargs = @_;

    my $dt = $cargs{data_term};
    my $gen_args = $cargs{args};

    my $ns_prefix = $gen_args->{ns_prefix};
    if (defined $ns_prefix) {
        $ns_prefix .= "::" unless $ns_prefix =~ /::\z/;
    }

    my $res = {};
    $res->{expr_match} = "ref($dt) eq '' || ref($dt) eq 'ARRAY'";
    $res->{modules}{"PERLANCAR::Module::List"} //= "0.004002";
    $res->{modules}{"String::Wildcard::Bash"} //= "0.040";
    $res->{expr_coerce} = join(
        "",
        "do { ",
        "my \$tmp = $dt; \$tmp = [\$tmp] unless ref \$tmp eq 'ARRAY'; ",
        "my \$i = 0; ",
        "while (\$i < \@\$tmp) { ",
        "  \$tmp->[\$i] =~ s!/!::!g; ",
        "  my \$el = \$tmp->[\$i++]; ",
        "  next unless String::Wildcard::Bash::contains_wildcard(\$el); ",
        "  my \$mods = PERLANCAR::Module::List::list_modules(" . (defined($ns_prefix) ? Data::Dmp::dmp($ns_prefix) . " . " : "") . "\$el, {wildcard=>1, list_modules=>1}); ",
        "  my \@mods = sort keys \%\$mods; ",
        (defined($ns_prefix) ? "  for (\@mods) { substr(\$_, 0, ".length($ns_prefix).") = '' } " : ""),
        "  if (\@mods) { splice \@\$tmp, \$i-1, 1, \@mods; \$i += \@mods - 1 } ",
        "} ", # while
        "\$tmp ",
        "}", # do
    );

    $res;
}

1;
# ABSTRACT:

=for Pod::Coverage ^(meta|coerce)$

=head1 DESCRIPTION

This rule can expand wildcard of Perl module names in string (or string elements
in array) into array. Example:

 "Module::P*"
 ["Foo", "Module::P*", "Bar"]

will become, respectively:

 ["Module::Patch", "Module::Path", "Module::Pluggable"]
 ["Foo", "Module::Patch", "Module::Path", "Module::Pluggable", "Bar"]

when a string does not contain wildcard pattern, or if a pattern fails to match
any module name, it will be left unchanged, e.g.:

 ["Foo", "Fizz*", "Bar"]

will become, respectively:

 ["Foo", "Fizz*", "Bar"]

Additionally, for convenience, it also replaces "/" to "::", so:

 "Module/P*"

will also become:

 ["Module::Patch", "Module::Path", "Module::Pluggable"]


=head1 SEE ALSO

L<Data::Sah::Coerce::perl::To_str::From_str::NormalizePerlModname>

L<Data::Sah::Coerce::perl::To_array::From_str_or_array::ExpandPerlModprefixWildcard>
