package App::cpm::Resolver;
use strict;
use warnings;
our $VERSION = '0.201';
1;
__END__

=head1 NAME

App::cpm::Resolver - resolving everything

=head1 SYNOPSIS

Prepare your resolver first:

  # resolver.pl
  package Your::Custom::Resolver {
    sub new {
      bless {}, shift;
    }

    # resolver **must** implement resolve method
    sub resolve {
      my ($self, $job) = @_;
      # $job = { package => "Your::Module", version => "> 1.00, < 2.00" }

      retrun {
        source => "git",
        uri => "git://github.com/you/Your-Module.git",
        ref => "develop",
        version => "1.52",
        package => "Your::Module",
      };
    }
  }

  use App::cpm::Resolver::Cascade;
  use App::cpm::Resolver::MetaDB;
  my $cascade = App::cpm::Resolver::Cascade->new;
  $cascade->add(Your::Custom::Resolver->new); # resolve dist with your resolver first
  $cascade->add(App::cpm::Resolver::MetaDB->new); # fallback to normal resolver
  return $cascade

Then you can install Your::Module with cpm.

  > cpm install --custom-resolver resolver.pl Your::Module

=head1 DESCRIPTION

It seems that "resolving distribution names/locations via 02packages.details.txt"
and "fetching distributions via cpan" are de facto standards,
and a lot of cpan clients and cpan local mirror (darkpan) follow that convention (or fake that convention).

But people sometimes want more flexible cpan clients / darkpans.

For example, people want to resolve distribution names/locations via:

=over 4

=item *

02packages.details.txt in remote or local

=item *

cpanmetadb

=item *

metacpan v1 download url API

=item *

your custom API (http server)

=item *

your custom file format

=item *

arbitrary db (elasticsearch, mysql, sqlite, PostgreSQL, etc)

=back

and want to fetch distributions via:

=over 4

=item *

cpan (www.cpan.org, etc)

=item *

metacapn

=item *

backpan

=item *

arbitrary http server

=item *

remote git repository (such as github.com)

=item *

remote svn repository

=item *

local tar.gz

=item *

local directory

=back

Now cpm has not only the following resolvers

=over 4

=item *

App::cpm::Resolver::MetaDB

=item *

App::cpm::Resolver::MetaCPAN

=item *

App::cpm::Resolver::O2Packages

=item *

App::cpm::Resolver::Snapshot

=item *

App::cpm::Resolver::Cascade

=back

but also C<--custom-resolver> option so that you can use your own resolver.

=head1 SEE ALSO

L<Menlo>

L<CPAN::Common::Index>

L<Plack::App::Cascade>

L<App::CPANIDX>

L<App::opan>

=cut