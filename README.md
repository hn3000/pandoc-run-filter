
# pandoc-run-filter

Allows to include data extracted from some external source via a script in a [pandoc] document.

Use of this script might be a security risk if you don't trust the source of the document you run through it. (See Caveats below.)

See the end for some notes on installation.


## Usage
Use via --filter:

``````
pandoc --filter pandoc-run-filter
``````

(Must be installed first, of course, see below for some Notes on that.)

The code to run is specified as a code block (or inline code) with an attribute like {run=nodep}.

Example markdown:


``````
There are `find . -type f -print|wc -l`{run=bash} files here:
```{ run=bash }
find . -type f -print
```
``````

Five values are currently supported for the run= attribute:

run= | effect
----|---------------
nodep|run with `node -p`-- output is result of expression
nodee|run with `node -e` -- output must be printed with `console.log`
node|run with node -p, just like nodep
sh|run with `/bin/sh -c`
bash|run with `/bin/bash -c`


By default, the output of the script will be placed in a textblock or inline text, by adding `style=code` to the attributes, you can turn it into a CodeBlock (or Code element) which gets all the original classes and attributes. This can be used to use a script that creates csv and have that processed by the `pantable` filter like this:

``````
There are `find . -type f -print|wc -l`{run=bash} files here:
```{ run=bash  }
find . -type f -print
```
``````


## Examples

Simple calculations using node:

``````markdown
````{ run=nodep }
/* code run with node -p */ Math.round (47.77 * 0.815)
````
``````


Extract some information from a json file (using node, again):

``````markdown
````{ run=nodep style=code}
require('./data/primes-1000.json').slice(0,10)
````
``````

Include the output of a shell script:

``````markdown
````{ run=bash style=code}
require('./data/primes-1000.json').slice(0,10)
````
``````

## Installation

You will need haskell installed (as well as pandoc), it seems [Stack] is currently your best option. I tried it for Mac OS X and Windows and it worked just as described.

For Mac OS X (10.11, not macOS Sierra), I used the Homebrew method:

```bash
brew install haskell-stack
```

For Windows I downloaded the installer linked in the [Stack documentation].

Once you have stack installed, you can simply clone this repository and use `stack install`, like this:

```bash
git clone https://github.com/hn3000/pandoc-run-filter.git
cd pandoc-run-filter
stack install
```

to compile and install the filter.


## Caveats

Although having executable code inside markdown is very convenient for me, it's also a security risk. At least it's no [surprise], that it's turing-complete, because it's intentional and not an [accident] ... not sure, what the [langsec] people would have to say about it. Nothing good, probably.

So, before you run some else's document through this filter, you might want to review the code that it includes.

In addition, this is my first Haskell program. I have been learning everything as I go along.

This is also the reason that unit tests are not implemented, yet: I am not sure how to approach testing the filter and have not looked at how it's done in haskell. There are some examples in the test folder that I have run to see that things work like I want them to.

This also shows that [pandoc is a virus].


[Stack]: https://www.haskell.org/downloads#stack
[Stack documentation]: https://docs.haskellstack.org/en/stable/install_and_upgrade/#windows
[accident]: http://beza1e1.tuxen.de/articles/accidentally_turing_complete.html
[surprise]: https://www.gwern.net/Turing-complete
[pandoc is a virus]: http://www.johnmacfarlane.net/BayHac2014/#/i-created-a-virus
[pandoc]: http://pandoc.org
[langsec]: http://www.cs.dartmouth.edu/~sergey/langsec/occupy/
