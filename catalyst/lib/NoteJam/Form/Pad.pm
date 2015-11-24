package NoteJam::Form::Pad;

use HTML::FormHandler::Moose;
use namespace::autoclean;

extends 'HTML::FormHandler::Model::DBIC';
with 'NoteJam::Form::Defaults';

has_field name => (
    type => 'Text',
);


1;
