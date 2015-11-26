package NoteJam::Controller::Users;

use Moose;
use namespace::autoclean;
use NoteJam::Form::Signin;
use NoteJam::Form::Settings;
use NoteJam::Form::Signup;

BEGIN {extends 'Catalyst::Controller'}

__PACKAGE__->config(namespace => '');

sub signup :Local :Args(0) {
    my ($self, $c) = @_;
    my $form = NoteJam::Form::Signup->new(user_model => $c->model('NoteJam::User'));
    if ($form->process(params => $c->req->params)) {
        $c->model('NoteJam::User')->create({
            email    => $form->field('email')->value,
            password => $form->field('password')->value,
        });
        return $c->res->redirect($c->uri_for_action(
            '/signin',
            {mid => $c->set_status_msg('Account is created. Now you can sign in.')},
        ));
    }
    $c->stash(f => $form);
}

sub signin :Local :Args(0) {
    my ($self, $c) = @_;
    $c->load_status_msgs;
    my $form = NoteJam::Form::Signin->new(authenticator => $c);
    if ($form->process(params => $c->req->params, posted => ($c->req->method eq 'POST'))) {
        return $c->res->redirect($c->uri_for_action(
            '/notes/all',
            {mid => $c->set_status_msg('You are signed in!')},
        ));
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
    my $form = NoteJam::Form::Settings->new(user => $c->user);
    if ($form->process(params => $c->req->params)) {
        $c->user->update({password => $form->field('new_password')->value});
        return $c->res->redirect($c->uri_for_action(
            '/notes/all',
            {mid => $c->set_status_msg('Password is successfully changed')},
        ));
    }
    $c->stash(f => $form);
}

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;
