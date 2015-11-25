package NoteJam::Form::Settings;

use HTML::FormHandler::Moose;
use namespace::autoclean;
use Moose::Util::TypeConstraints;

extends 'HTML::FormHandler';
with 'NoteJam::Form::Defaults';

has user => (
    isa      => duck_type(['check_password']),
    is       => 'ro',
    required => 1,
);

has_field old_password => (
    type => 'Password',
);
has_field new_password => (
    type => 'Password',
);
has_field confirm_new_password => (
    type           => 'PasswordConf',
    password_field => 'new_password',
);

sub validate_old_password {
    my ($self, $field) = @_;
    if (!$self->user->check_password($field->value)) {
        $field->add_error('Your old password was entered incorrectly. Please enter it again.');
    }
}

1;
