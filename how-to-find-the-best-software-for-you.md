# How to find the best software for you

Published: February 14th, 2024

Last updated: July 4th, 2025

With software, there can be so many choices that figuring out where to
start is less easy than it could be, let alone deciding which project
fits your needs best. In my experience, finding good quality software
usually involves taking a moment to ask the right questions and look in
the right places.

One important thing to remember: don't let perfect get in the way of
good enough. The best software for you is whatever helps you achieve
your goals while meeting your requirements.

Also, note that I rarely go through this formal of a process. Think of
it as a collection of ideas that I wanted to organize.

## Table of contents

<!-- mtoc-start -->

- [What's your use case for the software?](#whats-your-use-case-for-the-software)
  - [Questions to determine your software use case](#questions-to-determine-your-software-use-case)
- [What are some methods to find software?](#what-are-some-methods-to-find-software)
- [What are some ways to compare software projects?](#what-are-some-ways-to-compare-software-projects)
  - [How to review open source repositories](#how-to-review-open-source-repositories)
  - [Other things to review and ask](#other-things-to-review-and-ask)

<!-- mtoc-end -->

## What's your use case for the software?

Plenty of software exists. But whether that software is useful to you
depends on if it matches your specific use case. Here's a list of
questions that can help determine exactly what you need.

### Questions to determine your software use case

- What problem does the software solve? If it replaces a prior solution,
  what about the previous approach didn't work and what needs to be
  different this time? Understanding these things provides the foundation
  for everything else. At its core, choosing software involves finding
  what solves a problem you have.

- Can you break that problem into smaller ones so that specialized tools
  can handle each part? Sometimes you may not need another application and
  can handle it with programs you already have, especially if you're good
  at shell scripting.

- Who are the target users and what do they require? Consider their
  accessibility requirements and whether the program fulfills those. User
  Interface (UI) and User Experience (UX) considerations most likely fall
  under this category as well.

- What capabilities do you need? Let's say you have a list of web pages
  and need to take a screenshot of each one. A utility that only checks if
  those websites remain online may prove useful for other reasons, but it
  won't handle everything you need on its own. You might also need
  features related to tool integration, like the ability to work with
  certain data formats, databases, Application Programming Interfaces
  (APIs), or other common data exchange systems.

- What capabilities _aren't_ needed? The simpler a piece of software,
  the fewer places exist in the code for bugs. Perhaps you're thinking of
  creating a blog written in Markdown, one that doesn't need dynamic
  elements like JavaScript or PHP. With this in mind, you could rule out
  content management systems and start looking at static site generators
  or Markdown to HyperText Markup Language (HTML) converters instead.

- What operating systems and/or environments must the software support?
  Software proves more useful when you can actually install and run it.
  On that note, you can often deploy programs in a container or virtual
  machine if needed. Or you can try porting it yourself.

- What are your privacy and security requirements? To give a meaningful
  answer, you need to know your threat model first. There's little sense
  in assuming that something provides privacy or security without a threat
  model, since it remains unknown what it protects from or what stays
  private from whom. Thinking about these things helps you protect your
  assets and could save you some headaches.

- Do you have any preferences or requirements when it comes to software
  licensing, source code availability, and similar factors? Here are some
  examples where the differences between open source licenses in
  particular matter:
  - Perhaps you need to incorporate some open source code into
    proprietary software, or maybe you favor ease of adoption. In this
    case, something with a permissive license could work well.
    Massachusetts Institute of Technology (MIT), Berkeley Software
    Distribution (BSD), and Internet Systems Consortium (ISC) all fall
    under the permissive license category.
  - If you feel strongly that source code, including any derivative
    works, should always remain open to all, then you may want to consider
    a copyleft license. GNU General Public License (GPL), Affero General
    Public License (AGPL), and Mozilla Public License (MPL) all fall under
    the copyleft license category.

- What other constraints do you have? These can include factors like
  performance, scalability, user support, compliance with standards and
  regulations, and so on. Knowing these things helps you focus on the
  options that will most likely work for you.

## What are some methods to find software?

Now that you have a better idea of what you need, you can start
searching for software. Remember to verify that a given resource
deserves your trust before following any instructions or taking any
advice.

- Searching websites or applications that provide or index software.
  This offers the most direct option. However, sometimes it can take
  some digging to figure out how to find things. Browsing topics or
  "awesome lists" on a place like GitHub can provide some insight into
  what's available.

- Reading discussions (think forums, chat rooms, and mailing lists, to
  name a few), wikis, blogs, or other written resources. You can get some
  good ideas by visiting these places and skimming through them.

- Consulting other forms of media such as videos. These tend to take
  more time, or at least they do for me. However, they remain valuable and
  can lead to some good finds.

- Prompting Large Language Models (LLMs) to brainstorm ideas with you,
  make suggestions, and explain concepts. Remember to stay somewhat
  skeptical and fact-check the output to verify legitimacy. Still,
  Artificial Intelligence (AI) shows promise despite its current
  limitations.

- Asking knowledgeable people what they use, how they found it, and why
  they chose it over the alternatives. You'll likely get a better response
  from people if you ask good questions and show them that you value their
  time; in other words, it should be evident that you've already done some
  research, such as using a search engine and consulting other publicly
  available resources.

## What are some ways to compare software projects?

Once you've found some software through trustworthy means that fits your
use case, another question arises: how do you decide between them?

Certain positive signals can indicate that a project deserves
consideration. The signals themselves don't offer any guarantee of code
quality; only examining the code itself can provide that. Even so, these
have been good heuristics (rules of thumb) to follow for me because many
of them correlate with code quality.

Though if you have time, motivation, and skill, reading
through the source code remains a good idea.

### How to review open source repositories

Here are some things to examine when reviewing open source projects.
Some of these will depend on the frontend (GitHub, GitLab, etc).

- Check the license and README, ensuring that everything there fits with
  your goals and use case.

- Check what programming languages the project uses. Can you fix or
  extend software written in those languages? Do you prefer something
  about the programming language used for one project more than the
  language used by another?

- Does a security policy exist? If so, what does it say? Vulnerability
  disclosure programs, bug bounties, and regular audits are good
  signals.

- Do they incorporate best practices and standards in the industry?
  - Tests
  - Linters
  - Static analysis tools
  - Continuous Integration and Continuous Delivery (CI/CD)
  - Conventional commits
  - Semantic versioning

- When did the project first start? Repositories that have remained
  active for a while may be more likely to stick around.

- What different types of activity occur and how recently have they
  happened? These show whether a project receives active maintenance,
  which often means quicker resolution of bugs and vulnerabilities.
  Remember that the simpler the code, the less maintenance it probably
  needs.
  - When did the last commit occur?
  - How frequently does this repository get new commits?
  - When did the last release happen?
  - How frequently do new releases appear?
  - What other kinds of activity happened in the past month?

- Indicators of popularity, such as the number of stars and forks. But
  exercise caution with these. People have been able to buy fake stars and
  forks in various places for a while now.
  - One idea: glance at the forks and see if any of them show
    significant activity. Look at the accounts responsible for the more
    popular forks and check for things that are more difficult to fake,
    like merged pull requests in reputable repositories that they don't
    own.

- The number of people that contribute regularly. Bus factor deserves
  consideration—how many people would have to get hit by a bus for the
  entire thing to stall indefinitely? Does that represent an acceptable
  level of risk for something you may use consistently? Are you willing to
  maintain it yourself if the project goes dormant?

- Open and closed issues. Observe the ratio between them and apply
  various filters, combining them if it seems interesting. The manner in
  which maintainers resolve problems can speak volumes about the level of
  care they put into the software.
  - Sort by number of comments, from greatest to least. These are
    significant to the community in some way. The same goes for sorting by
    reactions.
  - Sort by update time, from most recent to least, as a way of gleaning
    where people's attention goes.
  - Any issues with interesting labels, especially those related to
    security. Closed issues with a label like "wontfix" or "invalid" can
    also be illuminating.
  - Issues opened by important people, like the repository author.
  - Pinned issues.

- Pull requests. Ideally, some degree of scrutiny exists, and yet
  also a willingness to accept good contributions. You can use many of the
  same sorting and filtering options as before.
  - Closed pull requests, both merged and unmerged.
  - Open pull requests that link to issues (you can do this the other
    way around, too).
  - Do procedures exist that contributors need to follow? Do multiple
    people review pull requests before merge? Both are good signals.

- The documentation. READMEs, manuals, official wikis and blogs, release
  notes, etc.
  - How much effort went into the documentation? You could look at
    commits and pull requests related to this, but you can also determine
    this by feel.
  - Does the documentation stay up to date? Does it make sense to you?

- How many external dependencies does the project pull in? These
  represent unknowns that you implicitly trust when you use the
  software. Dependencies aren't inherently good or bad. They just provide
  another data point to consider.

### Other things to review and ask

- See if you can find the project on a website that lists publicly
  disclosed vulnerabilities. What vulnerabilities have appeared before and
  do any patterns exist? For instance: does the same class of
  vulnerability keep cropping up? Do vulnerabilities typically prove
  severe with low exploit complexity?

- Have security researchers performed audits, and do they happen on a
  consistent basis? What were the results? What did the security
  researchers think of the product's design?

- How have the developers handled vulnerabilities in the past? Have they
  maintained transparency with their users when it comes to security
  issues?

- Do the developers cryptographically sign their releases and/or commits?

- Can you install the software through your system's package manager?

- Do some research and find other places that mention the software,
  especially community-oriented ones that the creators don't own or
  moderate. What do other people say about it?

- If there's a company behind the software, what are the public's
  impressions of that company? Do signs exist that the company cares
  about its users and the quality of its product? Where does their money
  come from and where does it go?

- Look through any important documents, like terms of service and
  privacy policy. Does anything interesting or out of place appear there?

- If there's a dedicated website, did they put it together in a logical,
  effective fashion?

- Does the software use a memory-safe programming language?

- You can run the software in a virtual machine you don't use for
  anything else and study its behavior.
