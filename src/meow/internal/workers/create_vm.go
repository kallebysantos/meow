package workers

import (
	"context"
	"fmt"
	"os"
	"path"

	"github.com/firecracker-microvm/firecracker-go-sdk"
	"github.com/firecracker-microvm/firecracker-go-sdk/client/models"
	"github.com/kallebysantos/meow/src/meow/pkg/utils"
)

func CreateVM() error {
	id := 3
	ctx := context.Background()
	cwd, err := os.Getwd()
	if err != nil {
		return err
	}

	kernelPath := path.Join(cwd, "temp/vm/kernel/4.14-vmlinux.bin")
	rootFsPath, err := utils.CopyToTemp(path.Join(cwd, "build/alpine.ext4"))
	if err != nil {
		return fmt.Errorf("Failed to create temp rootfs: %v", err)
	}

	socketPath := fmt.Sprintf("/tmp/firecracker-%d.sock", id)

	config := firecracker.Config{
		SocketPath:      socketPath,
		KernelImagePath: kernelPath,
		KernelArgs:      "console=ttyS0 reboot=k panic=1 pci=off nomodules random.trust_cpu=on ip=169.254.0.21::169.254.0.22:255.255.255.252::eth0:off",
		Drives: []models.Drive{{
			DriveID:      firecracker.String("rootfs"),
			PathOnHost:   firecracker.String(rootFsPath),
			IsRootDevice: firecracker.Bool(true),
			IsReadOnly:   firecracker.Bool(false),
		}},
		MachineCfg: models.MachineConfiguration{
			VcpuCount:  firecracker.Int64(1),
			MemSizeMib: firecracker.Int64(256),
		},
		NetworkInterfaces: firecracker.NetworkInterfaces{{
			StaticConfiguration: &firecracker.StaticNetworkConfiguration{
				MacAddress:  "02:FC:00:00:00:05",
				HostDevName: "fc-88-tap0",
				IPConfiguration: &firecracker.IPConfiguration{
					IfName: "eth0",
				},
			},
			/*
				CNIConfiguration: &firecracker.CNIConfiguration{
					NetworkName: "fc-88-tap0",
					IfName:      "eth0",
				},
			*/
		}},
	}

	cmd := firecracker.VMCommandBuilder{}.
		WithBin(path.Join(cwd, "temp/release-v1.13.1-x86_64/firecracker-v1.13.1-x86_64")).
		WithSocketPath(socketPath).
		WithStdin(os.Stdin).
		WithStdout(os.Stdout).
		WithStderr(os.Stderr).
		Build(ctx)

	machineOpts := []firecracker.Opt{
		firecracker.WithProcessRunner(cmd),
	}

	utils.Print(config)
	vm, err := firecracker.NewMachine(ctx, config, machineOpts...)
	if err != nil {
		return fmt.Errorf("Failed to create machine: %v", err)
	}

	if err := vm.Start(ctx); err != nil {
		return fmt.Errorf("Failed to start machine: %v", err)
	}
	utils.Print(vm)

	return nil
}
