#!/usr/bin/env perl
use Mojolicious::Lite;

app->config(hypnotoad => {listen => ['http://*:10070']});

get '/' => sub {
  my $c = shift;
  $c->render(template => 'index');
};

get '/chunk/text' => sub {
  my $self = shift;

  my $file = 'resources/small.txt';
  open my $fh, '<', $file
    or die "Error";

  # Write chunk
  my $cb;
  $cb = sub {
    my $c = shift;
    my $size = 5;
    my $length = sysread($fh, my $buffer, $size);
    unless (defined $length) {
      close $fh;
      undef $cb;
      return;
    }
    $c->write_chunk($buffer, $cb);
  };
  $self->$cb;
};

get '/chunk/images' => sub {
  my $self = shift;

  my $file = 'resources/images.tar.gz';
  open my $fh, '<', $file
    or die "Error";

  # Write chunk
  $self->res->headers->content_type('application/gzip');
  $self->res->headers->content_disposition(qq/attachment; filename="$file"/);
  my $cb;
  $cb = sub {
    my $c = shift;
    my $size = 500 * 1024;
    my $length = sysread($fh, my $buffer, $size);
    unless (defined $length) {
      close $fh;
      undef $cb;
      return;
    }
    $c->write_chunk($buffer, $cb);
  };
  $self->$cb;
};

post '/echo' => sub {
  my $c = shift;
  $c->render(data => "Echo server: '" . $c->req->body . "'");
};

app->start;
__DATA__

@@ index.html.ep
Test
