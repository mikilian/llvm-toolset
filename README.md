# llvm-toolset

Provides compiled LLVM (>= 11.0.0) toolset, CMake and make for [Alpine Linux](https://alpinelinux.org/).

## Pre installed packages

This [image](https://hub.docker.com/r/michaelkilian/llvm-toolset/) uses Alpine Linux 3.12 and comes with the following pre installed packages.

| Name | min. Version
| --- | --- |
| cmake | 3.17.2 |
| make | 4.3 |
| libc-dev | 0.7.3 |
| libstdc++ | 9.3.0 |

[LLVM](https://github.com/llvm/llvm-project) is compiled from source and comes with version >= 11.0.0.
