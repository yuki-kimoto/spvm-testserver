#!/usr/bin/env perl
use Mojolicious::Lite;

app->config(hypnotoad => {listen => ['http://*:10070']});

get '/' => sub {
  my $c = shift;
  $c->render(template => 'index');
};

app->start;
__DATA__

@@ index.html.ep
Test
