#!/usr/bin/env perl

use strict;
use warnings;
use lib qw/lib/;
use NoteJam;

NoteJam->apply_default_middlewares(NoteJam->psgi_app);
