package NoteJam::Controller::Users;

use Moose;
use namespace::autoclean;
use NoteJam::Form::Signin;
use NoteJam::Form::Settings;
use NoteJam::Form::Signup;
use NoteJam::Form::ForgotPassword;
use App::Genpass;

BEGIN {extends 'Catalyst::Controller'}

has password_generator => (
    is       => 'ro',
    init_arg => undef,
    lazy     => 1,
    handles  => {random_password => [generate => 1]},
    default  => sub {App::Genpass->new(readable => 1, length => 8)},
);

__PACKAGE__->config(namespace => '');

sub signup : Local : Args(0) {
    my ($self, $c) = @_;
    my $form = NoteJam::Form::Signup->new(user_model => $c->model);
    if ($form->process(params => $c->req->params)) {
        $c->model->create(
            {
                email    => $form->field('email')->value,
                password => $form->field('password')->value,
            }
        );
        return $c->res->redirect(
            $c->uri_for_action(
                '/signin',
                {mid => $c->set_status_msg('Account is created. Now you can sign in.')},
            )
        );
    }
    $c->stash(f => $form);
}

sub signin : Local : Args(0) {
    my ($self, $c) = @_;
    $c->load_status_msgs;
    my $form = NoteJam::Form::Signin->new(authenticator => $c);
    if ($form->process(params => $c->req->params, posted => ($c->req->method eq 'POST'))) {
        return $c->res->redirect(
            $c->uri_for_action(
                '/notes/all',
                {mid => $c->set_status_msg('You are signed in!')},
            )
        );
    }
    $c->stash(f => $form);
}

sub signout : Local : Args(0) {
    my ($self, $c) = @_;
    $c->logout;
    $c->res->redirect($c->uri_for_action('/signin'));
}

sub forgot_password : Path('forgot-password') : Args(0) {
    my ($self, $c) = @_;
    my $form = NoteJam::Form::ForgotPassword->new(user_model => $c->model);
    if ($form->process(params => $c->req->params)) {
        my $email    = $form->field('email')->value;
        my $password = $self->random_password;
        $c->model->update_password($email, $password);
        $c->stash(
            email => {
                to      => $email,
                from    => 'from@notejam.com',
                subject => 'Notejam password reset',
                body    => "Hi, $email. Your new password is $password.",
            }
        );
        $c->forward($c->view('Email'));
        return $c->res->redirect(
            $c->uri_for_action(
                '/signin',
                {mid => $c->set_status_msg('New password is sent in your email inbox.')},
            )
        );
    }
    $c->stash(f => $form);
}

sub settings : Local : Args(0) {
    my ($self, $c) = @_;
    my $form = NoteJam::Form::Settings->new(user => $c->user);
    if ($form->process(params => $c->req->params)) {
        $c->user->update({password => $form->field('new_password')->value});
        return $c->res->redirect(
            $c->uri_for_action(
                '/notes/all',
                {mid => $c->set_status_msg('Password is successfully changed')},
            )
        );
    }
    $c->stash(f => $form);
}

sub end : ActionClass('RenderView') { }

__PACKAGE__->meta->make_immutable;

1;
