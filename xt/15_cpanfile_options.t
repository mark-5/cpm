use strict;
use warnings;
use Test::More;
use xt::CLI;
use Path::Tiny ();

subtest git => sub {
    my $cpanfile = Path::Tiny->tempfile;
    $cpanfile->spew_raw(<<'___');
requires 'Distribution::Metadata', git => 'https://github.com/skaji/Distribution-Metadata.git', ref => '0.01';
requires 'File::pushd';
___
    my $r = cpm_install "--cpanfile", "$cpanfile";
    like $r->err, qr/DONE install File-pushd-/;
    my $pm = Path::Tiny->new($r->local, "lib", "perl5", "Distribution", "Metadata.pm");
    ok $pm->is_file;
    like $pm->slurp_raw, qr/0\.01/;
};

subtest dist => sub {
    my $cpanfile = Path::Tiny->tempfile;
    $cpanfile->spew_raw(<<'___');
requires 'Distribution::Metadata', dist => 'https://github.com/skaji/Distribution-Metadata/archive/0.04.tar.gz';
requires 'File::pushd';
___
    my $r = cpm_install "--cpanfile", "$cpanfile";
    like $r->err, qr/DONE install File-pushd-/;
    my $pm = Path::Tiny->new($r->local, "lib", "perl5", "Distribution", "Metadata.pm");
    ok $pm->is_file;
    like $pm->slurp_raw, qr/0\.04/;
};


done_testing;
