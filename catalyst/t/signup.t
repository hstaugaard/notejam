#!/usr/bin/ev perl

use strict;
use warnings;
use Test::More;
use Test::WWW::Mechanize::Catalyst;

BEGIN {
    $ENV{CATALYST_CONFIG_LOCAL_SUFFIX} = 'testing'; ## no critic (RequireLocalizedPunctuationVars)
}

use NoteJam;

# Setup database

my $schema = NoteJam->model('NoteJam')->schema;
$schema->deploy;

subtest 'User can successfully sign up' => sub {
    my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'NoteJam');

    $mech->get_ok('/signup');
    $mech->title_is('Sign up');

    $mech->field('email', 'person@example.com');
    $mech->field('password', 'secret');
    $mech->field('confirm_password', 'secret');
    $mech->click;

    $mech->title_is('Sign in');
    $mech->content_contains('Account is created. Now you can sign in.');
};

subtest q/User can't sign up if required fields are missing/ => sub {
    my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'NoteJam');

    $mech->get_ok('/signup');

    $mech->click;

    $mech->title_is('Sign up');
    $mech->content_contains('Email field is required');
    $mech->content_contains('Please enter a password in this field');
    $mech->content_contains('Please enter a password confirmation');
};

subtest q/User can't sign up if email is invalid/ => sub {
    my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'NoteJam');

    $mech->get_ok('/signup');

    $mech->field('email', 'foobar');
    $mech->click;

    $mech->title_is('Sign up');
    $mech->content_contains('Email should be of the format someuser@example.com');
};

subtest q/User can't sign up if email already exists/ => sub {
    my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'NoteJam');

    $mech->get_ok('/signup');

    $mech->field('email', 'person@example.com');
    $mech->click;

    $mech->title_is('Sign up');
    $mech->content_contains('User with this email is already signed up');
};

subtest q/User can't sign up if passwords do not match/ => sub {
    my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'NoteJam');

    $mech->get_ok('/signup');

    $mech->field('password', 'secret');
    $mech->field('confirm_password', 'terces');
    $mech->click;

    $mech->title_is('Sign up');
    $mech->content_contains('The password confirmation does not match the password');
};

done_testing;
