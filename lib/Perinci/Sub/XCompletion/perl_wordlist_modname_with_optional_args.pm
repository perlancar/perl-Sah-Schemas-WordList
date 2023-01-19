package Perinci::Sub::XCompletion::perl_wordlist_modname_with_optional_args;

use 5.010001;
use strict;
use warnings;
use Log::ger;

# AUTHORITY
# DATE
# DIST
# VERSION

sub gen_completion {
    my %gcargs = @_;

    sub {
        no strict 'refs'; ## no critic: TestingAndDebugging::ProhibitNoStrict

        my %cargs = @_;

        my $word = $cargs{word};

        my ($word_mod, $word_eq, $word_modargs) = $word =~ /\A([^=,]*)([=,])?(.*?)\z/;
        #log_trace "TMP: word_mod, word_eq, word_modargs = %s, %s, %s", $word_mod, $word_eq, $word_modargs;

        unless ($word_eq) {
            require Complete::Module;
            my $modres = Complete::Module::complete_module(
                word => $word_mod,
                ns_prefix => "WordList::",
                recurse => 1,
            );

            # no module matches, we can't complete
            return [] unless @{ $modres->{words} };

            # multiple module matches, we also don't complete args, just the modules
            return $modres if @{ $modres->{words} } > 1;

            # normalize the module part
            $word_mod = ref $modres->{words}[0] eq 'HASH' ? $modres->{words}[0]{word} : $modres->{words}[0];

            # to start args we use "," by default instead of "=" because "=" is
            # problematic in bash completion because it is used as a
            # word-breaking character by default (along with @><;|&(:
            $word_eq = ",";
        }

        (my $wl_module = $word_mod) =~ s![/.]!::!g;

        my $module = "WordList::$wl_module";
        (my $module_pm = "$module.pm") =~ s!::!/!g;
        eval { require $module_pm; 1 };
        do { log_trace "Can't load module $module: $@. Skipped checking for arguments"; return [$word_mod] } if $@;

        my $params = \%{"$module\::PARAMS"};
        do { log_trace "Module $module does not define params"; return [$word_mod] } unless keys %$params;

        my @wlparams = sort keys %$params;
        my @wlparams_summaries = map { $params->{$_}{summary} } @wlparams;
        require Complete::Util;
        my $ccsp_res = Complete::Util::complete_comma_sep_pair(
            word => $word_modargs,
            keys => \@wlparams,
            keys_summaries => \@wlparams_summaries,
            complete_value => sub {
                my %cvargs = @_;
                my $key = $cvargs{key};
                return [] unless $params->{$key};
                return [] unless $params->{$key}{schema};

                require Perinci::Sub::Complete;
                Perinci::Sub::Complete::complete_from_schema(
                    word => $cvargs{word},
                    schema => $params->{$key}{schema},
                );
            },
        );
        Complete::Util::modify_answer(answer => $ccsp_res, prefix => "$word_mod$word_eq");
    },
}

1;
# ABSTRACT: Generate completion for WordList::* module name with optional params

=for Pod::Coverage ^(gen_completion)$

=head1 SYNOPSIS

To use, put this in your L<Sah> schema's C<x.completion> attribute:

 'x.completion' => ['perl_wordlist_modname_with_optional_args'],

=cut
