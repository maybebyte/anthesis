# Font comparison and review: Atkinson Hyperlegible Mono

Published: July 22nd, 2025

Updated: July 22nd, 2025

Recently, I modified `anthes.is` to use Atkinson Hyperlegible Next for
sans-serif and Atkinson Hyperlegible Mono for monospace. Following the
principle of [eating your own dog
food](https://en.wikipedia.org/wiki/Eating_your_own_dog_food), I also
switched to Atkinson Hyperlegible Mono in my terminal. After a month of
daily use, I can now assess this font's practical advantages and compare
it to established programming fonts like JetBrains Mono and Fira Code.

Download links:

- [Google Fonts GitHub repository (recommended)](https://github.com/googlefonts/atkinson-hyperlegible-next-mono)
- [Official download link (requires email and EULA)](https://www.brailleinstitute.org/freefont/)
- [Nerd Fonts release that added Atkinson Hyperlegible Mono](https://github.com/ryanoasis/nerd-fonts/releases/tag/v3.4.0)

## Table of contents

<!-- mtoc-start -->

- [On character distinction and readability](#on-character-distinction-and-readability)
  - [Multi-character homoglyphs](#multi-character-homoglyphs)
  - [Single character homoglyphs](#single-character-homoglyphs)
  - [Mirror image glyphs](#mirror-image-glyphs)
  - [Scenarios where character distinction matters](#scenarios-where-character-distinction-matters)
- [About the Atkinson Hyperlegible font family](#about-the-atkinson-hyperlegible-font-family)
- [The Atkinson Hyperlegible family's unique design features](#the-atkinson-hyperlegible-familys-unique-design-features)
  - [Distinct silhouettes](#distinct-silhouettes)
  - [Enhanced letterforms](#enhanced-letterforms)
  - [Asymmetrical spurs and exaggerated descenders](#asymmetrical-spurs-and-exaggerated-descenders)
- [Comparison to JetBrains Mono and Fira Code](#comparison-to-jetbrains-mono-and-fira-code)
  - [Single homoglyphs comparison](#single-homoglyphs-comparison)
  - [Mirror glyphs comparison](#mirror-glyphs-comparison)
  - [Programming symbols comparison](#programming-symbols-comparison)
- [Installation and configuration](#installation-and-configuration)
- [Caveats](#caveats)
- [Other resources](#other-resources)

<!-- mtoc-end -->

## On character distinction and readability

Understanding Atkinson Hyperlegible Mono's strengths requires examining
the readability challenges programming fonts must address. While many
fonts distinguish between `0` and `O`, or `1`, `l`, and `I`, these
represent only two of many cases where character distinction matters.

Typographers call lookalike characters "homoglyphs." The examples below
showcase both homoglyphs and "mirror image" glyphs. Screenshots in this
section come from [Evaluating Fonts: Font Family Selection for
Accessibility & Display
Readability](https://www.researchgate.net/publication/338149302_Evaluating_Fonts_Font_Family_Selection_for_Accessibility_Display_Readability).

### Multi-character homoglyphs

Multi-character homoglyphs occur when a sequence of glyphs appear to
form a single character. For example, `cl` can resemble `d`. Monospace
fonts reduce this problem, since each character occupies equal
horizontal space.

![Typography comparison titled 'WORSE' in black text. Shows two fonts in
red text: 'Arial Narrow: rn m, cl d, cj g, vv w, vy w' and 'Josefin: rn
m, cl d, cj g, vv
w'.](/images/worse_multi_homoglyphs.9ba5e76ebd864cbdaac843e51f7a52470bdc502fe1934213bb18d1af2a560366.png)

![Typography comparison titled 'BETTER' in black text. Shows two fonts
in green text: 'Convergence: rn m, cl d, cj g, vv w, vy w' and 'Quando:
rn m, cl d, cj g, vv
w'.](/images/better_multi_homoglyphs.83ce20dfc661b5a4395cfb9e2ec43e7a31a7778d1271d9b2bcbc037749a5a453.png)

In the "worse" example, letters blend together to resemble different
characters. The "better" examples use subtle details to prevent
this---like Convergence's curly `y` and Quando's serifs.

### Single character homoglyphs

Single character homoglyphs occur when one glyph resembles
another---such as `8` and `B`.

![Typography comparison titled 'WORSE' in black text. Shows four fonts
with character sequences in red text: Arial Narrow displays '5S8B 7Z
QOCG 1lI qgy ce', Fugaz One shows '8B 7Z DO0CG6 1lI aqgy ce yuvw', Gill
Sans displays '5S8B 7Z QO 1lI ce vyw', and Autour One shows 'gq gy yq
aqc'.](/images/worse_single_homoglyphs.0e425bfc07bbdf740fe1e37443de701726908c112fa5998885207be37429d928.png)

![Typography comparison titled 'BETTER' in black text. Shows four fonts
with character sequences in green text: DM Serif displays '5S8B 7Z QOCG
1lI qgy ce', SecularOne shows '8B 7Z DO0CG6 1lI aqgy ce yuvw',
Convergence displays '5S8B 7Z QO 1lI ce vyw', and Artifika shows 'gq gy
yq
aqc'.](/images/better_single_homoglyphs.fcdfa02963df88aeb92cd93dfd47b9ca110e2bbda022eee79557121df64cd1cb.png)

Several problems emerge in the "worse" examples.

- In Fugaz One, the `O` and `0` appear indistinguishable. Nearly the
  same applies to `u`, `v`, and `w`.
- The `1`, `l`, and `I` look identical in Gill Sans.

The "better" examples address these concerns through deliberate design
choices. SecularOne uses a circle for `O` and an oval for `0`, while the
`u`, `v`, and `w` maintain distinct shapes.

### Mirror image glyphs

Mirror image glyphs occur when flipping one character creates
another---like `d` and `b`. Serif fonts address this by adding
distinguishing serifs, but sans-serif fonts must find other solutions.

![Typography comparison titled 'WORSE' in black text. Shows 'Montserrat:
db qp gp ae' in red
text.](/images/worse_mirror_glyphs.8730dc20a1819f8824507e06ca929dff365d8bebb597a2ce201587242871837d.png)

![Typography comparison titled 'BETTER' in black text with explanatory
note: '(notice the b is a different shape, not a mirror of d)'. Shows
'Convergence: db qp gp ae' in green
text.](/images/better_mirror_glyphs.726c2e611f5105f7b5033d5f291f34cbb9ca6e5d336be596c82655a272cd0229.png)

Montserrat achieves visual harmony, but creates mirror images.
Convergence solves this with a curly `q` tail and asymmetrical spurs
that distinguish `d` from `b`.

### Scenarios where character distinction matters

Character distinction proves important in several scenarios:

- Debugging the results of a Structured Query Language (SQL) query, like
  `SELECT * FROM users WHERE id = 'B510'`, only to realize you meant
  `SELECT * FROM users WHERE id = '8510'`.
- Copying hexadecimal output by hand from an airgapped machine. Or
  writing down GNU Privacy Guard (GPG) key fingerprints down on paper.
- Distinguishing between similar commit hashes when cherry-picking or
  reverting in git, such as `a1c4e8b` versus `a1c4e8d`.
- Command-line flags, like `-1` and `-l`.

These examples illustrate that visual distinctiveness proves important
in many situations. Still, some questions remain: what informed Atkinson
Hyperlegible's design process, and what makes Atkinson Hyperlegible Mono
special compared to other programming fonts?

## About the Atkinson Hyperlegible font family

The [Atkinson Hyperlegible family comes from the Braille
Institute](https://www.brailleinstitute.org/freefont). Approaching their
centennial in 2019, [the institute hired Applied Design
Works](https://helloapplied.com/atkinson-hyperlegible) to develop a new
brand identity. Applied Design Works needed a font that balanced
character differentiation with visual harmony. When existing fonts
failed to meet their specific accessibility and branding requirements,
they designed their own, naming it after the institute's founder: J.
Robert Atkinson.

[Atkinson Hyperlegible earned Fast Company's 2019 Innovation By Design
award](https://www.fastcompany.com/90395836/this-typeface-hides-a-secret-in-plain-sight-and-thats-the-point).
By 2025, Atkinson Hyperlegible generated over 43 million weekly
impressions via Google Fonts. The [Braille Institute then released
enhanced
versions](https://www.brailleinstitute.org/about-us/news/braille-institute-launches-enhanced-atkinson-hyperlegible-font-to-make-reading-easier/):
Atkinson Hyperlegible Next and Atkinson Hyperlegible Mono.

The *Next* variant of Atkinson Hyperlegible expands from 2 to 7 weights
and extends language support from 27 to 150+ languages. The *Mono*
version addresses what the Braille Institute called "one of the most
requested additions"---a variant for developers.

## The Atkinson Hyperlegible family's unique design features

The Braille Institute, Applied Design Works, and Material Design all
detail these design features. Since visual examples showcase typography
better than descriptions, this article includes images from [Material
Design's blog
post](https://m3.material.io/blog/atkinson-hyperlegible-design).

Annotated images show the proportional version. Where the monospace
version differs significantly, non-annotated comparison images follow.

### Distinct silhouettes

![Atkinson Hyperlegible showing 'B' and '8', with a label below that
says, "Distinct
Silhouettes."](/images/atkinson-hyperlegible-b8-distinct-silhouettes.e28d28c9bf82537bf63b9dc3d9031355e0e99734a417d8d7e87ba28452c3dc5b.png)

The `B` features two bowls of different sizes while the `8` combines a
small circle atop a larger oval.

### Enhanced letterforms

![Atkinson Hyperlegible showing 'jIil!' with three accessibility
features: 1) exaggerated forms 2) selective serifs and 3) increased
inter-letter spacing. Blue annotation circles highlight each legibility
enhancement.](/images/atkinson-hyperlegible-jIil-enhanced-letterforms.d6c13c94926a986aafbe79e9e554515cc19745a298d873f21da2563fbad151e7.png)

This image highlights several enhancements: the `j` features an
exaggerated tail, the `I` gains horizontal top and bottom bars, the `i`
and `l` get serifs, and the `!` increases spacing between its dot and
vertical stroke.

Since these specific glyphs differ significantly between versions,
here's the monospace variant for comparison:

![Atkinson Hyperlegible Mono showing 'jIil!'. Unlike the previous image,
this one doesn't have labels or
annotations.](/images/atkinson-hyperlegible-mono-jIil.cc96702deb6e2a5ef373f53b2ce2dbb8e157870c1e77edb327100a4090e3cc82.png)

Key differences include:

- The `j` and `l` gain longer feet and leftward serifs.
- The `I` extends its horizontal bars.
- The `i` adds a horizontal bottom and longer leftward serif.

### Asymmetrical spurs and exaggerated descenders

![Atkinson Hyperlegible showing 'bdpq' letterform differentiation using
two key techniques: 1) asymmetrical spurs and 2) exaggerated
descenders.](/images/atkinson-hyperlegible-bdpq-asymmetrical-features.be5d9224083a4b62f1b4d08d96bd62fbe61d8d6251938ae1e0428a3e23fbc366.png)

The designers used two techniques to distinguish mirror image glyphs:

1. Asymmetrical spurs distinguish `b` and `d`---the `d` features a
   thicker spur that juts out more.
2. Exaggerated descenders separate `p` and `q`---the `q` extends out
   into a longer, sweeping tail.

## Comparison to JetBrains Mono and Fira Code

How does Atkinson Hyperlegible Mono compare to established programming
fonts like JetBrains Mono and Fira Code? While many monospace fonts
target readability, direct comparison reveals Atkinson Hyperlegible
Mono's specific advantages.

This comparison focuses on legibility features rather than stylistic
preferences or minor aesthetic differences.

### Single homoglyphs comparison

![Font comparison displaying character sequences '5S8B7Z jIil1!' across
JetBrains Mono, Fira Code, and Atkinson Hyperlegible
Mono.](/images/single_homoglyphs_comparison_5S8B.2dec241e59cd770d50a29d42b0d7f0318a907c350f714b30940caf3fa68a76cf.png)

These fonts appear nearly identical at first glance, requiring closer
examination to spot the differences.

- JetBrains Mono adds a serif to the `7` to distinguish it from the
  `Z`.
- Fira Code uses a curved hook on the `j` and smaller curved serif on
  the `l`, distinguishing them within the `jIil1!` group.
- Atkinson Hyperlegible Mono provides the strongest distinction between
  `8`, `B`, `5`, and `S`. The `j` and `l` feature asymmetrical serifs,
  while the `5` uses a diagonal rather than vertical downstroke.

![Font comparison displaying 'CD0OQG6 yuvw' across JetBrains Mono, Fira
Code, and Atkinson Hyperlegible
Mono.](/images/single_homoglyphs_comparison_CD0O.988af4f47fa32b126104687b07c7d62e7195319593e8b54512e5d7e0d93f11e1.png)

Here the differences become more apparent.

- JetBrains Mono struggles with `0`, `O`, and `Q` similarity, though `G`
  and `6` maintain good distinction. `y` and `v` appear more similar than
  in other fonts.
- Fira Code's `0` and `O` distinguish themselves through a slash and
  width variation, but `G` and `6` appear similar.
- Atkinson Hyperlegible Mono excels in this comparison. The `Q` features
  a distinctive middle line, while the `0` uses a reverse slash to avoid
  confusion with the null sign in math and the slashed `O` in
  Danish/Norwegian.

### Mirror glyphs comparison

![Font comparison showing mirror image glyphs 'db qp gp ae' across three
programming fonts: JetBrains Mono, Fira Code, and Atkinson Hyperlegible
Mono](/images/mirror_glyphs_comparison_dbqp.d2a81b693a1faebb609fe096d841d4a5acac74982ff0133737e4055acbf5ffb0.png)

- JetBrains Mono provides the least distinction, with `d`, `b`, `q`, and
  `p` appearing as true mirrors. The `a` and `e` also show similarity.
- Fira Code provides subtle distinction between `d`, `b`, `q`, and `p`,
  though noticing the differences requires close examination. The `g` and
  `p` face the same way, and the `g` appears more ornate. `a` and `e`
  remain distinct.
- Atkinson Hyperlegible Mono achieves the strongest distinction between
  `d`, `b`, `q`, and `p` through its asymmetrical design features. The `a`
  and `e` also maintain clear differentiation.

### Programming symbols comparison

![Font comparison showing programming symbols '\(\)\[\]\{\}\`\'":;.,'
across JetBrains Mono, Fira Code, and Atkinson Hyperlegible
Mono.](/images/programming_symbols_comparison_brackets.6e80af20e769a438d1d180152361408ef1f88cd42dad2157d69d1ac7990c9b17.png)

The programming symbols comparison reveals interesting trade-offs for
Atkinson Hyperlegible Mono.

- JetBrains Mono excels at distinguishing `.` from `,` and `:` from `;`.
  Ditto for `()`, `[]`, and `{}`.
- Fira Code also handles `()`, `[]`, and `{}` well.
- Atkinson Hyperlegible Mono shows weaker `[]` and `{}` distinction.

![Font comparison showing programming symbols '=+-_\~* /\ <>' across
JetBrains Mono, Fira Code, and Atkinson Hyperlegible
Mono.](/images/programming_symbols_comparison_operators.d4a3140fc7b95a005a9ffe6a1a2bf28e187d9fcd1b2719040fec6ea98aa0bce4.png)

- JetBrains Mono maintains consistent horizontal length for `+` and `=`,
  but shortens `-` relative to those operators.
- Fira Code uses uniform length for `+`, `=`, and `-`. `-` and `_` share
  similar length. The `/\` characters join together and render smaller
  compared to the other fonts.
- Atkinson Hyperlegible Mono varies all operator lengths for
  distinction. The `-` and `_` show great differentiation, while `*`
  reduces in size and ascends above `+` for clarity. The `<>` characters
  remain separate rather than joining.

## Installation and configuration

These instructions apply to Unix-like operating systems. In other words:
Linux, Berkeley Software Distribution (BSD) derivatives, and other
similar operating systems.

While the Braille Institute offers direct downloads, they require email
registration and End User License Agreement (EULA) acceptance for an
open source font. Open source repositories provide a better alternative.

Make sure you have git installed and available, then clone the
`googlefonts/atkinson-hyperlegible-next-mono` repository on Github.

```shell
$ git clone https://github.com/googlefonts/atkinson-hyperlegible-next-mono
```

Create the `~/.local/share/fonts` directory.

```shell
$ mkdir -p ~/.local/share/fonts
```

Install Atkinson Hyperlegible Mono in `~/.local/share/fonts`.

```shell
$ cp ./atkinson-hyperlegible-next-mono/fonts/ttf/*.ttf ~/.local/share/fonts/
```

Build font information cache files.

```shell
$ fc-cache -fv
```

Configure Atkinson Hyperlegible Mono as your default monospace font
system-wide and per application. The [Arch Wiki's font configuration
guide](https://wiki.archlinux.org/title/Font_configuration) covers
system-wide setup. Terminal emulators and code editors typically set
font through settings menus or configuration files.

## Caveats

- [Some versions of Atkinson Hyperlegible Mono don't include the backtick/grave
  symbol](https://github.com/googlefonts/atkinson-hyperlegible-next-mono/issues/3).
- Applied Design Works specializes in branding rather than typeface
  design.
- [Max Kohler's development
  notes](https://www.maxkohler.com/notes/2021-02-16-atkinson-hyperreadable/)
  indicate Applied Design Works focused primarily on readers with vision
  difficulties rather than readers with dyslexia, though they expect the
  accessibility features to benefit both groups.
- The font's commercial origins and the creators' branding incentives
  may influence legibility claims.
- Atkinson Hyperlegible Mono lacks programming ligature support. I view
  this as a feature and not a bug, but some may prefer a font with
  ligatures.
- Legibility claims lack peer-reviewed research support. While [Atkinson
  Hyperlegible performed well in the Readability Group
  Survey](https://github.com/thibaudcolas/readability-group-survey), this
  measured preference rather than objective performance. Internal
  testing used vision simulation and reading metrics, but independent
  scientific validation remains absent.

## Other resources

- Pimp My Type offers reviews of both the [original Atkinson
  Hyperlegible](https://pimpmytype.com/font/atkinson-hyperlegible/) and
  [Atkinson Hyperlegible
  Next](https://pimpmytype.com/font/atkinson-hyperlegible-next/), as well
  as [font pairing
  guidance](https://pimpmytype.com/atkinson-hyperlegible-font-pairs/).
- [My bookmarks page](/bookmarks.html) contains links
  related to typography, legibility, and fonts.
