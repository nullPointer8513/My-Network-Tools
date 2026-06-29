#!/bin/bash

# initialize argument default values
mac_address="null"
format_target="null"
debug="false"

# constants
declare -r regex_mac_address_array=(
    "^[a-z0-9]{12}$"
    "^[A-Z0-9]{12}$"
    "^([a-z0-9]{2}\-){5}([a-z0-9]{2})$"
    "^([A-Z0-9]{2}\-){5}([A-Z0-9]{2})$"
    "^([a-z0-9]{2}\:){5}([a-z0-9]{2})$"
    "^([A-Z0-9]{2}\:){5}([A-Z0-9]{2})$"
    "^([a-z0-9]{4}\.){2}([a-z0-9]{4})$"
    "^([A-Z0-9]{4}\.){2}([A-Z0-9]{4})$"
)

declare -r regex_format_target_array=(
    "^(f)$"
    "^(F)$"
    "^(f-)$"
    "^(F-)$"
    "^(f:)$"
    "^(F:)$"
    "^(f\.)$"
    "^(F\.)$"
)

declare -r delimiter_mac_address_array=(
    ""
    ""
    "-"
    "-"
    ":"
    ":"
    "."
    "."
)

declare -r example_mac_address_array=(
    "ffffffffffff"
    "FFFFFFFFFFFF"
    "ff-ff-ff-ff-ff-ff"
    "FF-FF-FF-FF-FF-FF"
    "ff:ff:ff:ff:ff:ff"
    "FF:FF:FF:FF:FF:FF"
    "ffff.ffff.ffff"
    "FFFF.FFFF.FFFF"
)

# variables
regex_mac_address_match="null"
delimiter_mac_address_match="null"
example_mac_address_match="null"

regex_format_target_match="null"
delimiter_format_target_match="null"
example_format_target_match="null"

sanitized_mac_address="null"
mutated_mac_address="null"

fatal () {
    cat <<EOF
*******
[fatal] $@ , use -h to display help
*******
EOF
    >&2 exit
}

usage() {
    cat <<EOF
******************************************************
Mac Address Converter
------------------------------------------------------
Usage: $0 [-m mac_address] [-f format_target] [-d]
------------------------------------------------------
-m : Mac address.            ex: FF:FF:FF:FF:FF:FF
-f : Format target.          ex: f F f- F- f: F: f. F.
-d : Shows inline debug information.
-h : Shows this help message.
******************************************************
EOF
    >&1 exit
}

getmacaddressregex () {
    if [[ $debug == "true" ]]; then
        cat <<EOF
**********
trying to match mac_address to regex
**********
EOF
    fi

    for ((i=0;i<${#regex_mac_address_array[@]};i++)); do
        if [[ $debug == "true" ]]; then
            cat <<EOF
----------
trying formula              : ${regex_mac_address_array[$i]}
example format              : ${example_mac_address_array[$i]}
delimiter                   : ${delimiter_mac_address_array[$i]}
EOF
        fi

        if [[ $mac_address =~ ${regex_mac_address_array[$i]} ]]; then
            regex_mac_address_match=${regex_mac_address_array[$i]}
            example_mac_address_match=${example_mac_address_array[$i]}
            delimiter_mac_address_match=${delimiter_mac_address_array[$i]}

            if [[ $debug == "true" ]]; then
                cat <<EOF
----------
matched formula             : $regex_mac_address_match
example format              : $example_mac_address_match
delimiter                   : $delimiter_mac_address_match

EOF
            fi
            break
        fi
    done

    if [[ $regex_mac_address_match == "null" ]]; then
        fatal "$mac_address is not a valid mac address"
    fi
}

getoptionformat () {
    if [[ $debug == "true" ]]; then
        cat <<EOF
**********
trying to match format_target to regex
**********
EOF
    fi
        for ((i=0;i<${#regex_format_target_array[@]};i++)); do
        if [[ $debug == "true" ]]; then
            cat <<EOF
----------
trying formula              : ${regex_format_target_array[$i]}
example format              : ${example_mac_address_array[$i]}
delimiter                   : ${delimiter_mac_address_array[$i]}
EOF
        fi

        if [[ $format_target =~ ${regex_format_target_array[$i]} ]]; then
            regex_format_target_match=${regex_format_target_array[$i]}
            example_format_target_match=${example_mac_address_array[$i]}
            delimiter_format_target_match=${delimiter_mac_address_array[$i]}

            if [[ $debug == "true" ]]; then
                cat <<EOF
----------
matched formula             : $regex_format_target_match
example format              : $example_format_target_match
delimiter                   : $delimiter_format_target_match
EOF
            fi
            break
        fi
    done

    if [[ $regex_format_target_match == "null" ]]; then
        fatal "$format_target is not a valid format"
    fi
}

mutatemacaddress () {
    if [[ $debug == "true" ]]; then
        cat <<EOF
**********
trying to mutate regex_mac_address_match to regex_format_target_match
**********
EOF
    fi



}


main() {
    local OPTIND OPTARG opt
    while getopts ":m:f:dh" opt; do
        case "$opt" in
            m) mac_address="$OPTARG" ;;
            f) format_target="$OPTARG" ;;
            d) debug='true' ;;
            h) usage ;;
            :) fatal "Option -$OPTARG requires an argument" >&2;;
            \?) fatal "Unknown option -$OPTARG" >&2 ;;
        esac
    done

    if [[ $mac_address == "null" && $format_target == "null" ]]; then
        usage
    fi

    if [[ $debug == "true" ]]; then
        cat <<EOF
**********
passed option arguments
**********
mac_address                 : $mac_address
format_target               : $format_target
debug                       : $debug
EOF
    fi

    getmacaddressregex
    getoptionformat
œ
    if [[ $debug == "true" ]]; then
        cat <<EOF
**********
final matches
**********
passed mac_address          : $mac_address
matched mac_address regex   : $regex_mac_address_match
example format              : $example_mac_address_match
delimiter                   : $delimiter_mac_address_match

passed format_target        : $format_target
matched format_target regex : $regex_format_target_match
example format              : $example_format_target_match
delimiter                   : $delimiter_format_target_match
EOF
    fi

    mutatemacaddress
}

main "$@"
