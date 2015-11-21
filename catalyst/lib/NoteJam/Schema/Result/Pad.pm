package NoteJam::Schema::Result::Pad;

use Modern::Perl qw/2012/;
use parent 'DBIx::Class::Core';

__PACKAGE__->table('pads');
__PACKAGE__->add_columns(
    id      => {data_type => 'integer', is_auto_increment => 1},
    user_id => {data_type => 'integer'},
    name    => {data_type => 'text',},
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many(
    notes => 'NoteJam::Schema::Result::Note',
    {'foreign.pad_id' => 'self.id', 'foreign.user_id' => 'self.user_id'},
);
__PACKAGE__->belongs_to(
    user => 'NoteJam::Schema::Result::User',
    'user_id',
    {on_delete => 'CASCADE', on_update => 'CASCADE'},
);

1;
