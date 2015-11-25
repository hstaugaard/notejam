package NoteJam::Controller::Pads;

use Moose;
use namespace::autoclean;
use NoteJam::Form::Pad;

BEGIN {extends 'Catalyst::Controller'}

sub auto :Private {
    my ($self, $c) = @_;
    if (!$c->user_exists) {
        $c->res->redirect($c->uri_for_action('/signin'));
        return 0;
    }
    return 1;
}

sub create :Local :Args(0) {
    my ($self, $c) = @_;
    my $pad = $c->user->new_related('pads', {});
    my $form = NoteJam::Form::Pad->new;
    if ($form->process(item => $pad, params => $c->req->params)) {
        return $c->res->redirect($c->uri_for_action(
            '/notes/notes',
            {mid => $c->set_status_msg('Pad is successfully created')},
        ));

    }
    $c->stash(f => $form);
}

sub pad :PathPrefix :Chained :CaptureArgs(1) {
    my ($self, $c, $pad_id) = @_;
    $c->stash(pad => $c->user->find_related('pads', $pad_id));
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
