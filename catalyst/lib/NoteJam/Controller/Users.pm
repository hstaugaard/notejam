package NoteJam::Controller::Users;

use Moose;
use namespace::autoclean;
use NoteJam::Form::Signin;

BEGIN {extends 'Catalyst::Controller'}

has signin_form => (
    isa     => 'NoteJam::Form::Signin',
    is      => 'ro',
    lazy    => 1,
    default => sub {NoteJam::Form::Signin->new},
);

__PACKAGE__->config(namespace => '');

sub signup :Local :Args(0) {
    my ($self, $c) = @_;
    ...
}

sub signin :Local :Args(0) {
    my ($self, $c) = @_;
    if ($self->signin_form->process(params => $c->req->params)) {
        $c->authenticate({
            email    => $self->signin_form->field('email')->value,
            password => $self->signin_form->field('password')->value,
        });
        if ($c->user_exists) {
            return $c->res->redirect($c->uri_for_action(
                '/notes/notes',
                {mid => $c->set_status_msg('You are signed in!')},
            ));
        }
        $self->signin_form->add_form_error('Wrong email or password');
    }
    $c->stash(f => $self->signin_form);
}

sub signout :Local :Args(0) {
    my ($self, $c) = @_;
    $c->logout;
    $c->res->redirect($c->uri_for_action('/signin'));
}

sub forgot_password :Path('forgot-password') :Args(0) {
    my ($self, $c) = @_;
    ...
}

sub settings :Local :Args(0) {
    my ($self, $c) = @_;
    ...
}

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;
