# OpenPGP Key Transition Statement

Date: April 6, 2025

I am transitioning from my old GPG key to a new one. The old key will
continue to be valid until its expiration date (August 8th, 2025).
However, I'd prefer for all encrypted email correspondence to be
encrypted to the new key, and will be making all signatures going
forward with the new key.

This transition document is signed by both keys to validate the
transition.

## Table of contents

<!-- mtoc-start -->

- [Key Details](#key-details)
  - [Old Key](#old-key)
  - [New Key](#new-key)
- [Verification Instructions](#verification-instructions)
  - [Keys](#keys)
  - [Transition Document](#transition-document)
  - [Verification Steps](#verification-steps)

<!-- mtoc-end -->

## Key Details

### Old Key

```text
pub   ed25519/0x53670DEBCF375780 2021-07-14 [SC] [expires: 2025-08-08]
      Key fingerprint = 9096 5AE1 20F8 E848 979D  EA48 5367 0DEB CF37 5780
```

### New Key

```text
pub   ed25519/0xF1B59F496EE704B0 2025-04-02 [SC] [expires: 2026-04-04]
      Key fingerprint = 4A21 44F7 48E4 F5DC 17C5  E707 F1B5 9F49 6EE7 04B0
```

## Verification Instructions

To fetch both my keys and the clear-signed transition document for
verification:

### Keys

```shell
# Get old key
$ curl -O https://www.anthes.is/pubkeys/eurydice.asc
$ gpg --import eurydice.asc

# Get new key
$ curl -O https://www.anthes.is/pubkeys/F1B59F496EE704B0.asc
$ gpg --import F1B59F496EE704B0.asc
```

### Transition Document

```shell
# Get the transition statement document
$ curl -O https://www.anthes.is/gpg-transition-20250406.txt
```

### Verification Steps

Check the full fingerprints against those listed in this document:

```shell
$ gpg --fingerprint 0x53670DEBCF375780
$ gpg --fingerprint 0xF1B59F496EE704B0
```

Verify that my old key is signed by my new key, and that the new key is
signed by my old key:

```shell
$ gpg --check-sigs 0x53670DEBCF375780
$ gpg --check-sigs 0xF1B59F496EE704B0
```

Verify the transition document has been signed by both keys:

```shell
$ gpg --verify gpg-transition-20250406.txt
```
