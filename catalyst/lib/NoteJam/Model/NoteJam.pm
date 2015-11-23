package NoteJam::Model::NoteJam;

use strict;
use warnings;
use parent 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'NoteJam::Schema',
);

1;
