package NoteJam::Form::Signin;

use HTML::FormHandler::Moose;
use namespace::autoclean;
use Moose::Util::TypeConstraints;

extends 'HTML::FormHandler';
with 'NoteJam::Form::Defaults';

has authenticator => (
    isa      => duck_type([qw/authenticate user_exists/]),
    is       => 'ro',
    required => 1,
);

has_field email => (
    type => 'Email',
);
has_field password => (
    type => 'Password',
);

sub validate {
    my $self = shift;
    return if $self->has_errors; # Only check if fields are valid
    $self->authenticator->authenticate({
        email    => $self->field('email')->value,
        password => $self->field('password')->value,
    });
    if (!$self->authenticator->user_exists) {
        $self->add_form_error('Wrong email or password');
    }
}

1;
