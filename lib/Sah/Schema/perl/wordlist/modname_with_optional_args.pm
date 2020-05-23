package Sah::Schema::perl::wordlist::modname_with_optional_args;

# AUTHORITY
# DATE
# DIST
# VERSION

our $schema = [str => {
    summary => 'Perl WordList::* module name without the prefix (e.g. EN::Enable) with optional arguments (e.g. MetaSyntactic::Any=theme,dangdut)',
    description => <<'_',

Perl WordList::* module name without the prefix, with optional arguments which
will be used as import arguments, just like the `-MMODULE=ARGS` shortcut that
`perl` provides. Examples:

    EN::Enable
    MetaSyntactic::Any=theme,dangdut

See also: `perl::wordlist::modname`.

_
    match => '\A[A-Za-z_][A-Za-z_0-9]*(::[A-Za-z_0-9]+)*(?:=.*)?\z',

    'x.perl.coerce_rules' => [
        ['From_str::normalize_perl_modname', {ns_prefix=>'WordList'}],
    ],

    # XXX also provide completion for arguments
    'x.completion' => ['perl_modname', {ns_prefix=>'WordList'}],

}, {}];

1;
# ABSTRACT:
