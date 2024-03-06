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

sub run {

    # seconds to wait after an assert_screen to ensure that the
    # transition is completed.
    my $transition_wait = 4;

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
    eject_cd;
    sleep($transition_wait);
    send_key 'ret';
    assert_screen 'config-core', 900;
    sleep($transition_wait);
    mouse_set(930,726);
    mouse_click();
    assert_screen 'config-keyboard-core', 5;
    sleep($transition_wait);
    mouse_set(332,322);
    mouse_click();
    sleep(1);
    mouse_set(930,726);
    mouse_click();
    assert_screen 'connect-network', 5;
    sleep($transition_wait);
    mouse_set(930,728);
    mouse_click();
    assert_screen 'select-timezone', 5;
    sleep($transition_wait);
    mouse_set(464,352);
    mouse_click();
    sleep(1);
    mouse_set(930,726);
    mouse_click();
    assert_screen 'user-account', 5;
    sleep($transition_wait);
    mouse_set(58,92);
    mouse_click();
    type_string 'username', SLOW_TYPING_SPEED;
    send_key 'tab';
    send_key 'tab';
    send_key 'tab';
    type_string 'apassword', SLOW_TYPING_SPEED;
    send_key 'tab';
    send_key 'tab';
    type_string 'apassword', SLOW_TYPING_SPEED;
    sleep($transition_wait);
    mouse_set(930,726);
    mouse_click();
    assert_screen 'all-done', 5;
    sleep($transition_wait);
    mouse_set(930,726);
    mouse_click();
    assert_screen 'show-desktop', 40;
    sleep($transition_wait);
    mouse_set(950,12);
    mouse_click();
    assert_screen 'shutdown-button', 5;
    sleep($transition_wait);
    mouse_set(973,70);
    mouse_click();
    assert_screen 'next', 100;
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