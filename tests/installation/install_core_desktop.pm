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
    my $transition_wait = 3;
    my $new_slide_wait = 10;

    assert_screen 'ubuntu-logo', 30;
    assert_screen 'installer', 80;
    mouse_set(802,565);
    sleep($transition_wait);
    mouse_click();
    assert_screen 'keyboard-layout', $new_slide_wait;
    mouse_set(802,567);
    sleep($transition_wait);
    mouse_click();
    assert_screen 'erase-disk', $new_slide_wait;
    mouse_set(802,565);
    sleep($transition_wait);
    mouse_click();
    assert_screen 'do-install', $new_slide_wait;
    mouse_set(803,567);
    sleep($transition_wait);
    mouse_click();
    assert_screen 'installing-system', $new_slide_wait;
    assert_screen 'install-complete', 400;
    mouse_set(580,390);
    sleep($transition_wait);
    mouse_click();
    assert_screen 'remove-media', 80;
    eject_cd;
    sleep($transition_wait);
    send_key 'ret';
    # this is the first boot, where the filesystem is resized
    # and all the snaps are installed
    assert_screen 'config-core', 3000;
    mouse_set(930,726);
    sleep($transition_wait);
    mouse_click();
    assert_screen 'config-keyboard-core', $new_slide_wait;
    mouse_set(332,322);
    sleep($transition_wait);
    mouse_click();
    sleep(1);
    mouse_set(930,726);
    mouse_click();
    assert_screen 'connect-network', $new_slide_wait;
    mouse_set(930,728);
    sleep($transition_wait);
    mouse_click();
    assert_screen 'select-timezone', $new_slide_wait;
    mouse_set(464,352);
    sleep($transition_wait);
    mouse_click();
    sleep(1);
    mouse_set(930,726);
    mouse_click();
    assert_screen 'user-account', $new_slide_wait;
    mouse_set(58,92);
    sleep($transition_wait);
    mouse_click();
    type_string 'username', SLOW_TYPING_SPEED;
    send_key 'tab';
    send_key 'tab';
    send_key 'tab';
    type_string 'apassword', SLOW_TYPING_SPEED;
    send_key 'tab';
    send_key 'tab';
    type_string 'apassword', SLOW_TYPING_SPEED;
    mouse_set(930,726);
    sleep($transition_wait);
    mouse_click();
    assert_screen 'all-done', $new_slide_wait;
    mouse_set(930,726);
    sleep($transition_wait);
    mouse_click();
    assert_screen 'show-desktop', 40;
    mouse_set(950,12);
    sleep($transition_wait);
    mouse_click();
    assert_screen 'reboot-button', $new_slide_wait;
    mouse_set(973,70);
    sleep($transition_wait);
    mouse_click();
    assert_screen 'select-reboot', $new_slide_wait;
    mouse_set(682,229);
    sleep($transition_wait);
    mouse_click();
    assert_screen 'confirm-reboot', $new_slide_wait;
    mouse_set(614,436);
    sleep($transition_wait);
    mouse_click();
    assert_screen 'login', 60;
    send_key 'ret';
    sleep(1);
    type_string 'apassword', SLOW_TYPING_SPEED;
    send_key 'ret';
    assert_screen 'next', 2000;
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