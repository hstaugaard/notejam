package NoteJam::Schema::ResultSet::User;

use strict;
use warnings;
use parent 'DBIx::Class::ResultSet';

sub email_exists {
    my ($self, $email) = @_;
    return !!$self->find($email, {key => 'email_unique'});
}

1;
