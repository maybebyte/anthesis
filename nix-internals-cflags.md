# Linux/Unix internals: x86_64 CFLAGS/CXXFLAGS

Published: December 29th, 2024

Updated: January 5th, 2025

As I've been using Gentoo, I've become curious about what kinds of
interesting build flags other systems use to compile their binaries on a
global level, as well as what configure-time flags are set on GCC and
Clang. This article collects these flags for some distributions to make
them easier for me to track down and compare in the future.

Because this is a huge rabbit hole, there are some things I won't be doing in
the interest of time. They're listed in the [Caveats section](#caveats).

Even though this isn't perfect and doesn't list every operating system
I'm interested in having these details for, I feel I should share what I
have so far.

Some relevant documentation can be found in these places:

- [GCC flag docs](https://gcc.gnu.org/onlinedocs/gcc/Option-Summary.html)
- [Clang flag docs](https://clang.llvm.org/docs/ClangCommandLineReference.html)
- [ld(1)](https://www.man7.org/linux/man-pages/man1/ld.1.html) (documents RELRO, BIND_NOW, etc)

If there's something incorrect here, please let me know, either by
[contacting me directly](/contact.html) or by [opening an issue on my
website's GitHub
repository](https://github.com/maybebyte/anthesis/issues) (the latter
would be preferred, but either is fine).

I'm definitely open to [pull
requests](https://github.com/maybebyte/anthesis/pulls), especially to
fix issues. Pull requests to add missing details to anything listed, or
to add new items along with details, are welcome as well. Though it's
unlikely that I'll add in forks of systems already mentioned unless they
differ enough in content to be interesting.

## Table of contents

1. [Arch](#arch)
2. [Alpine](#alpine)
3. [Clear Linux](#clear-linux)
4. [Debian](#debian)
5. [Fedora](#fedora)
6. [Gentoo](#gentoo)
7. [NixOS](#nixos)
8. [OpenBSD](#openbsd)
9. [OpenSUSE](#opensuse)
10. [Solus](#solus)
11. [Ubuntu](#ubuntu)
12. [Void](#void)
13. [Caveats](#caveats)
14. [Areas for improvement](#areas-for-improvement)
15. [Other resources](#other-resources)

## Arch

[According to this
poster](https://bbs.archlinux.org/viewtopic.php?pid=2189095#p2189095),
the build flags can be found in [the x86_64.conf file in the
devtools package](https://gitlab.archlinux.org/archlinux/devtools/-/blob/5c0f8d37d5b1f3c380b49c60f3d2e5e8ab586f62/config/makepkg/x86_64.conf#L43).

CFLAGS:

```shell
-march=x86-64
-mtune=generic
-O2
-pipe
-fno-plt
-fexceptions
-Wp,-D_FORTIFY_SOURCE=3
-Wformat
-Werror=format-security
-fstack-clash-protection
-fcf-protection
-fno-omit-frame-pointer
-mno-omit-leaf-frame-pointer
```

CXXFLAGS:

```shell
$CFLAGS
-Wp,-D_GLIBCXX_ASSERTIONS
```

LDFLAGS:

```shell
-Wl,-O1
-Wl,--sort-common
-Wl,--as-needed
-Wl,-z,relro
-Wl,-z,now
-Wl,-z,pack-relative-relocs
```

LTOFLAGS:

```shell
-flto=auto
```

Here are the [configure-time GCC flags for Arch](https://gitlab.archlinux.org/archlinux/packaging/packages/gcc/-/blob/5d3fc68a98b548026f01eec74707445e8b16413a/PKGBUILD#L76).

Here are the [configure-time Clang flags for Arch](https://gitlab.archlinux.org/archlinux/packaging/packages/clang/-/blob/e8801aceb5f717ae9c8477618e7b0485414eee32/PKGBUILD#L79).

Here are the [configure-time LLVM flags for Arch](https://gitlab.archlinux.org/archlinux/packaging/packages/llvm/-/blob/809803c2eaf4d2c3b526ae77820167d1fab99bb0/PKGBUILD#L81).

## Alpine

Alpine compiles packages using abuild. The
[default.conf](https://git.alpinelinux.org/abuild/tree/default.conf?id=8c47dfcfb16619a4943af8f10628d5042d667ec4)
file has some of the compiler flags used for the distribution.

CFLAGS:

```shell
-Os
-fstack-clash-protection
-Wformat
-Werror=format-security
```

CXXFLAGS:

```shell
-Os
-fstack-clash-protection
-Wformat
-Werror=format-security
-D_GLIBCXX_ASSERTIONS=1
-D_LIBCPP_ENABLE_THREAD_SAFETY_ANNOTATIONS=1
-D_LIBCPP_ENABLE_HARDENED_MODE=1
```

LDFLAGS:

```shell
-Wl,--as-needed,-O1,--sort-common
```

[GCC configuration for Alpine](https://gitlab.alpinelinux.org/alpine/aports/-/blob/b6ad59f82c35cd47d5200d5b5919f7ba20c871e3/main/gcc/APKBUILD#L348).

[Clang configuration for Alpine](https://gitlab.alpinelinux.org/alpine/aports/-/blob/b6ad59f82c35cd47d5200d5b5919f7ba20c871e3/main/clang19/APKBUILD#L85).

[LLVM configuration for Alpine](https://gitlab.alpinelinux.org/alpine/aports/-/blob/b6ad59f82c35cd47d5200d5b5919f7ba20c871e3/main/llvm19/APKBUILD#L141).

[This discussion has some interesting details](https://gitlab.alpinelinux.org/alpine/tsc/-/issues/64).

## Clear Linux

The [performance section in the
documentation](https://www.clearlinux.org/clear-linux-documentation/guides/clear/performance.html)
lays everything out nicely.

- [\__global\_cflags in macros](https://github.com/clearlinux/clr-rpm-config/blob/fdefdfa05363304f341150cf532137ebd5079a71/macros#L538)
- [optflags in rpmrc](https://github.com/clearlinux/clr-rpm-config/blob/fdefdfa05363304f341150cf532137ebd5079a71/rpmrc#L13)

For x86_64, here is what that looks like:

```shell
-O2
-g
-feliminate-unused-debug-types
-pipe
-Wall
-Wp,-D_FORTIFY_SOURCE=2
-fexceptions
-fstack-protector
--param=ssp-buffer-size=64
-Wformat
-Wformat-security
-Wl,-z,now,-z,relro,-z,max-page-size=0x4000,-z,separate-code
-Wno-error
-ftree-vectorize
-ftree-slp-vectorize
-Wl,--enable-new-dtags
-Wl,--build-id=sha1
-ftrivial-auto-var-init=zero
-mrelax-cmpxchg-loop
-m64
-march=westmere
-mtune=skylake-avx512
-fasynchronous-unwind-tables
-Wp,-D_REENTRANT
```

There are some interesting things in here. Two flags in particular I
find really interesting: `-ftrivial-auto-var-init=zero` and
`-mrelax-cmpxchg-loop`.

`-ftrivial-auto-var-init` is a
security-related flag. I've heard that both
ChromiumOS and Android use that flag in some form. Gentoo may add it to
their hardened builds, at least this is what [this open bug would
suggest](https://bugs.gentoo.org/913339).

`-mrelax-cmpxchg-loop` relaxes spin loops in certain conditions,
benefiting thread synchronization. [Here is the GCC bug where it's
discussed](https://gcc.gnu.org/bugzilla/show_bug.cgi?id=103069). [Intel
discusses it a little
here](https://www.intel.com/content/www/us/en/developer/articles/technical/building-innovation-and-performance-with-gcc12.html).

The question of compiler configure-time flags for Clear Linux gets
complicated, because they have separate GCC builds for AVX2 and AVX512.
Here are the [configure-time flags for the main GCC
build](https://github.com/clearlinux-pkgs/gcc/blob/fb236130c0cfccd0ab3e3bf7e8e4d3cc6f3bbc70/gcc.spec#L289).

Similar situation for Clang. Here are the [Clear Linux
configuration-time flags for
Clang/LLVM](https://github.com/clearlinux-pkgs/llvm/blob/3fade2633755c8ddd4b4ce7c91ec37eb6c219880/llvm.spec#L311).

I'm breaking a rule I made for myself a little bit (no per-package
CFLAGS/CXXFLAGS reviewing) to discuss some interesting tweaks Clear
Linux does. [autospec](https://github.com/clearlinux/autospec) is at the
heart of this. A couple of interesting things about autospec and the
packages in [clearlinux-pkgs](https://github.com/clearlinux-pkgs):

- On x86_64, it [enables `-fzero-call-used-regs=used` on
  security-sensitive
  packages](https://github.com/clearlinux/autospec/blob/54240261104357e79455574d5b821860e27de60a/autospec/specfiles.py#L616).
  I found this due to [Seirdy's note on the
  subject](https://seirdy.one/notes/2023/04/17/clang-supports-wiping-call-used-registers).
- [On packages where the `funroll-loops` option is
  set](https://github.com/clearlinux/autospec/blob/54240261104357e79455574d5b821860e27de60a/autospec/specfiles.py#L634)
  (no doubt [a reference/inside
  joke](https://shlomifish.org/humour/by-others/funroll-loops/Gentoo-is-Rice.html)),
  `-O3` is added if `use_clang` was also set. Otherwise,
  `-fno-semantic-interposition` and `-falign-functions=32` are added.

There's a lot to learn from this distribution.

## Debian

[dpkg-buildflags](https://manpages.debian.org/bookworm/dpkg-dev/dpkg-buildflags.1.en.html)
is a Perl script, provided by the `dpkg-dev` package. A lot of the heavy
lifting is done by the libraries sourced by the script, which are in
`/usr/share/perl5/Dpkg`. Those libraries are provided by the
`libdpkg-perl` package (a dependency of `dpkg-dev`).

Debian 12 (Bookworm).

```shell
$ dpkg-buildflags --query
Vendor: Debian
Environment:

Area: future
Features:
 lfs=no
Builtins:

Area: hardening
Features:
 bindnow=no
 format=yes
 fortify=yes
 pie=yes
 relro=yes
 stackprotector=yes
 stackprotectorstrong=yes
Builtins:
 pie=yes

Area: optimize
Features:
 lto=no
Builtins:

Area: qa
Features:
 bug=no
 canary=no
Builtins:

Area: reproducible
Features:
 fixdebugpath=yes
 fixfilepath=yes
 timeless=yes
Builtins:

Area: sanitize
Features:
 address=no
 leak=no
 thread=no
 undefined=no
Builtins:

Flag: ASFLAGS
Value: 
Origin: vendor

Flag: CFLAGS
Value: -g -O2 -ffile-prefix-map=/home/user=. -fstack-protector-strong -Wformat -Werror=format-security
Origin: vendor

Flag: CPPFLAGS
Value: -Wdate-time -D_FORTIFY_SOURCE=2
Origin: vendor

Flag: CXXFLAGS
Value: -g -O2 -ffile-prefix-map=/home/user=. -fstack-protector-strong -Wformat -Werror=format-security
Origin: vendor

Flag: DFLAGS
Value: -frelease
Origin: vendor

Flag: FCFLAGS
Value: -g -O2 -ffile-prefix-map=/home/user=. -fstack-protector-strong
Origin: vendor

Flag: FFLAGS
Value: -g -O2 -ffile-prefix-map=/home/user=. -fstack-protector-strong
Origin: vendor

Flag: GCJFLAGS
Value: -g -O2 -ffile-prefix-map=/home/user=. -fstack-protector-strong
Origin: vendor

Flag: LDFLAGS
Value: -Wl,-z,relro
Origin: vendor

Flag: OBJCFLAGS
Value: -g -O2 -ffile-prefix-map=/home/user=. -fstack-protector-strong -Wformat -Werror=format-security
Origin: vendor

Flag: OBJCXXFLAGS
Value: -g -O2 -ffile-prefix-map=/home/user=. -fstack-protector-strong -Wformat -Werror=format-security
Origin: vendor
```

[Debian's GCC configure-time flags are in this
file](https://salsa.debian.org/toolchain-team/gcc/-/blob/80e847249c0b608ef570071c27feddd47d7ad74b/debian/rules2#L211),
stored in the CONFARGS variable.

[Debian's Clang/LLVM configure-time flags](https://salsa.debian.org/pkg-llvm-team/llvm-toolchain/-/blob/d8936ab77b62cf373bf6d3295a4ac4ecb5a56c70/debian/rules).

## Fedora

Obtained via [RPM
macros](https://docs.fedoraproject.org/en-US/packaging-guidelines/RPMMacros/).

[Build flags docs here](https://src.fedoraproject.org/rpms/redhat-rpm-config/blob/93063bb396395b9a208a2448fdcf55eccf16219e/f/buildflags.md).

These commands were run in a Fedora 40 virtual machine.

```shell
$ rpm --eval "%{optflags}" | tr ' ' '\n' | grep -v '^$'
-O2
-flto=auto
-ffat-lto-objects
-fexceptions
-g
-grecord-gcc-switches
-pipe
-Wall
-Wno-complain-wrong-lang
-Werror=format-security
-Wp,-U_FORTIFY_SOURCE,-D_FORTIFY_SOURCE=3
-Wp,-D_GLIBCXX_ASSERTIONS
-specs=/usr/lib/rpm/redhat/redhat-hardened-cc1
-fstack-protector-strong
-specs=/usr/lib/rpm/redhat/redhat-annobin-cc1
-m64
-march=x86-64
-mtune=generic
-fasynchronous-unwind-tables
-fstack-clash-protection
-fcf-protection
-fno-omit-frame-pointer
-mno-omit-leaf-frame-pointer
```

```shell
$ rpm --eval "%{build_ldflags}" | tr ' ' '\n' | grep -v '^$'
-Wl,-z,relro
-Wl,--as-needed
-Wl,-z,pack-relative-relocs
-Wl,-z,now
-specs=/usr/lib/rpm/redhat/redhat-hardened-ld
-specs=/usr/lib/rpm/redhat/redhat-annobin-cc1
-Wl,--build-id=sha1
```

[Fedora's GCC configure-time
flags](https://src.fedoraproject.org/rpms/gcc/blob/dc203d1b77666d6375f6e5e73dfa9d49a33392a3/f/gcc.spec#_1285).

[Fedora's Clang configure-time
flags](https://src.fedoraproject.org/rpms/llvm/blob/2d83cf0031e0bb176dcb488a6985d26112e8d0b0/f/llvm.spec#_891).

## Gentoo

`/etc/portage/make.conf`, of course. But there are other flags that are
implicitly set as well. The settings depend on things like what USE
flags are set, as an example.

[The build flags mainly seem to be in
toolchain.eclass](https://gitweb.gentoo.org/repo/gentoo.git/tree/eclass/toolchain.eclass?id=8b7d8b342b1379cd768c2d9458bd37ca0540baf3#n768).
[Gentoo's configure-time flags for GCC are in
toolchain.eclass](https://gitweb.gentoo.org/repo/gentoo.git/tree/eclass/toolchain.eclass?id=8b7d8b342b1379cd768c2d9458bd37ca0540baf3#n1166)
as well.

The [referenced patches are located here](https://gitweb.gentoo.org/proj/gcc-patches.git/tree/14.2.0/gentoo).

[Current GCC](https://gitweb.gentoo.org/repo/gentoo.git/tree/sys-devel/gcc/gcc-14.2.1_p20241116.ebuild?id=8b7d8b342b1379cd768c2d9458bd37ca0540baf3).

[Current Clang](https://gitweb.gentoo.org/repo/gentoo.git/tree/llvm-core/clang/clang-19.1.4.ebuild?id=8b7d8b342b1379cd768c2d9458bd37ca0540baf3).

[Current LLVM](https://gitweb.gentoo.org/repo/gentoo.git/tree/llvm-core/llvm/llvm-19.1.6.ebuild?id=8bce482033f18b19b2c57c964e7fb738f2e69985#n371).

The [hardened toolchain changes table in
Project:Toolchain](https://wiki.gentoo.org/wiki/Hardened/Toolchain#Changes)
is worth mentioning as well.

While on the subject of Gentoo: ChromiumOS is interesting to think
about. ChromiumOS is the open source base for ChromeOS on Chromebooks;
it uses Portage, Gentoo's package management system. It probably has
some cool ideas and developments. I haven't looked into it enough to
offer insightful commentary on it---I'd have to sift through a lot of
code to be able to talk about it halfway intelligently.

## NixOS

I'm making a bit of a presumption here: that NixOS doesn't add
CFLAGS/CXXFLAGS beyond what nixpkgs does. I don't really see why it
would, after all, but I felt it was important to note that all the same.

[Hardening flags are mentioned here](https://github.com/NixOS/nixpkgs/blob/0f9814b0086f39e6ffdf17ccb9e2de06875a89a5/doc/stdenv/stdenv.chapter.md#hardening-in-nixpkgs-sec-hardening-in-nixpkgs).

Here are the ones used by default at the time of writing (I verified
this by [copying the .nix file from this
guide](https://nix-tutorial.gitlabpages.inria.fr/nix-tutorial/first-package.html)
and setting `NIX_DEBUG = 2;` in the `pkgs.stdenv.mkDerivation` section,
then built the package):

```shell
-fPIC
-Wformat
-Wformat-security
-Werror=format-security
-fstack-protector-strong
--param ssp-buffer-size=4
-O2
-D_FORTIFY_SOURCE=2
-fno-strict-overflow
-Wl,-z,relro
-Wl,-z,now
```

If `-fzero-call-used-regs=used-gpr` is used, it wasn't printed during the test
build.

[GCC nixpkg](https://github.com/NixOS/nixpkgs/blob/47a040766c7da47a24f7abfae4472866188a9e91/pkgs/development/compilers/gcc/default.nix).

[Clang nixpkg](https://github.com/NixOS/nixpkgs/blob/47a040766c7da47a24f7abfae4472866188a9e91/pkgs/development/compilers/llvm/common/clang/default.nix).

[LLVM nixpkg](https://github.com/NixOS/nixpkgs/blob/47a040766c7da47a24f7abfae4472866188a9e91/pkgs/development/compilers/llvm/common/llvm/default.nix).

## OpenBSD

Local changes to their integrated (and old) version of GCC are described
in [gcc-local](https://man.openbsd.org/gcc-local). The same applies to
[clang-local](https://man.openbsd.org/clang-local), although it's a
current version.

[OpenBSD's GCC port](https://cvsweb.openbsd.org/ports/lang/gcc/) and
[OpenBSD's LLVM port](https://cvsweb.openbsd.org/ports/devel/llvm/).

[Here is the source code for OpenBSD's version of
LLVM/Clang](https://cvsweb.openbsd.org/src/gnu/llvm/). [Same for
GCC](https://cvsweb.openbsd.org/src/gnu/gcc/).

## OpenSUSE

[Line 3581
here](https://web.archive.org/web/20241209164113/https://build.opensuse.org/projects/openSUSE:Factory/prjconf)
should list the options. OpenSUSE:Factory is what they use to build
Tumbleweed packages.

```shell
-O2
-Wall
-U_FORTIFY_SOURCE
-D_FORTIFY_SOURCE=3
-fstack-protector-strong
-funwind-tables
-fasynchronous-unwind-tables
-fstack-clash-protection
-Werror=return-type
%%{?_lto_cflags}
```

There is a [dummy package for GCC
here](https://build.opensuse.org/projects/openSUSE:Factory/packages/gcc/files/gcc.spec?expand=1&rev=78),
and [ditto for
clang/llvm](https://build.opensuse.org/projects/openSUSE:Factory/packages/llvm/files/llvm.spec?expand=1&rev=146).
At the time of writing, the relevant versions are 14 and 19,
respectively.

So, [OpenSUSE's GCC configure-time flags are
here](https://build.opensuse.org/projects/devel:gcc/packages/gcc14/files/gcc14.spec?expand=1&rev=51).
Starts on line 2510.

[OpenSUSE's Clang configure-time flags are
here](https://build.opensuse.org/projects/openSUSE:Factory/packages/llvm19/files/llvm19.spec?expand=1&rev=6).
Starts on line 1092.

## Solus

These are sourced from [this GitHub
issue](https://github.com/getsolus/packages/issues/124). From what I can
tell, the flags are set by [ypkg](https://github.com/getsolus/ypkg).
Specifically,
[ypkgcontext.py](https://github.com/getsolus/ypkg/blob/f6cc1aab08b5b446a61a9d927b3c2887d15e9928/ypkg2/ypkgcontext.py).

To get the latest flags, I guess one would have to figure out how to get
ypkg (or some other piece of the Solus build system) to spit them out
somehow. I haven't done so, but it certainly seems possible.

CFLAGS:

```shell
-mtune=generic
-march=x86-64
-g2
-O2
-pipe
-fno-plt
-fPIC
-Wformat
-Wformat-security
-D_FORTIFY_SOURCE=2
-fstack-protector-strong
--param=ssp-buffer-size=32
-fasynchronous-unwind-tables
-ftree-vectorize
-feliminate-unused-debug-types
-Wall
-Wno-error
-Wp,-D_REENTRANT
```

CXXFLAGS:

```shell
-mtune=generic
-march=x86-64
-g2
-O2
-pipe
-fno-plt
-fPIC
-D_FORTIFY_SOURCE=2
-fstack-protector-strong
--param=ssp-buffer-size=32
-fasynchronous-unwind-tables
-ftree-vectorize
-feliminate-unused-debug-types
-Wall
-Wno-error
-Wp,-D_REENTRANT
```

LDFLAGS:

```shell
-Wl,--copy-dt-needed-entries
-Wl,-O1
-Wl,-z,relro
-Wl,-z,now
-Wl,-z,max-page-size=0x1000
-Wl,-Bsymbolic-functions
-Wl,--sort-common
```

[Solus' GCC configure-time flags are here](https://github.com/getsolus/packages/blob/c79150396860fbf21e420ce6bfff9d90d50e6436/packages/g/gcc/package.yml#L133).

[Solus' Clang/LLVM configure-time flags are here](https://github.com/getsolus/packages/blob/c79150396860fbf21e420ce6bfff9d90d50e6436/packages/l/llvm/package.yml#L493).

## Ubuntu

Retrieved the same way as Debian. Ubuntu 24.10 (oracular).

```shell
$ dpkg-buildflags --query
Vendor: Ubuntu
Environment:

Area: abi
Features:
 lfs=no
 time64=yes
Builtins:
 lfs=yes
 time64=yes

Area: future
Features:
 lfs=no
Builtins:

Area: hardening
Features:
 bindnow=no
 branch=yes
 format=yes
 fortify=yes
 pie=yes
 relro=yes
 stackclash=yes
 stackprotector=yes
 stackprotectorstrong=yes
Builtins:
 pie=yes

Area: optimize
Features:
 lto=yes
Builtins:

Area: qa
Features:
 bug=no
 bug-implicit-func=yes
 canary=no
 elfpackagemetadata=no
 framepointer=yes
Builtins:

Area: reproducible
Features:
 fixdebugpath=yes
 fixfilepath=yes
 timeless=yes
Builtins:

Area: sanitize
Features:
 address=no
 leak=no
 thread=no
 undefined=no
Builtins:

Flag: ASFLAGS
Value: 
Origin: vendor

Flag: ASFLAGS_FOR_BUILD
Value: 
Origin: vendor

Flag: CFLAGS
Value: -g -O2 -Werror=implicit-function-declaration -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/home/ubuntu=. -flto=auto -ffat-lto-objects -fstack-protector-strong -fstack-clash-protection -Wformat -Werror=format-security -fcf-protection
Origin: vendor

Flag: CFLAGS_FOR_BUILD
Value: -g -O2 -Werror=implicit-function-declaration -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/home/ubuntu=. -flto=auto -ffat-lto-objects -fstack-protector-strong -fstack-clash-protection -Wformat -Werror=format-security -fcf-protection
Origin: vendor

Flag: CPPFLAGS
Value: -Wdate-time -D_FORTIFY_SOURCE=3
Origin: vendor

Flag: CPPFLAGS_FOR_BUILD
Value: -Wdate-time -D_FORTIFY_SOURCE=3
Origin: vendor

Flag: CXXFLAGS
Value: -g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/home/ubuntu=. -flto=auto -ffat-lto-objects -fstack-protector-strong -fstack-clash-protection -Wformat -Werror=format-security -fcf-protection
Origin: vendor

Flag: CXXFLAGS_FOR_BUILD
Value: -g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/home/ubuntu=. -flto=auto -ffat-lto-objects -fstack-protector-strong -fstack-clash-protection -Wformat -Werror=format-security -fcf-protection
Origin: vendor

Flag: DFLAGS
Value: -frelease
Origin: vendor

Flag: DFLAGS_FOR_BUILD
Value: -frelease
Origin: vendor

Flag: FCFLAGS
Value: -g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/home/ubuntu=. -flto=auto -ffat-lto-objects -fstack-protector-strong -fstack-clash-protection -fcf-protection
Origin: vendor

Flag: FCFLAGS_FOR_BUILD
Value: -g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/home/ubuntu=. -flto=auto -ffat-lto-objects -fstack-protector-strong -fstack-clash-protection -fcf-protection
Origin: vendor

Flag: FFLAGS
Value: -g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/home/ubuntu=. -flto=auto -ffat-lto-objects -fstack-protector-strong -fstack-clash-protection -fcf-protection
Origin: vendor

Flag: FFLAGS_FOR_BUILD
Value: -g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/home/ubuntu=. -flto=auto -ffat-lto-objects -fstack-protector-strong -fstack-clash-protection -fcf-protection
Origin: vendor

Flag: LDFLAGS
Value: -Wl,-Bsymbolic-functions -flto=auto -ffat-lto-objects -Wl,-z,relro
Origin: vendor

Flag: LDFLAGS_FOR_BUILD
Value: -flto=auto -ffat-lto-objects -Wl,-z,relro
Origin: vendor

Flag: OBJCFLAGS
Value: -g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/home/ubuntu=. -flto=auto -ffat-lto-objects -fstack-protector-strong -fstack-clash-protection -Wformat -Werror=format-security -fcf-protection
Origin: vendor

Flag: OBJCFLAGS_FOR_BUILD
Value: -g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/home/ubuntu=. -flto=auto -ffat-lto-objects -fstack-protector-strong -fstack-clash-protection -Wformat -Werror=format-security -fcf-protection
Origin: vendor

Flag: OBJCXXFLAGS
Value: -g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/home/ubuntu=. -flto=auto -ffat-lto-objects -fstack-protector-strong -fstack-clash-protection -Wformat -Werror=format-security -fcf-protection
Origin: vendor

Flag: OBJCXXFLAGS_FOR_BUILD
Value: -g -O2 -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer -ffile-prefix-map=/home/ubuntu=. -flto=auto -ffat-lto-objects -fstack-protector-strong -fstack-clash-protection -Wformat -Werror=format-security -fcf-protection
Origin: vendor

Flag: RUSTFLAGS
Value: -Cforce-frame-pointers=yes
Origin: vendor

Flag: RUSTFLAGS_FOR_BUILD
Value: 
Origin: vendor
```

Ubuntu Oracular GCC version appears to be 14. [Here is the relevant
Ubuntu GCC
file](https://git.launchpad.net/ubuntu/+source/gcc-defaults/tree/debian/rules?h=ubuntu/oracular&id=00df0a295f4a4436ec08ba729711016ac68c0588#n236)
that I figured that out from. [Ditto for
Clang/LLVM](https://git.launchpad.net/ubuntu/+source/llvm-defaults/tree/debian/rules?h=ubuntu/oracular&id=6914a22e703cf147e4515a4927312fc1dc57346a#n104),
which appears to be 19.

[Ubuntu's GCC configure-time flags begin here](https://git.launchpad.net/ubuntu/+source/gcc-14/tree/debian/rules2?h=ubuntu/oracular&id=196135dbf5be9bda2e279f90063bd5a6b0a9a9a1#n263).

[Ubuntu's LLVM configure-time flags are here](https://git.launchpad.net/ubuntu/+source/llvm-toolchain-19/tree/debian/rules?h=ubuntu/oracular&id=0c82c471ddfc3a1357374ff67564160a9187145d#n847).

## Void

I found these by reasoning out what these files in the [void-packages
repo](https://github.com/void-linux/void-packages) set:

- [defaults.conf](https://github.com/void-linux/void-packages/blob/53b88e33a063b45611f5e3cec12aa6c4b0ab17e2/etc/defaults.conf#L36)
- [x86_64.sh](https://github.com/void-linux/void-packages/blob/53b88e33a063b45611f5e3cec12aa6c4b0ab17e2/common/build-profiles/x86_64.sh)
- [bootstrap.sh](https://github.com/void-linux/void-packages/blob/53b88e33a063b45611f5e3cec12aa6c4b0ab17e2/common/build-profiles/bootstrap.sh)
- [hardening.sh](https://github.com/void-linux/void-packages/blob/53b88e33a063b45611f5e3cec12aa6c4b0ab17e2/common/environment/configure/hardening.sh)

CFLAGS:

```shell
-mtune=generic
-O2
-pipe
-fstack-clash-protection
-D_FORTIFY_SOURCE=2
```

CXXFLAGS:

```shell
-mtune=generic
-O2
-pipe
-fstack-clash-protection
-D_FORTIFY_SOURCE=2
```

LDFLAGS:

```shell
-Wl,--as-needed
-Wl,-z,relro
-Wl,-z,now
```

[Void's GCC configure-time flags are here](https://github.com/void-linux/void-packages/blob/4dcad43166c40b08800bad3c6db1deff3ac4105c/srcpkgs/gcc/template#L205).

[Void's Clang configure-time flags are
here](https://github.com/void-linux/void-packages/blob/4dcad43166c40b08800bad3c6db1deff3ac4105c/srcpkgs/llvm17/template#L7).
The main version of clang used by the distro can be [found in the llvm
package
template](https://github.com/void-linux/void-packages/blob/4dcad43166c40b08800bad3c6db1deff3ac4105c/srcpkgs/llvm/template#L3).

## Caveats

Here are things I haven't done, and why I haven't done them.

- Reviewing each patch for gcc/clang for compilation flags. I had a look
  at their configure-time flags, but reviewing patches takes more time
  than I'm comfortable investing in this at the moment.

- Reviewing the configuration and patches of things other than the
  compiler that influence binary execution, such as binutils, libc, etc.
  These aren't really compilation flags, although still interesting. I
  guess I do make somewhat of an exception for LDFLAGS.

- Reviewing the configuration of every supported compiler. I'm only
  doing GCC and Clang. I won't include their configure-time flags
  inline, but I'll link to where they can be found (since the
  configuration of the compiler is often closely tied to build flags).

- Comparing each architecture per distribution to find architecture
  specific flags. I'm only doing x86_64 for now.

- Covering every single distribution. Generally speaking, outside of
  large forks like Ubuntu, I'm mostly interested in independent
  distributions rather than forks. Mainly because I have a feeling this is
  where the most difference is likely to be observed.

- Covering build flags for every compiled language (Rust, Go, etc).
  These are indeed interesting, but my focus is on C/C++, specifically
  CFLAGS and CXXFLAGS.

My approach favored coverage, not extreme precision. I mostly gathered
compilation flags that I could find in a configuration file (the
equivalent of `/etc/portage/make.conf` for other distributions), through
some light source code reading, or by executing some utility. I had to
limit myself in some ways because otherwise it was unlikely that I'd be
able to release this article anytime soon.

So, please don't take what I've written here as gospel. Something being
absent doesn't necessarily prove anything, as the distribution may have
enabled it in a place that I didn't look. However, something being
present and reflected in the linked source code _does_ prove that a
distribution uses it in that context, or at least used it at the time of
writing.

## Areas for improvement

- Including more distributions and systems. There are a lot of them
  to consider and some of them would be a pain to gather flags for (lots
  of source code review).

- Investigating ChromiumOS and Android in particular.

- Looking more into areas mentioned in the [Caveats section](#caveats)
  (reviewing patches, other toolchain components, etc).

- Probably many others I haven't thought of.

## Other resources

- [Compiler Options Hardening Guide for C and C++](https://best.openssf.org/Compiler-Hardening-Guides/Compiler-Options-Hardening-Guide-for-C-and-C++.html)
- [compiler-flags-distro](https://github.com/jvoisin/compiler-flags-distro): usage of enabled-by-default hardening-related compiler flags across Linux distributions.
