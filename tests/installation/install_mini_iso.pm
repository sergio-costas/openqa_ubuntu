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

    # dont remember what this was
    assert_screen 'mini_iso_choose_version', 10;
    send_key 'ret';
    # choose release
    assert_screen 'mini_iso_choose_release', 10;
    send_key 'down';
    send_key 'down';
    send_key 'ret';
    assert_screen 'mini_iso_choose_language', 600;
    send_key 'ret';
    assert_screen 'mini_iso_if_new_installer', 10;
    send_key 'ret';
    assert_screen 'mini_iso_keyboard', 10;
    send_key 'ret';
    # server or minimal
    assert_screen 'mini_iso_type_of_install', 10;
    send_key 'ret';
    assert_screen 'mini_iso_network_connections', 10;
    send_key 'ret';
    assert_screen 'mini_iso_proxy_options', 10;
    send_key 'ret';
    assert_screen 'mini_iso_configure_mirror', 10;
    send_key 'ret';
    send_key 'down';
    send_key 'down';
    send_key 'down';
    send_key 'down';
    send_key 'down';
    send_key 'ret';
    assert_screen 'mini_iso_storage_config_summary', 10;
    send_key 'ret';
    assert_screen 'mini_iso_confirm_destructive_action', 10;
    send_key 'down';
    send_key 'ret';
    # profile setup
    assert_screen 'mini_iso_profile_setup', 10;
    type_string 'ubuntu', SLOW_TYPING_SPEED;
    send_key 'tab';
    type_string 'ubuntu', SLOW_TYPING_SPEED;
    send_key 'tab';
    type_string 'ubuntu', SLOW_TYPING_SPEED;
    send_key 'tab';
    type_string 'ubuntu', SLOW_TYPING_SPEED;
    send_key 'tab';
    type_string 'ubuntu', SLOW_TYPING_SPEED;
    send_key 'tab';
    send_key 'ret';
    # openssh form
    assert_screen 'mini_iso_openssh_setup', 10;
    send_key 'ret';
    send_key 'down';
    send_key 'down';
    send_key 'ret';
    # featured snaps
    assert_screen 'mini_iso_featured_snaps', 10;
    send_key 'tab';
    send_key 'ret';
    # It's installing now
    assert_screen 'mini_iso_install_complete', 600;
    send_key 'tab';
    send_key 'tab';
    send_key 'ret';
    assert_screen 'mini_iso_rebooted', 300;
    send_key 'ret';
    type_string 'ubuntu', SLOW_TYPING_SPEED;
    send_key 'ret';
    type_string 'ubuntu', SLOW_TYPING_SPEED;
    send_key 'ret';
    assert_screen 'mini_iso_logged_in', 10;

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