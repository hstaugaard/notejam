package NoteJam::Controller::Notes;

use Moose;
use namespace::autoclean;
use Data::Printer;

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
    if ($c->req->param('order') =~ /\A(-?)(name|updated_at)\z/) {
        $order->{$1 eq '-' ? '-desc' : '-asc'} = $2;
    }
    $c->stash(notes => [$c->user->notes->search(undef, {order_by => $order})]);
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
