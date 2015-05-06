#!/bin/bash

@test "lwrp installs check_iowait nrpe" {
    run test -f /etc/nagios/nrpe.d/check_iowait.cfg
    [ "$status" -eq 0 ]

    run test -f /usr/lib/nagios/plugins/check_iowait.sh
    [ "$status" -eq 0 ]
}

@test "lwrp does not install check_test nrpe" {
    run test -f /usr/lib/nagios/plugins/check_test
    [ "$status" -ne 0 ]
}
