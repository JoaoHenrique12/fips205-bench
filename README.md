# FIPS 205 Bench

Repository to benchmark FIPS 205 implementations.

## Test Environment

About the test environment, is used a VM from [Magalu Cloud](https://magalu.cloud/) to run the tests.

VM specs:
  - (VM_TYPE, BV2-2-10)
  - (RAM, 2GB);
  - (CPU, 2vCPU);
  - (DISK, 10GB);

For each test the Dockerfile is limited to use 1GB of RAM and 1 vCPU.

## Repository Structure

### inputs

Contains the inputs used to run tests and a python file to generate this inputs.

### Each Folder With an **AlgorithmName** Contains:

- One or more inplementations and its respective Dockerfile
  - Graph to Sign/Verify one message
    - Graph bytes input x time spend to Sign one Message
    - Graph bytes input x time spend to Verify one Message
    - Graph bytes input x memory spend to Sign one Message
    - Graph bytes input x memory spend to Verify one Message
  - Graph to Sign/Verify many messages, all messages are equal [inputs/lorem-1M.txt](inputs/lorem-1M.txt)
    - Graph N messages x time spend to Sign N Message
    - Graph N messages x time spend to Verify N Message
    - Graph N messages x memory spend to Sign N Message
    - Graph N messages x memory spend to Verify N Message


Profiling tools for each language are configured to retrieve the amount of memory and execution time
for each test. This tools are activated in different runs because profiling memory may interfere in
execution time and profiling time may interfere in memory.
Reference: [go-diagnostics](https://go.dev/doc/diagnostics)

