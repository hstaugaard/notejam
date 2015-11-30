package NoteJam::View::Email;

use Moose;
use namespace::autoclean;

extends 'Catalyst::View::Email';

__PACKAGE__->config(stash_key => 'email');

__PACKAGE__->meta->make_immutable;

1;
