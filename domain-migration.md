# Migrating to anthes.is

Hey all. I know it has been a while since I have written anything. I am still
around and I have some articles planned that I would like to write, though I
feel it is important to first announce that this website's domain name is
changing.

## When is this happening?

Though I have already registered `anthes.is`, I would like to wait a short
period before creating a `301 Moved Permanently` redirect. I plan to do the
migration at some point after this date and time.

```
Wed Oct  5 18:00:00 UTC 2022
```

## What will happen to the old domain name?

My plan at the moment is to keep `amissing.link` registered indefinitely. If I
change my mind and decide to drop ownership of `amissing.link`, I will
try my best to write about it several months in advance.

That said, do try to switch bookmarks and anything else like that to the new
domain, as this was a decision made with more than aesthetics in mind.

## Why change the domain name?

### DNSSEC

I have wanted to support DNSSEC for some time, given that DNS has some known
weaknesses. It is important to me that readers are directed to the right place
when they try to visit my website, and adding DNSSEC support makes this outcome
more likely.

Note that this will only make a difference under the right conditions (when
those trying to access my website are using resolvers that support DNSSEC). Even
so, I want to do my part in securing DNS. As I understand it, anything that
relies on DNS can benefit from the integrity provided by DNSSEC, so any other
services I host here will benefit from this change as well.

Unfortunately, the domain registrar I use does not support DNSSEC for the
`.link` top-level domain. Certainly there are ways to keep the old domain and
support DNSSEC, such as transferring to a different registrar or using an
external name server, but neither address a separate issue that this does.

### Top-level domains matter

I have learned more about top-level domains between the time `amissing.link` was
first registered and now. The location and jurisdiction of the registry that
owns a top-level domain can have some consequences, and I did not know that
until recently. For instance, the `.us` top-level domain stipulates, among other
things, that all contact information must be provided without omission so that
it can be made public.

I am not all that interested in law or reading through legal documents. There
are many other things I would much rather learn about or do. So I hope it is no
surprise that I want to run this server in peace, and that I would prefer to
worry about things like this as little as possible. Although I have not
personally been in a situation where this was relevant, I would also like to
keep it that way, so that is why I opted for `.is` as a top-level domain.

The [EFF](https://www.eff.org/) has a [white-paper on Internet
registries](https://www.eff.org/files/2017/08/02/domain_registry_whitepaper.pdf)
that may explain this whole thing better than I can.

## Wrapping up

Originally I had planned to write some about the personal meaning behind the new
domain name I chose, but it turned out to be a lengthier explanation than I
anticipated. I decided against including it in this announcement to keep things
brief and on topic, but I would like to write about it in the next article, so
stay tuned.

## Verification (optional)

For those interested in verifying that I am really the one doing this, I have
made the Markdown for this page [available as a .txt
file](/migration/domain-migration.txt), and added a [signed SHA256
file](/migration/SHA256). The signature can be validated with the [appropriate
public key](/pubkeys/eurydice.asc).

I also decided to create a [`signify(1)`](https://man.openbsd.org/signify)
keypair for those that prefer `signify` to GPG. As before, the [signed SHA256
file](/migration/signify/SHA256.sig) is validated with the [appropriate public
key](/pubkeys/sigkey.pub).

I think it makes sense to support both methods because I have not published that
`signify` key before, despite preferring the simplicity of `signify`.

### With GPG

Create a temporary directory and change directory.

```
$ mktemp -d
/tmp/tmp.jeT8T5wNgp
$ cd /tmp/tmp.jeT8T5wNgp
```

Fetch needed files.

```
$ ftp https://amissing.link/migration/domain-migration.txt \
> https://amissing.link/migration/gpg/SHA256.sig \
> https://amissing.link/pubkeys/eurydice.asc > /dev/null
```

Import the public key.

```
$ gpg --import eurydice.asc
gpg: key 53670DEBCF375780: public key "Ashlen <eurydice@riseup.net>" imported
gpg: Total number processed: 1
gpg:               imported: 1
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
```

Verify that I issued the checksum. Note the placeholders for hours, minutes, and
seconds.

```
$ TZ=UTC gpg --verify SHA256.sig
gpg: Signature made Mon Oct  3 hh:mm:ss 2022 UTC
gpg:                using EDDSA key 90965AE120F8E848979DEA4853670DEBCF375780
gpg: Good signature from "Ashlen <eurydice@riseup.net>" [ultimate]
```

Verify that the checksum of `domain-migration.txt` matches.

```
$ sha256 -C SHA256.sig domain-migration.txt
(SHA256) domain-migration.txt: OK
```

### With signify

Create a temporary directory and change directory.

```
$ mktemp -d
/tmp/tmp.RVBcIwTTal
$ cd /tmp/tmp.RVBcIwTTal
```

Fetch needed files.

```
$ ftp https://amissing.link/migration/domain-migration.txt \
> https://amissing.link/migration/signify/SHA256.sig \
> https://amissing.link/pubkeys/sigkey.pub > /dev/null
```

Verify that I issued the checksum and that the checksum of
`domain-migration.txt` matches.

```
$ signify -Cp sigkey.pub -x SHA256.sig
Signature Verified
domain-migration.txt: OK
```
