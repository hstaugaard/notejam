package NoteJam::Controller::Root;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'}

__PACKAGE__->config(namespace => '');

sub index :Path :Args(0) { ## no critic (ProhibitBuiltinHomonyms)
    my ( $self, $c ) = @_;
    #$c->authenticate({email => 'staugaard@cpan.org', password => 'asdzxc'});
    #if ($c->user_exists) {
    #    $c->log->debug('USER ID: ' . $c->user->id);
    #} else {
    #    $c->log->debug('Hmmm, not authenticated');
    #}
    $c->res->body('w00t!');
}

sub default :Path { ## no critic (ProhibitBuiltinHomonyms)
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404); ## no critic (ProhibitMagicNumbers)
}

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;
