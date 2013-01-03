#!/usr/bin/perl -w
package AI::MicroStructure::Deamon;

use strict;
use utf8;
use File::Spec;
use AI::MicroStructure;
use JSON::XS;


binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';

# Library path bootstrap
my @path;
if (defined $ENV{PAR_TEMP}) { # See PAR.pm
	@path = ($ENV{PAR_TEMP}, 'inc');
}
else {
	my $binary = File::Spec->rel2abs($0);
	my ($vol, $dirs, undef) = File::Spec->splitpath($binary);
	@path = ($vol, $dirs, File::Spec->updir);
}
my $libdir = File::Spec->catdir(@path, 'lib');
unshift @INC, $libdir if -d $libdir;

# Load modules needed in this script

eval q/
	use File::BaseDir qw(config_files);

	use AI::MicroStructure::Cache;
	use AI::MicroStructure::Relations;
/;
die $@ if $@;

for (qw/LC_ALL LC_MESSAGES LANGUAGE LANG/) {
	next unless $ENV{$_};
#	$micro::LANG = $ENV{$_};
	last;
}
#$micro::LANG =~ s/[\.\@].*//; # remove encoding / modifier
#$micro::LANG = '' if $micro::LANG eq 'C' or $micro::LANG eq 'POSIX';
  

utf8::decode($_) for @ARGV;
push @ARGV,"ufo" unless(@ARGV);#sprintf("%s",`micro ufo`);


use Data::Dumper;
my $cache = {};
my $new = AI::MicroStructure::Relations->new();
$new->{scale} = 0.1;
#my $page_iter = iterate(\&gofor,[map{$_=sprintf("http://en.wikipedia.org/wiki/%s",$_)}@ARGV]);
#print Dumper [iterate(\&fetch,[$urls[0]])];

foreach(@ARGV)  
{
  $new->gofor($_);#
}


#die(ref $new->{storage});
$new->{storage}->{data} = $new->inspect($new->{scale});

my $sense = JSON::XS->new->pretty(1)->allow_blessed($new->{storage});

#foreach(keys %{$self->{storage}->{data}}){

#}
print Dumper $new->{storage}->{data}->{dominant};#sort {$a cmp $b}$new->{storage}->{dominant};


1;
__DATA__
use Parallel::Iterator qw( iterate );
use LWP::UserAgent;

our $ua = LWP::UserAgent->new;
 

           sub fetch {
               my $url = shift;
               my $resp = $ua->get($url);
               return unless $resp->is_success;
               return  $resp->content;
           };


# ABSTRACT: turns baubles into trinkets
