# tetra – builds RPMs for Java software

`tetra` is a tool to help you build RPM packages for Java projects.

Packaging of Java projects is sometimes hard - mainly because build tools like Maven partially overlap with distro ones like RPM.

See [MOTIVATION.md](MOTIVATION.md) for further information.

## Installation

You need:

* [Ruby 1.9.2](https://www.ruby-lang.org/en/) or later;
* [git](http://git-scm.com/);
* some basic Unix commands: bash, unzip, tar;
* a JDK that can compile whatever software you need to package;
* Fedora only: packages to compile native gems, use `yum install ruby-devel gcc-c++ zlib-devel`;

Install `tetra` via RubyGems:

     gem install tetra

## Workflow

Building a package with `tetra` is quite unusual — this is a deliberate choice, so don't worry. Basic steps are:

* `tetra init <package name> package_sources.tar.gz` to initialize the project and unpack original sources;
* if anything other than `ant` and `mvn` is needed in order to build the project, add it to the `kit/` directory in binary form;
* execute `tetra dry-run`, which will open a bash subshell. In there, build your project, and when you are done conclude quitting it with `Ctrl+D`;
* execute `tetra generate-all`: tetra will scaffold spec files and tarballs.

Done!

### How can that possibly work?

During the dry-run `tetra`:
 - saves your bash history, so that it can use it later to scaffold a build script;
 - keeps track of changed files, in particular produced jars, which are included in the spec's `%files` section;
 - saves files downloaded from the Internet (eg. by Maven) and packs them to later allow networkless builds.

Note that with `tetra` you are not building all dependencies from source - build dependencies are aggregated in a binary-only "blob" package. While this is not ideal it is sufficient to fulfill most open source licenses and to have a repeatable, networkless build, while being a lot easier to automate.

## A commons-collections walkthrough

First, grab the sources:

    wget http://archive.apache.org/dist/commons/collections/source/commons-collections4-4.0-src.tar.gz

Second, ceate a new `tetra` project named `commons-collections` based on those sources:

    tetra init commons-collections commons-collections4-4.0-src.tar.gz
    cd commons-collections

Third, you need to show `tetra` how to build your package. Run `tetra dry-run` and a new subshell will open, in there do anything you would normally do to build the package (in this case, run Maven):

    tetra dry-run

    mvn package

    ^D

Note that you don't even need to install Maven - `tetra` bundles a copy in `kit/` and uses it by default!
Also note that this being a dry-run build, sources will be brought back to their original state after it finishes to ensure repeatability.

Finally, generate build scripts, spec files and tarballs in the `packages/` directory:

    tetra generate-all

Note that `tetra` will generate files for the commons-collections package and all binary-only build-time dependencies in the `packages/` folder.

## In-depth information

In more complex cases building a package will require some special tweaks. We are trying to cover the most common in the [SPECIAL_CASES.md](SPECIAL_CASES.md) file.

An in-depth discussion of this project's motivation is available in the [MOTIVATION.md](MOTIVATION.md) file.

## Status

`tetra` will soon hit 1.0. If you are a packager you can try to use it, any feedback would be **very** welcome!

At the moment `tetra` is tested on openSUSE and Ubuntu.

## Sources

`tetra`'s Git repo is available on GitHub, which can be browsed at:

    https://github.com/SilvioMoioli/tetra

and cloned with:

    git clone git@github.com:SilvioMoioli/tetra.git

## Contact

Are you using `tetra` or even just reading this? Let's get in touch!

    moio at suse dot de

## License

MIT license.
