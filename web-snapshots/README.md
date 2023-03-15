# Web snapshots

This folder gathers website, blog, and documentation snapshots that were
helpful for building this project. A bookmark is useful, but you never know
when a site will go dark forever. Having a local backup at hand is always a
good remedy to information disappearing overnight.

These tools were essential for collecting copies:

- [SingleFile](https://addons.mozilla.org/en-US/firefox/addon/single-file/)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Bash](#bash)
- [NixOS](#nixos)
- [QEMU](#qemu)
- [BATS](#bats)
- [LVM](#lvm)
- [Ext4](#ext4)
- [age](#age)
- [Go](#go)
- [Nix Flakes](#nix-flakes)
- [Nixpkgs](#nixpkgs)
- [SSH](#ssh)
- [EFF](#eff)
- [Python](#python)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

----

`[a]` is link to the local archived version.

## Bash

[Shell style guide][1] [[a]][2]

[Shell Script Best practices][3] [[a]][4]

[Bash getopts builtin command][5] [[a]][6]

[How can I use long options with the Bash getopts builtin?][7] [[a]][8]

[getopts — Parse utility options][9] [[a]][10]

[How would I speed up a full disk dd?][11] [[a]][12]

[How to use patterns in a case statement?][13] [[a]][14]

[Check if an element is present in a Bash array][15] [[a]][16]

[How to create a Bash completion script][17] [[a]][18]

[Completion Files][19] [[a]][20]

## NixOS

[Building a bootable ISO image][21] [[a]][22]

## QEMU

[How to Setup QEMU Output to Console...][23] [[a]][24]

[Deployinga a NixOS configuration into a QEMU VM][25] [[a]][26]

[The usage of memory hot(un)plug in QEMU][71] [[a]][72]

## BATS

[Writing tests][27] [[a]][28]

## LVM

[LVM][29] [[a]][30]

[Cryptsetup close – not working for LVM on LUKS – device busy][31] [[a]][32]

## Ext4

[Ext4][33] [[a]][34]

## age

[Why is statically linking glibc discouraged?][35] [[a]][36]

[Reads input from /dev/tty][37] [[a]][38]

[Default age package compilation flags][39] [[a]][40]

## Go

[Flags needed to create static binaries in golang][41] [[a]][42]

[Go - NixOS Wiki][43] [[a]][44]

[Linking golang statically][45] [[a]][46]

[Statically compiled Go programs, always, even with cgo, using musl][47]
[[a]][48]

[Build flags for a statically linked PIE Go executable][49] [[a]][50]

## Nix Flakes

[Getting Started Using Nix Flakes As An Elixir Development Environment][51]
[[a]][52]

[Nix Flakes: an Introduction][53] [[a]][54]

## Nixpkgs

[Nixpkgs/Modifying Packages][55] [[a]][56]

[Overlays - NixOS Wiki][57] [[a]][58]

[NixOS Series 3: Software Packaging 101][59] [[a]][60]

[Packaging a shell script that has completions][61] [[a]][62]

[How to package my software in nix or write my own package derivation for
nixpkgs][63] [[a]][64]

## SSH

[SSH public key authentication - NixOS Wiki][65] [[a]][66]

## EFF

[EFF Dice-Generated Passphrases][67] [[a]][68]

[EFF's Long Wordlist][69] [[a]][70]

## Python

[Typer Cheat Sheet][73] [[a]][74]

[uv and PEP 723 for Easy Deployment][75] [[a]][76]

[1]: https://google.github.io/styleguide/shellguide.html
[2]: bash/shellguide.html
[3]: https://sharats.me/posts/shell-script-best-practices/
[4]: bash/shell-script-best-practices.html
[5]: https://www.computerhope.com/unix/bash/getopts.htm
[6]: bash/bash-getopts.html
[7]: https://stackoverflow.com/a/30026641
[8]: bash/getopts-long-options.html
[9]: https://www.ibm.com/docs/en/zos/2.1.0?topic=descriptions-getopts-parse-utility-options
[10]: bash/getopts-parse-utility-options.html
[11]: https://askubuntu.com/questions/523037
[12]: bash/speed-up-dd.html
[13]: https://stackoverflow.com/questions/4554718/how-to-use-patterns-in-a-case-statement
[14]: bash/how-to-use-patterns-in-a-case-statement.html
[15]: https://stackoverflow.com/questions/14366390/check-if-an-element-is-present-in-a-bash-array
[16]: bash/check-if-an-element-is-present-in-a-bash-array.html
[17]: https://opensource.com/article/18/3/creating-bash-completion-script
[18]: bash/how-to-create-a-bash-completion-script.html
[19]: https://devmanual.gentoo.org/tasks-reference/completion/index.html
[20]: bash/completion-files.html
[21]: https://nixos.org/guides/building-bootable-iso-image.html
[22]: nixos/building-bootable-iso-image.html
[23]: https://fadeevab.com/how-to-setup-qemu-output-to-console-and-automate-using-shell-script/
[24]: qemu/qemu-output-to-console.html
[25]: https://alpmestan.github.io/notes/nixos-qemu.html
[26]: qemu/deploying-a-nixos-configuration-into-a-qemu-vm.html
[27]: https://bats-core.readthedocs.io/en/stable/writing-tests.html
[28]: bats/writing-tests.html
[29]: https://wiki.archlinux.org/title/LVM
[30]: lvm/LVM.html
[31]: https://linux-blog.anracom.com/2018/11/08/cryptsetup-close-not-working-for-lvm-on-luks-device-busy/
[32]: lvm/lvm-busy.html
[33]: https://wiki.archlinux.org/title/Ext4
[34]: ext4/EXT4.html
[35]: https://stackoverflow.com/questions/57476533/why-is-statically-linking-glibc-discouraged
[36]: age/static-glibc-discouraged.html
[37]: https://github.com/FiloSottile/age/blob/36ae5671cfbb88c591c87a900b2c9a12999ea3b7/cmd/age/tui.go#L105
[38]: age/read-input-from-dev-tty.html
[39]: https://github.com/NixOS/nixpkgs/blob/3751e1e40bfbcc2072b21a800387d87aa52c11c0/pkgs/tools/security/age/default.nix#L36
[40]: age/default-age-package-compilation-flags.html
[41]: https://stackoverflow.com/questions/61319677/flags-needed-to-create-static-binaries-in-golang
[42]: go/flags-needed-to-create-static-binaries-in-golang.html
[43]: https://nixos.wiki/wiki/Go
[44]: go/go.html
[45]: https://blog.hashbangbash.com/2014/04/linking-golang-statically/
[46]: go/linking-golang-statically.html
[47]: https://honnef.co/articles/statically-compiled-go-programs-always-even-with-cgo-using-musl/
[48]: go/statically-compiled-go-programs-always-even-with-cgo-using-musl.html
[49]: https://github.com/golang/go/issues/26492#issuecomment-837053426
[50]: go/build-flags-for-a-statically-linked-pie-go-executable.html
[51]: https://baez.link/getting-started-using-nix-flakes-as-an-elixir-development-environment
[52]: nix-flakes/getting-started-using-nix-flakes-as-an-elixir-development-environment.html
[53]: https://xeiaso.net/blog/nix-flakes-1-2022-02-21
[54]: nix-flakes/nix-flakes-an-introduction.html
[55]: https://nixos.wiki/wiki/Nixpkgs/Modifying_Packages
[56]: nixpkgs/modifying-packages.html
[57]: https://nixos.wiki/wiki/Overlays
[58]: nixpkgs/overlays.html
[59]: https://lantian.pub/en/article/modify-computer/nixos-packaging.lantian/
[60]: nixpkgs/software-packaging-97.html
[61]: https://discourse.nixos.org/t/packaging-a-shell-script-that-has-completions/10290
[62]: nixpkgs/packaging-a-shell-script-that-has-completions.html
[63]: https://unix.stackexchange.com/questions/717168/how-to-package-my-software-in-nix-or-write-my-own-package-derivation-for-nixpkgs
[64]: nixpkgs/how-to-package-my-software-in-nix.html
[65]: https://nixos.wiki/wiki/SSH_public_key_authentication
[66]: ssh/nixos-public-key-authentication.html
[67]: https://www.eff.org/dice
[68]: eff/eff-dice-generated-passphrases.html
[69]: https://www.eff.org/files/2016/07/18/eff_large_wordlist.txt
[70]: eff/eff_large_wordlist.txt
[71]: https://liujunming.top/2022/01/07/The-usage-of-memory-hotplug-under-QEMU-KVM/
[72]: qemu/memory-hotplug-in-qemu.html
[73]: https://gist.github.com/harkabeeparolus/a6e18b1f4f4f938f450090c5e7523f68
[74]: python/typer-cheatsheet.html
[75]: https://thisdavej.com/share-python-scripts-like-a-pro-uv-and-pep-723-for-easy-deployment/
[76]: python/uv-and-pep-723-for-easy-deployment.html
