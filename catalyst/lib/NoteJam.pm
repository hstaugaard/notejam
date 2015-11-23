package NoteJam;

use Moose;
use namespace::autoclean;
use Catalyst::Runtime 5.90;
use Catalyst qw/
    ConfigLoader
    Static::Simple
    Authentication
    Session
    Session::Store::File
    Session::State::Cookie
/;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config(
    name => 'NoteJam',
    'Plugin::Authentication' => {
        default => {
            credential => {
                class              => 'Password',
                password_field     => 'password',
                password_type      => 'hashed',
                password_hash_type => 'SHA-1',
            },
            store => {
                class      => 'DBIx::Class',
                user_model => 'NoteJam::User',
            },
        },
    },
    disable_component_resolution_regex_fallback => 1,
);
__PACKAGE__->setup;

1;
