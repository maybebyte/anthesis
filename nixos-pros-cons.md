# NixOS review: 8 important pros and cons

Last updated: June 19th, 2023

Before you continue on with my review of NixOS, here's a short list of the advantages and disadvantages I talk about for reference.

Strengths
: Abstraction
: Reproducible builds
: Atomic upgrades
: Rollbacks
: Immutability

Weaknesses
: The learning curve
: Some security concerns
: Requires systemd

## Table of contents

<!-- mtoc-start -->

- [What is NixOS and why might you use it?](#what-is-nixos-and-why-might-you-use-it)
- [What do imperative and declarative mean?](#what-do-imperative-and-declarative-mean)
  - [Enable SSH imperatively](#enable-ssh-imperatively)
  - [Enable SSH declaratively](#enable-ssh-declaratively)
- [NixOS advantages](#nixos-advantages)
  - [Pro #1: Abstraction](#pro-1-abstraction)
  - [Pro #2: Reproducible builds](#pro-2-reproducible-builds)
  - [Pro #3: Atomic upgrades](#pro-3-atomic-upgrades)
  - [Pro #4: Rollbacks](#pro-4-rollbacks)
  - [Pro #5: Immutability](#pro-5-immutability)
- [NixOS disadvantages](#nixos-disadvantages)
  - [Con #1: The learning curve](#con-1-the-learning-curve)
  - [Con #2: Some security concerns](#con-2-some-security-concerns)
  - [Con #3: Requires systemd](#con-3-requires-systemd)
- [Concluding my NixOS review](#concluding-my-nixos-review)

<!-- mtoc-end -->

## What is NixOS and why might you use it?

[NixOS](https://nixos.org/) is a unique Linux distribution. The main thing that makes NixOS special is the ability to describe your desired system layout with the Nix language. To do this, you edit a file named `/etc/nixos/configuration.nix` and then rebuild the system.

Declarative package management and system configuration have some benefits over the imperative approach used by more traditional operating systems. But to meaningfully review the pros and cons of NixOS, we must first understand these terms and how they relate to one another.

If you already know the differences between them, [feel free to skip ahead](#nixos-advantages).

## What do imperative and declarative mean?

The easiest way for me to explain these two concepts is to talk about them in the context of software development.

_Imperative_ programming languages are things like Python and C. To make languages like this useful, you provide step-by-step instructions that lead to your end goal. In other words, **imperative means you write out how to do something**.

Meanwhile, Haskell and Nix are examples of _declarative_ programming languages. Their design allows them to perform the necessary steps on their own when given a proper description. In other words, **declarative means you describe what the end result should be**.

Let's compare the process of activating an SSH service on Arch Linux and NixOS to demonstrate the differences between these two paradigms.

### Enable SSH imperatively

1. Install the `openssh` package.

   ```
   # pacman -S openssh
   ```

2. Enable the service.

   ```
   # systemctl enable ssh
   ```

### Enable SSH declaratively

1. Edit the `/etc/nixos/configuration.nix` file.

   ```
   services.sshd.enable = true;
   ```

2. Rebuild and switch to the new configuration. During the build, NixOS detects that the `sshd` service depends on the `openssh` package, so it installs it.

   ```
   # nixos-rebuild switch
   ```

## NixOS advantages

### Pro #1: Abstraction

The nice thing about NixOS is that a lot of different software can be configured using the same syntax. Compare the way that default fonts are set in the Extensible Markup Language (XML) to the Nix expression.

You may notice that the XML sample only defines serif. Yet right below it, Nix is able to declare default serif, sans-serif, and monospace fonts in less space.

```
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
	<alias>
		<family>serif</family>
		<prefer>
		<family>Liberation Serif</family>
		</prefer>
	</alias>
</fontconfig>
```

```
fonts.fontconfig.defaultFonts = {
	serif = [ "Liberation Serif" ];
	sansSerif = [ "Liberation Sans" ];
	monospace = [ "Liberation Mono" ];
};
```

Note that this will _not_ install font packages for you. There is a separate `fonts.fonts` option where you list each package out.

### Pro #2: Reproducible builds

Reproducibility and deterministic behavior are dense topics. When it comes to NixOS, the idea is that it's easy to recreate a given system configuration. You can copy `/etc/nixos/configuration.nix` over to a different machine and build from it. Assuming that file contains valid Nix expressions, it should yield the same system state.

This means that NixOS is a good Linux distribution for cloud servers, as reliable system deployment is straightforward and built into the OS itself. Additionally, Nix itself is a powerful collaborative tool because creating a development environment with the same version of important libraries is relatively easy to do.

### Pro #3: Atomic upgrades

Another really helpful feature Nix developers included is the avoidance of partial states. When software is designed around this principle, either everything takes effect or nothing does. This is also known as _atomicity_.

Upgrading NixOS is an atomic transaction. Here's a practical example of how that can be useful: if a power outage happens during a rebuild, the packages are still in a consistent state. The system will either use the entire working set of packages from before or after.

### Pro #4: Rollbacks

"Generations" are a key feature of NixOS. If you mess something up, you can roll back to a previous working configuration. The boot loader includes a list of generations to select from as well.

### Pro #5: Immutability

Packages are installed in unique locations within the Nix store (`/nix/store`), and always remain the same once built. The subdirectory for each package is derived from a cryptographic hash of its build dependency graph.

Setting the jargon aside, this means you can easily use multiple versions of the same software—actually, this even applies to identical versions with different build dependencies/flags as far as I know.

## NixOS disadvantages

### Con #1: The learning curve

To manage your system effectively, you'll need to invest some time and effort into learning Nix and related tools. After all, most of the system configuration you would perform by hand with another Linux distro is instead handled with a programming language.

Here's my recommendation: experiment with Nix and see how you feel about it before installing NixOS on bare metal. You'll want to check the [Nix language guide](https://nixos.org/guides/nix-language.html) and follow along to get a sense of how the language works.

### Con #2: Some security concerns

It's always a good idea to see what open issues a software project has before using it—especially those pertaining to security. Here are a few issues in the [nixpkgs repository](https://github.com/NixOS/nixpkgs) to consider before using NixOS.

- [World-readable secrets inside the Nix store](https://github.com/NixOS/nixpkgs/issues/24288)
- [Many NixOS services needlessly run as root](https://github.com/NixOS/nixpkgs/issues/11908)
- [chmod leaves opportunity to leak secrets](https://github.com/NixOS/nixpkgs/issues/121293)
- [Secrets provided in arguments are exposed to unprivileged users](https://github.com/NixOS/nixpkgs/issues/156400)
- [nobody/nogroup shouldn't be used](https://github.com/NixOS/nixpkgs/issues/55370)

Of course, every software project of notable size and scope has _some_ security issues. Decide for yourself what an acceptable threshold is. You might also consult the [NixOS security page](https://nixos.org/community/teams/security.html).

### Con #3: Requires systemd

[NixOS depends on systemd](https://github.com/NixOS/nixpkgs/issues/126797). There's no option to use something different like OpenRC or runit. This will probably remain the case for the foreseeable future.

If you're fine with using a Linux distribution that has systemd, then perhaps this isn't a concern for you. All the same, one drawback of NixOS is that it doesn't enjoy the level of freedom that something like Gentoo has in this regard.

## Concluding my NixOS review

Every system has its strengths and weaknesses, whether it's a Linux distro or otherwise. Software is a tool: to select the right tool for the job, you need to first understand the problem you're looking to solve.

I hope that my NixOS review has given you some reasons to explore the Nix ecosystem, as well as some knowledge to arm yourself with when you do so. Assuming the benefits were compelling to you and the drawbacks seem like things you can live with, you may as well give it a try. Experience is one of the best ways to learn.
