package NoteJam::Controller::Users;

use Moose;
use namespace::autoclean;
use NoteJam::Form::Signin;

BEGIN {extends 'Catalyst::Controller'}

__PACKAGE__->config(namespace => '');

sub signup :Local :Args(0) {
    my ($self, $c) = @_;
    ...
}

sub signin :Local :Args(0) {
    my ($self, $c) = @_;
    my $form = NoteJam::Form::Signin->new;
    if ($form->process(params => $c->req->params)) {
        $c->authenticate({
            email    => $form->field('email')->value,
            password => $form->field('password')->value,
        });
        if ($c->user_exists) {
            return $c->res->redirect($c->uri_for_action(
                '/notes/notes',
                {mid => $c->set_status_msg('You are signed in!')},
            ));
        }
        $form->add_form_error('Wrong email or password');
    }
    $c->stash(f => $form);
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
