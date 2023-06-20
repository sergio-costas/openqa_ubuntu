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

sub run {

    # Select between 'Try' or 'Installation'
    # assert_and_click 'try_ubuntu_btn23_04' if check_var('INSTALL_TYPE', 'try');
    assert_screen 'try_or_install23_04', 200;
    assert_and_click 'install_ubuntu_btn';
    # assert_and_click 'install_ubuntu_btn23_04' if check_var('INSTALL_TYPE', 'install');
    assert_and_click 'next23_04';
    assert_screen 'setup1', 200;
    assert_and_click 'setup1click';
    assert_screen 'languagescreen', 100;
    assert_and_click 'next23_04';
    assert_screen 'setup3', 100;
    assert_and_click 'next23_04';
    assert_screen 'setup4', 100;
    assert_and_click 'next23_04';
    assert_screen 'setup5', 100;
    assert_and_click 'install_button';

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