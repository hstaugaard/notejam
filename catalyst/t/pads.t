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

# Create test data

my $user = $schema->resultset('User')->create({email => 'person@example.com', password => 'secret'});
my $pad = $user->create_related('pads', {name => 'TestPad'});
$schema->resultset('User')->create({email => 'haxxor@example.com', password => 'secret'});

sub sign_in {
    my ($username, $password) = @_;
    $username //= 'person@example.com';
    $password //= 'secret';
    my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'NoteJam');
    $mech->get('/signin');
    $mech->field('email', $username);
    $mech->field('password', $password);
    $mech->click;
    return $mech;
}

subtest q/Pad can be successfully created/ => sub {
    my $mech = sign_in();
    $mech->get_ok('/pads/create');
    $mech->field('name', 'MyPad');
    $mech->click;
    $mech->content_contains('Pad is successfully created');
    $mech->content_contains('MyPad');
    ok($user->search_related('pads', {name => 'MyPad'})->count, 'Pad inserted');
};

subtest q/Pad can't be created if required fields are missing/ => sub {
    my $mech = sign_in();
    $mech->get_ok('/pads/create');
    $mech->click;
    $mech->content_contains('Name field is required');
};

subtest q/Pad can be edited by its owner/ => sub {
    my $mech = sign_in();
    $mech->get_ok('/pads/' . $pad->id . '/edit');
    $mech->title_is($pad->name . ' (' . $pad->notes->count . ')');
    $mech->field('name', 'TestPad2');
    $mech->click;
    $mech->content_contains('Pad is successfully updated');
    $mech->content_contains('TestPad2');
    $pad->discard_changes; # refresh row object
    is($pad->name, 'TestPad2', 'Pad updated');

};

subtest q/Pad can't be edited if required fields are missing/ => sub {
    my $mech = sign_in();
    $mech->get_ok('/pads/' . $pad->id . '/edit');
    $mech->field('name', '');
    $mech->click;
    $mech->content_contains('Name field is required');
};

subtest q/Pad can't be edited by not an owner/ => sub {
    my $mech = sign_in('haxxor@example.com', 'secret');
    $mech->get('/pads/' . $pad->id . '/edit');
    ok(!$mech->success, 'Not found');
};

subtest q/Pad can be viewed by its owner/ => sub {
    my $mech = sign_in();
    $mech->get_ok('/pads/' . $pad->id);
    $mech->content_contains('Pad settings');
};

subtest q/Pad can't be viewed by not an owner/ => sub {
    my $mech = sign_in('haxxor@example.com', 'secret');
    $mech->get('/pads/' . $pad->id);
    ok(!$mech->success, 'Not found');
};

subtest q/Pad can't be deleted by not an owner/ => sub {
    my $mech = sign_in('haxxor@example.com', 'secret');
    $mech->get('/pads/' . $pad->id . '/delete');
    ok(!$mech->success, 'Not found');
};

subtest q/Pad can be deleted by its owner/ => sub {
    my $mech = sign_in();
    my $pad_name = $pad->name;
    $mech->get_ok('/pads/' . $pad->id . '/delete');
    $mech->content_contains('Are you sure');
    $mech->click;
    $mech->content_lacks($pad_name);
    $pad->discard_changes; # refresh row object
    ok(!$pad->in_storage, 'Pad deleted');
};

done_testing;
