package NoteJam::Controller::Pads;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'}

sub auto :Private {
    my ($self, $c) = @_;
    return $c->res->redirect($c->uri_for_action('/users/signin')) unless $c->user_exists;
}

sub create :Local :Args(0) {
    my ($self, $c) = @_;
    ...
}

sub pad :PathPrefix :Chained :CaptureArgs(1) {
    my ($self, $c) = @_;
    ...
}

sub view :PathPart('') :Chained('pad') :Args(0) {
    my ($self, $c) = @_;
    ...
}

sub edit :Chained('pad') :Args(0) {
    my ($self, $c) = @_;
    ...
}

sub delete :Chained('pad') :Args(0) { ## no critic (ProhibitBuiltinHomonyms)
    my ($self, $c) = @_;
    ...
}

__PACKAGE__->meta->make_immutable;

1;
