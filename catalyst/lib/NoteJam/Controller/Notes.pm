package NoteJam::Controller::Notes;

use Moose;
use namespace::autoclean;
use NoteJam::Form::Note;

BEGIN {extends 'Catalyst::Controller'}

sub auto :Private {
    my ($self, $c) = @_;
    if (!$c->user_exists) {
        $c->res->redirect($c->uri_for_action('/signin'));
        return 0;
    }
    return 1;
}

sub notes :Path('/') :Args(0) {
    my ($self, $c) = @_;
    $c->load_status_msgs;
    my $order;
    my $parm = $c->req->param('order');
    if (defined $parm && $parm =~ /\A(-?)(name|updated_at)\z/) {
        $order->{$1 eq '-' ? '-desc' : '-asc'} = $2;
    }
    $c->stash(notes => [$c->user->notes->search(undef, {order_by => $order})]);
}

sub create :Local :Args(0) {
    my ($self, $c) = @_;
    $c->stash(
        note    => $c->user->new_related('notes', {}),
        message => 'Note is successfully created',
    );
    $c->detach('form');
}

sub note :PathPrefix :Chained :CaptureArgs(1) {
    my ($self, $c, $note_id) = @_;
    $c->stash(note => $c->user->find_related('notes', $note_id));
}

sub view :PathPart('') :Chained('note') :Args(0) {}

sub edit :Chained('note') :Args(0) {
    my ($self, $c) = @_;
    $c->stash(
        template => 'notes/create.tt',
        message  => 'Note is successfully updated',
    );
    $c->detach('form');
}

sub delete :Chained('note') :Args(0) { ## no critic (ProhibitBuiltinHomonyms)
    my ($self, $c) = @_;
    if ($c->req->method eq 'POST') {
        $c->stash->{note}->delete;
        return $c->res->redirect($c->uri_for_action('/notes/notes'));
    }
}

sub form :Private {
    my ($self, $c) = @_;
    my $form = NoteJam::Form::Note->new(item => $c->stash->{note});
    if ($form->process(params => $c->req->params)) {
        return $c->res->redirect($c->uri_for_action(
            '/notes/notes',
            {mid => $c->set_status_msg($c->stash->{message})},
        ));
    }
    $c->stash(f => $form);
}

__PACKAGE__->meta->make_immutable;

1;
