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
my $note = $user->create_related('notes', {name => 'TestNote', text => 'Lorem ipsum'});
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

subtest q/Note can be successfully created/ => sub {
    my $mech = sign_in();
    $mech->get_ok('/notes/create');
    $mech->field('name', 'MyNote');
    $mech->field('text', 'Yada yada');
    $mech->click;
    $mech->content_contains('Note is successfully created');
    $mech->content_contains('MyNote');
    ok($user->search_related('notes', {name => 'MyNote'})->count, 'Note inserted');
};

subtest q/Note can't be created by anonymous user/ => sub {
    my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'NoteJam');
    $mech->post('/notes/create', {name => 'MyNote', text => 'Yada yada'});
    ok(!$mech->success, 'Not allowed');
};

subtest q/Note can't be created if required fields are missing/ => sub {
    my $mech = sign_in();
    $mech->get_ok('/notes/create');
    $mech->click;
    $mech->content_contains('Name field is required');
    $mech->content_contains('Text field is required');
};

subtest q/Note can be edited by its owner/ => sub {
    my $mech = sign_in();
    $mech->get_ok('/notes/' . $note->id . '/edit');
    $mech->field('text', 'Yada yada');
    $mech->click;
    $mech->content_contains('Note is successfully updated');
    $note->discard_changes; # refresh row object
    is($note->text, 'Yada yada', 'Note updated');
};

subtest q/Note can't be edited if required fields are missing/ => sub {
    my $mech = sign_in();
    $mech->get_ok('/notes/' . $note->id . '/edit');
    $mech->field('name', '');
    $mech->field('text', '');
    $mech->click;
    $mech->content_contains('Name field is required');
    $mech->content_contains('Text field is required');
};

subtest q/Note can't be edited by not an owner/ => sub {
    my $mech = sign_in('haxxor@example.com', 'secret');
    $mech->get('/notes/' . $note->id . '/edit');
    ok(!$mech->success, 'Not found');
};

subtest q/Note can't be added into another's user pad/ => sub {
    my $mech = sign_in('haxxor@example.com', 'secret');
    $mech->get_ok('/notes/create');
    $mech->field('name', 'MyNote');
    $mech->field('text', 'Yada yada');
    $mech->field('pad', $pad->id);
    $mech->click;
    $mech->content_contains($pad->id . q/' is not a valid value/);
};

subtest q/Note can be viewed by its owner/ => sub {
    my $mech = sign_in();
    $mech->get_ok('/notes/' . $note->id);
    $mech->title_is($note->name)
};

subtest q/Note can't be viewed by not an owner/ => sub {
    my $mech = sign_in('haxxor@example.com', 'secret');
    $mech->get('/notes/' . $note->id);
    ok(!$mech->success, 'Not found');
};

subtest q/Note can't be deleted by not an owner/ => sub {
    my $mech = sign_in('haxxor@example.com', 'secret');
    $mech->get('/notes/' . $note->id . '/delete');
    ok(!$mech->success, 'Not found');
};

subtest q/Note can be deleted by its owner/ => sub {
    my $mech = sign_in();
    my $note_name = $note->name;
    $mech->get_ok('/notes/' . $note->id . '/delete');
    $mech->content_contains('Are you sure');
    $mech->click;
    $mech->content_lacks($note_name);
    $note->discard_changes; # refresh row object
    ok(!$note->in_storage, 'Note deleted');
};

done_testing;
