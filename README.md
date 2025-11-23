<p align="center">
  <img alt="Logo" src="./assets/meow.gif" width="250" style="max-width: 100%;">
</p>

# meow

Micro Environments / Orchestrated Workers

## Getting started

### Setup

#### Firecracker Install

In order to run meow! You need to first install firecracker.
Run the following command:

```bash
./scripts/install_firecracker.sh
```

#### Download Linux kernel

Run the following command:

```bash
mkdir -p temp/vm/kernel
curl -fsSL -o temp/vm/kernel/4.14-vmlinux.bin https://s3.amazonaws.com/spec.ccfc.min/img/hello/kernel/hello-vmlinux.bin
```

### Building a Micro Environment

Environments examples are placed inside the `environments` folder
You can easily build an environment by running the following command:

```bash
./scripts/build.sh "<Environment>"
```

#### Deno example

```bash
./scripts/build.sh deno
```

### Running a Worker

You can now use the `vm_config.json` file to run your first worker

#### Setup network

In order to setup a network you need to run the following command:

```bash
./scripts/setup_network.sh
```

#### Then to run a worker

```bash
./scripts/run_firecracker_from_file.sh
```
