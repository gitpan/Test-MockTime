#! /usr/bin/perl 

use Test::MockTime();
use Test::More(tests => 11);
use Time::Local();
use strict;
use warnings;

my ($mock, $real);
$mock = time;
$real = CORE::time;
ok(($mock == $real) || (($mock + 1) == $real) || (($mock - 1) == $real), "Starting time " . localtime($mock)); # previous two statements might go over a second boundary
Test::MockTime::set_relative_time(-600);
$mock = time;
$real = CORE::time;
sleep 2;
$mock = time;
$mock += 600;
$real = CORE::time;
ok(($mock == $real) || (($mock + 1) == $real) || (($mock - 1) == $real), "Set time to be 10 minutes ago, slept for two seconds, time was still in sync");
$mock = Time::Local::timelocal(localtime);
$real = Time::Local::timelocal(CORE::localtime);
$mock = $mock + 600;
ok(($mock == $real) || (($mock + 1) == $real) || (($mock - 1) == $real), "localtime was also still in sync");
Test::MockTime::set_relative_time(+2);
$mock = time;
$real = CORE::time;
sleep 2;
$mock = time;
$real = CORE::time;
ok($mock >= ($real + 1), "Set time to be 2 seconds in the future, slept for three seconds, time was still in front");
$mock = Time::Local::timelocal(localtime);
$real = Time::Local::timelocal(CORE::localtime);
ok($mock >= ($real + 1), "localtime was also still in front");
Test::MockTime::set_absolute_time(100);
$mock = time;
ok(($mock >= 100) && ($mock <= 101), "Absolute time works");
sleep 2;
$mock = time;
ok(($mock >= 102) && ($mock <= 103), "Absolute time is still in sync after two seconds sleep:$mock");
$mock = Time::Local::timelocal(localtime);
$real = Time::Local::timelocal(CORE::localtime);
ok($mock <= $real, "localtime seems ok");
Test::MockTime::set_fixed_time(CORE::time);
$real = time;
sleep 2;
$mock = time;
ok($mock == $real, "fixed time correctly");
Test::MockTime::set_fixed_time(CORE::time);
$mock = Time::Local::timelocal(localtime());
sleep 2;
$real = Time::Local::timelocal(localtime);
ok($mock eq $real, "fixed localtime correctly");
Test::MockTime::set_fixed_time(CORE::time);
$mock = Time::Local::timegm(gmtime);
sleep 2;
$real = Time::Local::timegm(gmtime);
ok($mock eq $real, "fixed gmtime correctly");
