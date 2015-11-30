package NoteJam::Form::Defaults;

use Moose::Role;
use namespace::autoclean;

sub build_update_subfields {
    {
        all => {
            do_wrapper => 0,
            required   => 1,
        },
    };
}

1;
