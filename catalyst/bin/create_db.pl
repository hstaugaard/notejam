#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use NoteJam;

NoteJam->model('NoteJam')->schema->deploy;
