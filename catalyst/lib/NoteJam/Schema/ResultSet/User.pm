package NoteJam::Schema::ResultSet::User;

use strict;
use warnings;
use parent 'DBIx::Class::ResultSet';

sub email_exists {
    my ($self, $email) = @_;
    return !!$self->find($email, {key => 'email_unique'});
}

sub update_password {
    my ($self, $email, $password) = @_;
    return $self->find($email, {key => 'email_unique'})->update({password => $password});
}

1;
