package DateTime::Format::SmartDate;

use strict;
use warnings;

sub format_datetime {
    my $dt    = pop;
    my $delta = DateTime->now->delta_days($dt)->days;
    ## no critic (ProhibitMagicNumbers)
    if ($delta == 0) {
        return $dt->strftime('Today at %H:%M');
    } elsif ($delta == 1) {
        return $dt->strftime('Yesterday at %H:%M');
    } elsif ($delta < 4) {
        return "$delta days ago";
    } else {
        return $dt->strftime('%d %b %Y');
    }
}

1;

