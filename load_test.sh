#!/usr/bin/env bash

BENCHMARK_DURATION=5s
SLEEP_BETWEEN_BENCHMARK=10
SLEEP_BETWEEN_LOOP=6

function print_usage {
    echo "Usage: benchmark.sh <vegeta-request-file.json> <number-of-rounds>"
    echo "You need to construct a valid vegeta request file in json format."
    echo "Check https://github.com/tsenart/vegeta for example."
}

if [ "$#" -ne 2 ]; then
    echo "Illegal number of arguments!\n"
    print_usage
    exit 1
fi

vegeta_request_file=$1
number_of_rounds=$2

for rate in 50 100 150 200
do
    output_file=/tmp/vegeta-benchmark-$rate.txt
    echo "====vegeta benchmark rate: $rate====";
    echo "" > $output_file
    for i in `seq 1 $number_of_rounds`
    do
        cat $vegeta_request_file | \
            vegeta attack -format=json -rate=$rate \
                   -duration $BENCHMARK_DURATION | \
            vegeta report
        sleep $SLEEP_BETWEEN_BENCHMARK
    done > $output_file

    cat $output_file \
        | grep max \
        | awk '{print $8}' \
        | sed 's/ms,$//g' \
        | sed 's/,$//g' \
        | awk -v rounds="$number_of_rounds" '{if ($1 ~ /.*s$/) sum+=$1*1000; else sum+=$1} END {print "p50: " sum/rounds}'

    cat $output_file \
        | grep max \
        | awk '{print $9}' \
        | sed 's/ms,$//g' \
        | sed 's/,$//g' \
        | awk -v rounds="$number_of_rounds" '{if ($1 ~ /.*s$/) sum+=$1*1000; else sum+=$1} END {print "p95: " sum/rounds}'

    cat $output_file \
        | grep max \
        | awk '{print $10}' \
        | sed 's/ms,$//g' \
        | sed 's/,$//g' \
        | awk -v rounds="$number_of_rounds" '{if ($1 ~ /.*s$/) sum+=$1*1000; else sum+=$1} END {print "p99: " sum/rounds}'

    sleep $SLEEP_BETWEEN_LOOP
    echo
done
