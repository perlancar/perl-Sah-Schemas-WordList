package Sah::Schema::perl::wordlist::modname;

use strict;

# AUTHORITY
# DATE
# DIST
# VERSION

our $schema = ['str' => {
    summary => 'Perl WordList::* module name without the prefix, e.g. EN::Enable',
    description => <<'_',

Contains coercion rule so you can also input `Foo-Bar`, `Foo/Bar`, `Foo/Bar.pm`
or even 'Foo.Bar' and it will be normalized into `Foo::Bar`.

_
    match => '\A[A-Za-z_][A-Za-z_0-9]*(::[A-Za-z_0-9]+)*\z',

    'x.perl.coerce_rules' => [
        'From_str::normalize_perl_modname',
    ],

    # provide a default completion which is from list of installed perl modules
    'x.completion' => ['perl_modname', {ns_prefix=>'WordList'}],

    examples => [
        {value=>'', valid=>0},
        {value=>'EN/Enable', valid=>1, validated_value=>'EN::Enable'},
        {value=>'Foo bar', valid=>0},
    ],

}, {}];

1;
# ABSTRACT:
