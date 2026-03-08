# ARM-Coreutils

A collection of GNU coreutils utilities implemented in 32‑bit ARM assembly.

## Build

If you are on an ARM‑based system, you can assemble and link the source files directly:

```sh
as <filename>.s -o <filename>.o
ld <filename>.o -o <filename>.out
```

For non‑ARM hosts you can use QEMU user‑mode emulation. First install **podman** and **QEMU** and pull an ARM32v7 base image:

On Fedora‑based systems you can install the required QEMU user‑mode static binary with:

```sh
sudo dnf install qemu-user-static
```

```sh
podman run --rm -it --platform linux/arm/v7 docker.io/arm32v7/alpine
```

Inside the container install the binutils package to obtain `as` and `ld`:

```sh
apk add binutils
```

Now assemble with `as` and link with `ld`, then run the resulting executable.

## Benchmarks

Alpine Linux (arm32v7) container using Podman with QEMU user-mode translation:

| Test       | arm-cat | gnu-cat | Ratio |
| ---------- | ------- | ------- | ----- |
| Empty file | 2.4ms   | 8.4ms   | 3.5x  |
| 100MB file | 18.2ms  | 14.6ms  | 1.25x |

For empty files the assembly implementation is faster because it has almost no runtime initialization, while GNU `cat` performs additional setup through libc and coreutils infrastructure. For large files the performance gap becomes small because the workload is dominated by I/O throughput and QEMU translation overhead rather than program startup.

## TODO

- [x] Implement `cp`
- [x] Implement `cat`
- [x] Implement `mv`
- [x] Implement `mkdir`
- [x] Implement `rm`
- [ ] Implement `pwd`
- [x] Implement `rmdir`
- [ ] Implement `tee`
- [ ] Implement `head`
- [ ] Implement `tail`
- [x] Implement `echo`

## License

This project is licensed under the MIT License. See the `LICENSE` file for the full license text.
