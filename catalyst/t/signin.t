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

# Create test user

$schema->resultset('User')->create({email => 'person@example.com', password => 'secret'});

subtest q/user can successfully sign in/ => sub {
    my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'NoteJam');

    $mech->get_ok('/signin');
    $mech->title_is('Sign in');

    $mech->field('email', 'person@example.com');
    $mech->field('password', 'secret');
    $mech->click;

    $mech->title_like(qr/All notes/);
    $mech->content_contains('You are signed in!');
};

subtest q/user can't sign in if required fields are missing/ => sub {
    my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'NoteJam');

    $mech->get_ok('/signin');

    $mech->click;

    $mech->title_is('Sign in');
    $mech->content_contains('Email field is required');
    $mech->content_contains('Please enter a password in this field');
};

subtest q/user can't sign in if credentials are wrong/ => sub {
    my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'NoteJam');

    $mech->get_ok('/signin');

    $mech->field('email', 'monkey@example.com');
    $mech->field('password', 'secret');
    $mech->click;

    $mech->title_is('Sign in');
    $mech->content_contains('Wrong email or password');
};

done_testing;
