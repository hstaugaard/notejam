package NoteJam::Controller::Notes;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'}

sub auto :Private {
    my ($self, $c) = @_;
    $c->log->debug('USER: ' . $c->user);
    if (!$c->user_exists) {
        $c->res->redirect($c->uri_for_action('/signin')) unless $c->user_exists;
        $c->detach;
    }
}

sub create :Local :Args(0) {
    my ($self, $c) = @_;
    ...
}

sub note :PathPrefix :Chained :CaptureArgs(1) {
    my ($self, $c) = @_;
    ...
}

sub view :PathPart('') :Chained('note') :Args(0) {
    my ($self, $c) = @_;
    ...
}

sub edit :Chained('note') :Args(0) {
    my ($self, $c) = @_;
    ...
}

sub delete :Chained('note') :Args(0) { ## no critic (ProhibitBuiltinHomonyms)
    my ($self, $c) = @_;
    ...
}

__PACKAGE__->meta->make_immutable;

1;
