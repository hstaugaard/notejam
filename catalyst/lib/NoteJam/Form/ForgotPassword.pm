package NoteJam::Form::ForgotPassword;

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

sub validate_email {
    my ($self, $field) = @_;
    if (!$self->user_model->email_exists($field->value)) {
        $field->add_error('No user with given email');
    }
}

1;
