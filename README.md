# Load testing using Vegeta
This is a simple script which is used for load testing of an api.

## Prerequisite
Should know about Vegeta. You can check [this](https://github.com/tsenart/vegeta).

## How to use
1. Create the request json file. 
2. Run `./load_test.sh { put vegeta_request_file} {no. of rounds you want to do the load testing}` 
    e.g. `./load_test.sh api_request.json 10`

3. The script will create output files for diffent concurrency (currently hardcoded in script as 50, 100, 150 and 200)in `/tmp/`. 
    e.g file will be named like `vegeta-benchmark-50.txt`.

4. Terminal output will look something like 
```
====vegeta benchmark rate: 50====
p50: 2.78763
p95: 4.88795
p99: 57.2107

====vegeta benchmark rate: 100====
p50: 2.21426
p95: 2.71912
p99: 3.12941

====vegeta benchmark rate: 150====
p50: 1.95628
p95: 2.46924
p99: 2.97679

====vegeta benchmark rate: 200====
p50: 1.58356
p95: 2.08388
p99: 2.35044
```
5. To understand the output file you can check [this](https://www.scaleway.com/en/docs/vegeta-load-testing/)