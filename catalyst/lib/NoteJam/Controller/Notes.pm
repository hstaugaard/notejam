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

sub all :Path('/') :Args(0) {
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
        note     => $c->user->new_related('notes', {}),
        message  => 'Note is successfully created',
        template => 'notes/edit.tt',
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
        message  => 'Note is successfully updated',
    );
    $c->detach('form');
}

sub delete :Chained('note') :Args(0) { ## no critic (ProhibitBuiltinHomonyms)
    my ($self, $c) = @_;
    if ($c->req->method eq 'POST') {
        my $note = $c->stash->{note};
        $note->delete;
        if (my $pad_id = $note->pad_id) {
            return $c->res->redirect($c->uri_for_action('/pads/view', [$pad_id]));
        } else {
            return $c->res->redirect($c->uri_for_action('/notes/all'));
        }
    }
}

sub form :Private {
    my ($self, $c) = @_;
    my $form = NoteJam::Form::Note->new(item => $c->stash->{note});
    $form->hide_field_errors(1) if $c->req->method ne 'POST'; # Don't show errors when coming from /pad/view
    if ($form->process(params => $c->req->params)) {
        my $mid = {mid => $c->set_status_msg($c->stash->{message})};
        if (my $pad_id = $form->item->pad_id) {
            return $c->res->redirect($c->uri_for_action('/pads/view', [$pad_id], $mid));
        } else {
            return $c->res->redirect($c->uri_for_action('/notes/all', $mid));
        }
    }
    $c->stash(f => $form);
}

__PACKAGE__->meta->make_immutable;

1;
