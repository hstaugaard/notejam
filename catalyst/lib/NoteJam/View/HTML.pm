package NoteJam::View::HTML;

use Moose;
use namespace::autoclean;
use DateTime::Format::SmartDate;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    ENCODING           => 'UTF-8',
    render_die         => 1,
    expose_methods     => [qw/smart_date/],
);

sub smart_date {
    my ($self, $c, $datetime) = @_;
    return DateTime::Format::SmartDate->format_datetime($datetime);
}

__PACKAGE__->meta->make_immutable;

1;
