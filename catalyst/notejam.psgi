#!/usr/bin/env perl

use strict;
use warnings;
use lib qw/lib/;
use NoteJam;

NoteJam->psgi_app;
