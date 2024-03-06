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
use strict;
use testapi;

use constant SLOW_TYPING_SPEED => 13;

$transition_wait = 2;

sub run {

    # seconds to wait after an assert_screen to ensure that the
    # transition is completed.

    assert_screen 'ubuntu-logo', 30;
    assert_screen 'installer', 80;
    sleep($transition_wait);
    mouse_set(802,565);
    mouse_click();
    assert_screen 'keyboard-layout', 5;
    sleep($transition_wait);
    mouse_set(802,567);
    mouse_click();
    assert_screen 'erase-disk', 5;
    sleep($transition_wait);
    mouse_set(802,565);
    mouse_click();
    assert_screen 'do-install', 5;
    sleep($transition_wait);
    mouse_set(802,567);
    mouse_click();
    assert_screen 'installing-system', 5;
    assert_screen 'install-complete', 180;
    sleep($transition_wait);
    mouse_set(580,390);
    mouse_click();
    assert_screen 'remove-media', 80;
    send_key 'ret';
    assert_screen 'next', 40;
    #type_string 'ubuntu', SLOW_TYPING_SPEED;
    #send_key 'ret';
    #assert_screen 'mini_iso_logged_in', 10;

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