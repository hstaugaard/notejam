package NoteJam::View::HTML;

use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    ENCODING           => 'UTF-8',
    render_die         => 1,
);

1;
