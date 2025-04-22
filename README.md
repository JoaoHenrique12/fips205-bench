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

### [inputs](inputs/)

Contains the inputs used to run tests and the python file used to generate this inputs.
All files lorem-*.txt are read only to avoid their acidentally deletion.

```bash
sudo chmod 444 lorem-*
```

### [algorithms](algorithms/)

#### Each Folder With an **AlgorithmName** Contains:

- F folders named: language-username, one fore each implementation
  - F git repositories, one for each implementation of AlgorithmName
  - G folders called output_<commit-hash>, with 8 graphs, for each git repository
    - Graph to Sign/Verify one message
      - Graph bytes input x time spend to Sign one Message
      - Graph bytes input x time spend to Verify one Message
      - Graph bytes input x memory spend to Sign one Message
      - Graph bytes input x memory spend to Verify one Message
    - Graph to Sign/Verify many messages, all messages are equals to [inputs/lorem-1M.txt](inputs/lorem-1M.txt)
      - Graph N messages x time spend to Sign N Message
      - Graph N messages x time spend to Verify N Message
      - Graph N messages x memory spend to Sign N Message
      - Graph N messages x memory spend to Verify N Message
    - One folder called logs to save information about each runned test
  - One json file called metadata.json, e.g.
  ```json
  {
    "git_link": "https://github.com/JoaoHenrique12/fips205",
    "branch": "main",
    "last_version": "bf73a4a3ffa2612c60857a3c46c8207c283e103a"
  }
  ```
  - A main.<language_extension> file to run the algorithm with [inputs](inputs/) configured with the profiling options
  - One Dockerfile to build the containers for tests

## Profiling

Profiling tools for each language are configured to retrieve the amount of memory and execution time
for each test. This tools are activated in different runs because profiling memory may interfere in
execution time and profiling time may interfere in memory.
Reference: [go-diagnostics](https://go.dev/doc/diagnostics)

