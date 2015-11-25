package NoteJam::Form::Note;

use HTML::FormHandler::Moose;
use namespace::autoclean;

extends 'HTML::FormHandler::Model::DBIC';
with 'NoteJam::Form::Defaults';

has_field name => (
    type => 'Text',
);
has_field text => (
    type => 'TextArea',
);
has_field pad => (
    type         => 'Select',
    required     => 0,
    empty_select => '---------',
);

sub options_pad {
    my $self = shift;
    return map {$_->id => $_->name} $self->ctx->user->pads;
};

1;
