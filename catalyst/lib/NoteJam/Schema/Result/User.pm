package NoteJam::Schema::Result::User;

use strict;
use warnings;
use parent 'DBIx::Class::Core';

__PACKAGE__->table('users');
__PACKAGE__->add_columns(
    id       => {data_type => 'integer', is_auto_increment => 1},
    email    => {data_type => 'varchar', size => 75},
    password => {data_type => 'text', size => 128},
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('email_unique', ['email']);
__PACKAGE__->has_many(notes => 'NoteJam::Schema::Result::Note', 'user_id');
__PACKAGE__->has_many(pads => 'NoteJam::Schema::Result::Pad', 'user_id');

1;
