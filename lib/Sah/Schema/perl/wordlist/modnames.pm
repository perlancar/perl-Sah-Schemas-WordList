package Sah::Schema::perl::wordlist::modnames;

# AUTHORITY
# DATE
# DIST
# VERSION

our $schema = [array => {
    summary => 'Array of Perl WordList::* module names without the prefix, e.g. ["EN::Enable", "EN::BIP39"]',
    description => <<'_',

Array of Perl WordList::* module names, where each element is of
`perl::wordlist::modname` schema, e.g. `EN::Enable`, `EN::BIP39`.

Contains coercion rule that expands wildcard, so you can specify:

    EN::*

and it will be expanded to e.g.:

    ["EN::Enable", "EN::BIP39"]

The wildcard syntax supports jokers (`?`, `*`, `**`), brackets (`[abc]`), and
braces (`{one,two}`). See <pm:Module::List::Wildcard> for more details.

_
    of => ["perl::wordlilst::modname", {req=>1}, {}],

    'x.perl.coerce_rules' => [
        ['From_str_or_array::expand_perl_modname_wildcard', {ns_prefix=>'WordList'}],
    ],

    # provide a default completion which is from list of installed perl modules
    'x.element_completion' => ['perl_modname', {ns_prefix=>'WordList'}],

}, {}];

1;
# ABSTRACT:
