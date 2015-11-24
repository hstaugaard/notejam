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
    if ($c->req->method eq 'POST' && $form->process(params => $c->req->params)) {
        $c->authenticate({
            email    => $form->field('email')->value,
            password => $form->field('password')->value,
        });
        return $c->res->redirect($c->uri_for_action('/notes/notes')) if $c->user_exists;
        $form->add_form_error('Wrong email or password');
    }
    $c->stash(f => $form);
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

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;
