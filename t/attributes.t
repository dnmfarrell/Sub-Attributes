#!perl
use strict;
use warnings;

package Point;
use base 'Sub::Attributes';

sub new : ClassMethod {
  my ($class, $x, $y) = @_;
  bless { x => $x, y => $y }, $class;
}

sub add : Method {
  my ($self, $p) = @_;
  return Point->new(
    $self->{x} + $p->{x},
    $self->{y} + $p->{y},
  );
}

sub internal : Method { $_[0]->_internal }
sub _internal : Private { "hey" }

package main;
use Test::More;
use Test::Fatal;

use Sub::Attributes;pass 'module imports ok';

subtest runtime => sub {
  ok my $p1 = Point->new(3,7),  'ClassMethod ok';
  ok my $p2 = Point->new(3,7),  'ClassMethod ok';
  is ref $p1->add($p2), 'Point','Method ok';
  is ref $p2->add($p1), 'Point','Method ok';
  is $p1->internal, 'hey',      'Private ok';
};

subtest exceptions => sub {
  my $p = Point->new(3,7);
  ok exception { $p->new(1,2)  }, 'ClassMethod dies on obj call';
  ok exception { Point->add(1) },'Method dies on non-obj call';
  ok exception { $p->_internal },'Private dies on public call';
};

done_testing;
