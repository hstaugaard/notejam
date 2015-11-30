package NoteJam::Schema::Result::Note;

use strict;
use warnings;
use parent 'DBIx::Class::Core';

__PACKAGE__->load_components(qw/TimeStamp/);
__PACKAGE__->table('notes');
__PACKAGE__->add_columns(
    id         => {data_type => 'integer',  is_auto_increment => 1},
    user_id    => {data_type => 'integer'},
    pad_id     => {data_type => 'integer',  is_nullable       => 1},
    name       => {data_type => 'varchar',  size              => 100},
    text       => {data_type => 'text'},
    created_at => {data_type => 'datetime', set_on_create     => 1},
    updated_at => {data_type => 'datetime', set_on_create => 1, set_on_update => 1},
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(
    pad => 'NoteJam::Schema::Result::Pad',
    'pad_id',
    {on_delete => 'CASCADE', on_update => 'CASCADE'},
);
__PACKAGE__->belongs_to(
    user => 'NoteJam::Schema::Result::User',
    'user_id',
    {on_delete => 'CASCADE', on_update => 'CASCADE'},
);

1;
