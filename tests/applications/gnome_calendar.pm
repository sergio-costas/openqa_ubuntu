# Copyright (C) 2018 SUSE LLC
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, see <http://www.gnu.org/licenses/>.

use base 'basetest';
# use strict;
use testapi;

use constant SLOW_TYPING_SPEED => 13;

sub run {

    send_key 'alt-f2';
    assert_screen 'term_prompt', 100;
    type_string 'gnome-calendar';
    assert_screen 'second_term', 100;
    send_key 'ret';
    assert_screen 'calendar', 100;
    assert_and_click 'week';
    assert_screen 'week_view', 100;
    assert_and_click 'make_event';
    assert_screen 'input_event', 100;
    type_string 'dummy_event', SLOW_TYPING_SPEED;
    assert_screen 'inputted_calendar', 100;
    assert_and_click 'calendar_done';
    assert_screen 'dummy_event_made', 100;
    send_key 'alt-f4';
}

sub test_flags {
    # 'fatal'          - abort whole test suite if this fails (and set overall state 'failed')
    # 'ignore_failure' - if this module fails, it will not affect the overall result at all
    # 'milestone'      - after this test succeeds, update 'lastgood'
    # 'norollback'     - don't roll back to 'lastgood' snapshot if this fails
    return { fatal => 1 };
}

1;

# vim: set sw=4 et: