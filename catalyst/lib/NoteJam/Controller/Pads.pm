package NoteJam::Controller::Pads;

use Moose;
use namespace::autoclean;
use NoteJam::Form::Pad;
use HTTP::Status qw/:constants/;

BEGIN {extends 'Catalyst::Controller'}

sub auto : Private {
    my ($self, $c) = @_;
    if (!$c->user_exists) {
        $c->res->redirect($c->uri_for_action('/signin'));
        return 0;
    }
    return 1;
}

sub create : Local : Args(0) {
    my ($self, $c) = @_;
    $c->stash(
        pad      => $c->user->new_related('pads', {}),
        message  => 'Pad is successfully created',
        template => 'pads/edit.tt',
    );
    $c->detach('form');
}

sub pad : PathPrefix : Chained : CaptureArgs(1) {
    my ($self, $c, $pad_id) = @_;
    my $pad = $c->user->find_related('pads', $pad_id);
    if (!$pad) {
        $c->res->status(HTTP_NOT_FOUND);
        $c->res->body('No such pad');
        $c->detach;
    }
    $c->stash(
        pad        => $pad,
        note_count => $pad->notes->count,
    );

}

sub view : PathPart('') : Chained('pad') : Args(0) {
    my ($self, $c) = @_;
    $c->load_status_msgs;
    my $order;
    my $parm = $c->req->param('order');
    if (defined $parm && $parm =~ /\A(-?)(name|updated_at)\z/) {
        $order->{$1 eq '-' ? '-desc' : '-asc'} = $2;
    }
    $c->stash(notes => [$c->stash->{pad}->notes->search(undef, {order_by => $order})]);
}

sub edit : Chained('pad') : Args(0) {
    my ($self, $c) = @_;
    $c->stash(
        message => 'Pad is successfully updated',
    );
    $c->detach('form');
}

sub delete : Chained('pad') : Args(0) {    ## no critic (ProhibitBuiltinHomonyms)
    my ($self, $c) = @_;
    if ($c->req->method eq 'POST') {
        $c->stash->{pad}->delete;
        return $c->res->redirect(
            $c->uri_for_action('/notes/all', {mid => $c->set_status_msg('Pad is successfully deleted')}));

    }
}

sub form : Private {
    my ($self, $c) = @_;
    my $form = NoteJam::Form::Pad->new(item => $c->stash->{pad});
    if ($form->process(params => $c->req->params)) {
        return $c->res->redirect(
            $c->uri_for_action(
                '/pads/view',
                [$form->item->id],
                {mid => $c->set_status_msg($c->stash->{message})},
            )
        );
    }
    $c->stash(f => $form);
}

__PACKAGE__->meta->make_immutable;

1;
