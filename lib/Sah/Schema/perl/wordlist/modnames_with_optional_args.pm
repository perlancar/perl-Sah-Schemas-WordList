package Sah::Schema::perl::wordlist::modnames_with_optional_args;

use strict;

# AUTHORITY
# DATE
# DIST
# VERSION

our $schema = [array => {
    summary => 'Array of Perl WordList::* module names without the prefix, with optional args, e.g. ["EN::Enable", "MetaSyntactic::Any=theme,dangdut"]',
    description => <<'_',

Array of Perl WordList::* module names without the prefix and with optional
args. Each element is of `perl::modname` schema, e.g. `EN::Enable`,
`MetaSyntactic::Any=theme,dangdut`.

Contains coercion rule that expands wildcard, so you can specify:

    ID::*

and it will be expanded to e.g.:

    ["ID::KBBI", "ID::PERLANCAR"]

The wildcard syntax supports jokers (`?`, `*`, `**`), brackets (`[abc]`), and
braces (`{one,two}`). See <pm:Module::List::Wildcard> for more details.

_
    of => ["perl::wordlist::modname_with_optional_args", {req=>1}],

    'x.perl.coerce_rules' => [
        ['From_str_or_array::expand_perl_modname_wildcard', {ns_prefix=>'WordList'}],
    ],

    # provide a default completion which is from list of installed perl modules
    'x.element_completion' => ['perl_wordlist_modname_with_optional_args'],

}];

1;
# ABSTRACT:
