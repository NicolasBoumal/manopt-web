# Website for the Manopt toolbox

This repository holds the website that goes with the Manopt toolbox, whose code is in the following repository:

https://github.com/NicolasBoumal/manopt

The website is accessible from https://www.manopt.org

The direct URL for webpages hosted here is: https://nicolasboumal.github.io/manopt-web/


### Notes about Quarto publish command

<https://quarto.org/docs/publishing/github-pages.html#publish-command>

* The main branch contains the source files (mostly Quarto Markdown).
* Locally, while on the main branch, the website is updated with `quarto publish gh-pages --no-browser`
* That generates the website locally and pushes it to the gh-pages branch, in the root directory.
* GitHub serves the website from the root directory of the gh-pages branch directly.
* There is no need to checkout the gh-pages branch locally.
* Pushing changes to the main branch does not update the website.
