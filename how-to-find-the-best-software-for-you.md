# How to find the best software for you

Published: 2024-02-13

With software, there can be so many choices that figuring out where to
start is less easy than it could be, let alone deciding which project
fits your needs best. In my experience, finding good quality software is
usually a matter of taking a moment to ask the right questions and look
in the right places.

One important thing to remember is that it's best to not let "perfect"
get in the way of "good enough." The best software for you is whatever
allows you to achieve your goals while meeting your requirements.

With that said, there's also no reason to let "adequate" get in the way
of "even better." :)

Also, note that I rarely ever go through this formal of a process. Think
of it as a collection of ideas that I wanted to organize.

## Table of contents

- [What's your use case for the software?](#whats-your-use-case-for-the-software)
  - [Questions to determine your software use case](#questions-to-determine-your-software-use-case)
- [What are some methods to find software?](#what-are-some-methods-to-find-software)
- [What are some ways to compare software projects?](#what-are-some-ways-to-compare-software-projects)
  - [How to review open source repositories](#how-to-review-open-source-repositories)
  - [Other things to review and ask](#other-things-to-review-and-ask)

## What's your use case for the software?

There's plenty of software out there, but whether it'll be useful to you
somewhat depends on if it fits your use case. You might find that
understanding your requirements and preferences helps not only with
choosing which project to use---it can also improve your overall
satisfaction with the end result.

Here's a list of questions that could be helpful for determining exactly
what you're looking for in software.

### Questions to determine your software use case

As you read through this list of questions, consider whether the answers
will stay the same in the future or not. It's good to plan a little.
Ideally, by doing so you'll choose the right software for today and
tomorrow (and maybe even the day after that, too).

- What problem will the software solve? If it's going to replace a prior
  solution, what about the previous approach didn't work and what needs
  to be different this time? A good understanding of these things is
  foundational for everything else. At its core, the process of choosing
  software is about finding what would solve a problem you have.

- Is it possible to break that problem down into smaller ones so that
  specialized tools can handle each part more effectively? Sometimes you
  may not even need another application and can handle it with the
  programs you already have, especially if you're good at shell
  scripting.

- Who are the target users and what are their requirements? Consider
  their accessibility requirements and whether the program will be
  usable for them. User interface (UI) and user experience (UX)
  considerations most likely fall under this category as well.

- What functionality is needed? Let's say you have a list of web pages
  and need to take a screenshot of each one. A utility that only checks
  if those websites are still online may be useful for other reasons,
  but it won't do everything you need it to on its own. You might also
  need some features related to tool integration, like the ability to
  work with certain data formats (JSON, XML), databases (SQL, NoSQL),
  APIs, or other common data exchange systems (standard input and
  standard output are among my favorites).

- What functionality _isn't_ needed? The simpler a piece of software is,
  the less places there are in the code for bugs to exist; from
  experience, it can be wise to choose something with enough features to
  comfortably accomplish your end goal. Perhaps you're thinking of
  creating a blog written in Markdown, one that doesn't need dynamic
  elements like JavaScript or PHP. With this in mind, you could
  eliminate complex content management systems and start looking at
  static site generators or Markdown-to-HTML converters instead.

- What operating system(s) and/or environments does the software need to
  be compatible with? Software is generally more useful when you can
  actually install and run it. Though something to keep in mind is that
  you can often deploy programs in a container or virtual machine if
  needed (or you could try porting it to your platform, if you feel like
  doing that).

- What are your privacy and security requirements? To give a meaningful
  answer, you need to know the answer to this question first: what's
  your threat model? There's little sense in assuming that something is
  private or secure without a threat model, since it's unknown what it's
  secured against or what's kept private from whom. Thinking about these
  things will help you protect your assets more effectively and could
  save you some headaches.

- Do you have any preferences or requirements when it comes to software
  licensing, source code availability, and things of this nature? Here
  are some examples of where the differences between open source
  licenses in particular can be important to think about.

  - Perhaps you need to incorporate some open source code into
    proprietary software, or maybe you favor ease of adoption. In this
    case, something with a permissive license could work well (MIT, BSD,
    ISC, etc).
  - If you feel strongly that source code, including any derivative
    works, should always remain open to all, then you may want to
    consider a copyleft license (GPL, AGPL, MPL, etc).

- What other constraints do you have? These can be factors like
  performance, scalability, user support, compliance with standards and
  regulations, and so on. Knowing these things allows you to prioritize
  the options that are most likely to work for you.

## What are some methods to find software?

Now that you have a better idea of what you need, you can start
searching for software. There are many different ways you can go about
this. Remember to verify that a given resource is worth placing your
trust in before following any instructions or taking any advice.

- Searching websites or applications that provide or index software. This
  is the most direct option, and it's good to be familiar with them
  since you'll need these at some point anyway. However, sometimes it
  can take some digging to figure out how to find things. Browsing
  topics or "awesome lists" on a place like GitHub can provide some
  insight into what's available.

- Reading discussions (think forums, chatrooms, and mailing lists, to
  name a few), wikis, blogs, or other written resources that concern
  something relevant to the kind of software you're looking for. You can
  get some good ideas by visiting these places and skimming through
  them.

- Consulting other forms of media such as videos. These tend to take
  more time, or at least they do for me. However, they're still valuable
  and can lead to some good finds.

- Prompting large language models (LLMs) to brainstorm ideas with you,
  make suggestions, and explain concepts. It's usually good to remain a
  little skeptical and fact check the output to make sure that it's
  legitimate. Artificial intelligence (AI) is promising despite its
  current limitations, and I'm interested to see how it develops.

- Asking knowledgeable people what they use, how they found it, and why
  they chose it over the alternatives. The best way to get a good
  response from people is to ask good questions and show them that you
  value their time; in other words, it should be evident that you've
  already done some research, such as using a search engine and
  consulting other publicly available resources.

## What are some ways to compare software projects?

Once you've found some software through trustworthy means that fits your
use case, it raises another question: how do you decide between them?

There are certain positive signals that can indicate that a project is
worth keeping in mind. They don't offer any guarantee of code quality;
only examining the code itself can provide that. Even so, these have
been good heuristics (rules of thumb) to follow for me because many of
them do seem to be correlated with code quality.

Though if you have sufficient time, motivation, and skill, reading
through the source code is a good idea.

### How to review open source repositories

Here are some things to take a look at when reviewing open source
projects. Some of these are going to depend on the frontend (GitHub,
Gitlab, etc).

- A priority in many cases is to check the license and README, ensuring
  that everything there fits with your goals and use case.

- Check what programming languages are used. Are you able to fix or
  extend software written in those languages? Do you like something
  about the programming language used for one project more than the
  language used by another?

- Is there a security policy? If so, what does it say? Vulnerability
  disclosure programs, bug bounties, and regular audits are good things
  to see.

- Are best practices and standards in the industry generally present
  (tests, linters and static analysis tools, continuous integration and
  continuous delivery, conventional commits, semantic versioning, etc)?

- When was the project first started? Repositories that have been active
  for a while may be more likely to stick around.

- What different types of activity are happening and how recently have
  they occurred? These are ways to see if a project is still being
  actively maintained, which means resolution of bugs and
  vulnerabilities may be more likely. Remember that the simpler the code
  is, the less maintenance it probably needs.

  - When was the last commit?
  - How frequently does this repository get new commits in general?
  - When was the last release?
  - How frequently are new releases made in general?
  - What other kinds of activity happened in the past month?

- Indicators of popularity, such as the number of stars and forks. But
  be careful with these. Fake stars and forks have been available for
  purchase in various places for a while now.

  - One idea is to glance at the forks and see if any of them have
    significant activity. Look at the accounts responsible for the more
    popular forks and check for things that are more difficult to fake,
    like merged pull requests in reputable repositories that they don't
    own.

- The number of people that regularly contribute. Bus factor is
  something to consider---how many people would have to get hit by a bus
  for the entire thing to stall indefinitely? Is that an acceptable
  level of risk for something you may be consistently using? Are you
  willing to maintain it yourself if the project suddenly goes dormant?

- Open and closed issues. Observe the ratio between them and apply
  various filters, combining them if it seems interesting. The manner in
  which problems are resolved can speak volumes about the level of care
  put into the software.

  - Sort by number of comments, from greatest to least. These are in
    some way significant to the community. The same goes for sorting by
    reactions.
  - Sort by update time, from most recent to least, as a way of gleaning
    where people's attention is going.
  - Any issues with interesting labels, especially those related to
    security. Closed issues with a label like "wontfix" or "invalid" can
    also be illuminating.
  - Issues opened by important people, like the author of the
    repository.
  - Pinned issues.

- Pull requests. Ideally, there will be a certain degree of scrutiny
  present, and yet also a willingness to accept good contributions. You
  can use many of the same sorting and filtering options as before.

  - Closed pull requests, both merged and unmerged.
  - Open pull requests that are linked to issues (you can do this the
    other way around, too).
  - Are there procedures that need to be followed to contribute? Are
    pull requests reviewed by multiple people before merge? Both are
    good signs.

- The documentation. READMEs, manuals, official wikis and blogs, release
  notes, etc.

  - How much effort has been put into the documentation? You could look
    at commits and pull requests related to this, but it can be
    determined by feel as well.
  - Is the documentation up to date? Does it make sense to you?

- How many external dependencies does the project pull in? These are
  additional unknowns that you're implicitly placing your trust in when
  you use the software. Dependencies aren't inherently a good or bad
  thing, so much as they are another data point to consider.

### Other things to review and ask

- See if you can find the project on a website that lists publicly
  disclosed vulnerabilities. What vulnerabilities have come up before
  and are there any patterns? For instance: does the same class of
  vulnerability keep cropping up? Are vulnerabilities typically severe
  with low exploit complexity?

- Have any security audits been performed, and are they done on a
  consistent basis? What were the results? What did the security
  researchers think of the product's overall design?

- How have the developers handled vulnerabilities in the past? Have
  they been consistently transparent with their users when it comes to
  security issues?

- Do the developers cryptographically sign their releases and/or commits
  to provide a greater degree of safety for the users?

- Can you install the software through your system's package manager?

- Do some research and find other places that mention the software,
  especially community oriented ones that aren't owned or moderated by
  the creators. What are other people saying about it?

- If there's a company behind the software, what are the public's
  impressions of that company? Are there indications that the company
  cares about its users and the quality of its product? Where does their
  money come from and where does it go?

- Look through any important documents, like terms of service and
  privacy policy. Is there anything interesting or out of place there?

- If there's a dedicated website, is it put together in a logical,
  effective fashion? Not "do I like the website aesthetically speaking",
  but "from an engineering standpoint, is this website intelligently
  designed for what it needs to do?" Plain, fast, and functional is a
  much better sign than flashy, slow, and nearly disintegrating.

- You can throw the software into a virtual machine you don't use for
  anything else and run it to study its behavior.
