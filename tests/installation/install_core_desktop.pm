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
use constant NEW_SLIDE_WAIT => 20;

sub do_click_at {
    my ($x, $y) = @_;
    mouse_set($x, $y);
    sleep(1);
    mouse_click();
}

sub run {
    assert_screen 'ubuntu-logo', 30;
    assert_screen 'installer', 80;
    do_click_at(802,565);
    assert_screen 'keyboard-layout', NEW_SLIDE_WAIT;
    do_click_at(802,567);
    assert_screen 'erase-disk', NEW_SLIDE_WAIT;
    do_click_at(802,565);
    assert_screen 'do-install', NEW_SLIDE_WAIT;
    do_click_at(803,567);
    assert_screen 'installing-system', NEW_SLIDE_WAIT;
    assert_screen 'install-complete', 400;
    do_click_at(580,390);
    assert_screen 'remove-media', 80;
    eject_cd;
    sleep(2);
    send_key 'ret';
    # this is the first boot, where the filesystem is resized
    # and all the snaps are installed
    assert_screen 'booting-core', 100;
    # if we detect that it is running, we wait until everything
    # is done.
    assert_screen 'config-core', 3000;
    do_click_at(930,726);
    assert_screen 'config-keyboard-core', NEW_SLIDE_WAIT;
    # click on the keyboard list...
    do_click_at(332,322);
    # and press 'e' seven times to select "english (US)" keyboard
    send_key 'e';
    send_key 'e';
    send_key 'e';
    send_key 'e';
    send_key 'e';
    send_key 'e';
    send_key 'e';
    do_click_at(930,726);
    assert_screen 'connect-network', NEW_SLIDE_WAIT;
    do_click_at(930,728);
    assert_screen 'select-timezone', NEW_SLIDE_WAIT;
    do_click_at(464,352);
    do_click_at(930,726);
    assert_screen 'user-account', NEW_SLIDE_WAIT;
    do_click_at(58,92);
    type_string 'username', SLOW_TYPING_SPEED;
    send_key 'tab';
    send_key 'tab';
    send_key 'tab';
    type_string 'apassword', SLOW_TYPING_SPEED;
    send_key 'tab';
    send_key 'tab';
    type_string 'apassword', SLOW_TYPING_SPEED;
    do_click_at(930,726);
    assert_screen 'all-done', NEW_SLIDE_WAIT;
    do_click_at(930,726);
    assert_screen 'show-desktop', 40;
    do_click_at(950,12);
    assert_screen 'reboot-button', NEW_SLIDE_WAIT;
    do_click_at(973,70);
    assert_screen 'select-reboot', NEW_SLIDE_WAIT;
    do_click_at(682,229);
    assert_screen 'confirm-reboot', NEW_SLIDE_WAIT;
    do_click_at(614,436);
    assert_screen 'login', 60;
    send_key 'ret';
    sleep(1);
    type_string 'apassword', SLOW_TYPING_SPEED;
    sleep(3);
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