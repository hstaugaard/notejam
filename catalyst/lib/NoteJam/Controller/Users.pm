package NoteJam::Controller::Users;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'}

__PACKAGE__->config(namespace => '');

sub signup :Local :Args(0) {
    my ($self, $c) = @_;
    ...
}

sub signin :Local :Args(0) {
    my ($self, $c) = @_;
}

sub signout :Local :Args(0) {
    my ($self, $c) = @_;
    ...
}

sub forgot_password :Path('forgot-password') :Args(0) {
    my ($self, $c) = @_;
    ...
}

sub settings :Local :Args(0) {
    my ($self, $c) = @_;
    ...
}

__PACKAGE__->meta->make_immutable;

1;
