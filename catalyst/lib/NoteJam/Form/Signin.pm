package NoteJam::Form::Signin;

use HTML::FormHandler::Moose;
use namespace::autoclean;

extends 'HTML::FormHandler';
with 'NoteJam::Form::Defaults';

has_field email => (
    type => 'Email',
);
has_field password => (
    type => 'Password',
);

1;
