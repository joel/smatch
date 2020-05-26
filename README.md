# SMatch

Helps find similarity between strings, use Levenshtein

### Build

[![Travis CI](https://img.shields.io/travis/joel/smatch.svg?branch=master)](https://travis-ci.org/joel/smatch)

### Maintainability

![Maintenance](https://img.shields.io/maintenance/yes/2019.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/51aa08d8908ab501d537/maintainability)](https://codeclimate.com/github/joel/smatch/maintainability)

### Code Quality

[![Code Climate coverage](https://img.shields.io/codeclimate/coverage/joel/smatch.svg)](https://codeclimate.com/github/joel/smatch)
[![Coverage Status](https://coveralls.io/repos/github/joel/smatch/badge.svg?branch=master)](https://coveralls.io/github/joel/smatch?branch=master)
[![Code Climate issues](https://img.shields.io/codeclimate/issues/joel/smatch.svg)](https://codeclimate.com/github/joel/smatch/issues)
[![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/joel/smatch.svg)](https://codeclimate.com/github/joel/smatch/progress/maintainability)
[![Code Climate maintainability (percentage)](https://img.shields.io/codeclimate/maintainability-percentage/joel/smatch.svg)](https://codeclimate.com/github/joel/smatch/code)
[![Code Climate technical debt](https://img.shields.io/codeclimate/tech-debt/joel/smatch.svg)](https://codeclimate.com/github/joel/smatch/trends/technical_debt)

### Size

![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/joel/smatch.svg)
![GitHub repo size in bytes](https://img.shields.io/github/repo-size/joel/smatch.svg)

### Usage

[![Gem Version](https://badge.fury.io/rb/smatch.svg)](https://badge.fury.io/rb/smatch)
![Gem](https://img.shields.io/gem/dv/smatch/0.1.0.svg)
![Gem](https://img.shields.io/gem/v/smatch.svg)

### Activity

![GitHub All Releases](https://img.shields.io/github/downloads/joel/smatch/total.svg)
![GitHub last commit (master)](https://img.shields.io/github/last-commit/joel/smatch/master.svg)
![GitHub Release Date](https://img.shields.io/github/release-date/joel/smatch.svg)

### Documentation

[![Inline docs](http://inch-ci.org/github/joel/smatch.svg?branch=master)](http://inch-ci.org/github/joel/smatch)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](http://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/gem/v/vcr.svg?style=flat-square)](https://rubygems.org/gems/smatch)

### Security

[![Libraries.io dependency status for latest release](https://img.shields.io/librariesio/release/joel/smatch.svg)](https://libraries.io/github/joel/smatch)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'smatch'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smatch

## Usage

Write usage instructions here

```.shell
Usage: example.rb [options]
    -f, --file INPUT_CSV_FILE_PATH   [REQUIRED] File path
    -a, --algorithm ALGORITHM        [OPTIONAL] Algorithm name
    -s 'NoVo,Hewlett Foundation,Wallace Global Fund',
        --skip                       [OPTIONAL] Skip words
    -m, --max 10                     [OPTIONAL] Max similarities
    -v, --[no-]verbose               [OPTIONAL] Run verbosely
    -h, --help                       Prints this help
        --version                    Show version
bin/refine --file file.csv
```

If you provide a file `.exlude_list` with regex, those values will be ignored over the comparaison

`cat .exclude_list`

```.shell
"SRT Anonymous \d{,2}"
"Anonymous \d{,2}"
"^[A-Z]{,4}$" ACRONYM OR TRYGRAM 
```

```.shell
bin/refine --file sample.csv -v
Select a distance?
  1) equal
  2) close
  3) relatively close
  4) not that close
  5) far
  6) far away
  Choose 1-7 [2]:
(Press tab/right or left to reveal more choices)
```

```.shell
x=============x========================================x=================x==================x============x========x
|   type      |   Id                                   |   New Value     |   Original Value |   Distance |   Rank |
x=============x========================================x=================x==================x============x========x
|   reference |   c0f271cb-8696-43fd-8cc1-bd48e3e083c6 |   Freedom  Inc. |   Freedom  Inc.  |   0        |   1.0  |
|   duplicate |   9b25c2f5-3e4a-41f0-9107-4b0a4a5c812c |   Freedom, Inc. |   Freedom, Inc.  |   1        |   0.96 |
|   duplicate |   bf74cbce-4e32-4133-946e-33f733a15979 |   Freedom Inc.  |   Freedom Inc.   |   1        |   0.96 |
x=============x========================================x=================x=================x=============x========x
Apply? yes
data.size: 0
Saving file...
Bye
```

Provide `sample-1.csv`

```
x========================================x=================x==================x============x========x
|   Id                                   |   New Value     |   Original Value |   Distance |   Rank |
x========================================x=================x==================x============x========x
|   9b25c2f5-3e4a-41f0-9107-4b0a4a5c812c |   Freedom  Inc. |   Freedom, Inc.  |   1        |   0.96 |
|   bf74cbce-4e32-4133-946e-33f733a15979 |   Freedom  Inc. |   Freedom Inc.   |   1        |   0.96 |
|   c0f271cb-8696-43fd-8cc1-bd48e3e083c6 |   Freedom  Inc. |   Freedom  Inc.  |   0        |   1.0  |
|   85e17361-7a70-4ed2-8ecf-1a4c1a820211 |   Free          |   Free           |   0        |   1.0  |
|   c22f4688-47ea-4179-84ff-644805692399 |   Free Dom!     |   Free Dom!      |   0        |   1.0  |
|   e5c9e472-9b05-43d4-b177-ba89ec9927d2 |     Freedo m    |     Freedo m     |   0        |   1.0  |
|   d9fc3b96-49d9-46f4-9bb3-852cdb42b905 |   Freetom       |   Freetom        |   0        |   1.0  |
x========================================x=================x==================x============x========x
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/refining. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Refining project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/refining/blob/master/CODE_OF_CONDUCT.md).
