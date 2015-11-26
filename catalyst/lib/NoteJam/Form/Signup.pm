package NoteJam::Form::Signup;

use HTML::FormHandler::Moose;
use namespace::autoclean;
use Moose::Util::TypeConstraints;

extends 'HTML::FormHandler';
with 'NoteJam::Form::Defaults';

has user_model => (
    isa      => duck_type(['email_exists']),
    is       => 'ro',
    required => 1,
);

has_field email => (
    type => 'Email',
);
has_field password => (
    type => 'Password',
);
has_field confirm_password => (
    type => 'PasswordConf',
);

sub validate_email {
    my ($self, $field) = @_;
    if ($self->user_model->email_exists($field->value)) {
        $field->add_error('User with this email is already signed up');
    }
}

1;
