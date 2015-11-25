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
    my $form = NoteJam::Form::Note->new(ctx => $c);
    my $note = $c->user->new_related('notes', {});
    if ($form->process(item => $note, params => $c->req->params)) {
        return $c->res->redirect($c->uri_for_action(
            '/notes/notes',
            {mid => $c->set_status_msg('Note is successfully created')},
        ));
    }
    $c->stash(f => $form);
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
