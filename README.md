# Calabash::Extras

Utils for using Calabash and page object pattern with minitest framework

## Installation

Add this line to your application's Gemfile:

    gem 'calabash-extras'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install calabash-extras

## Usage

1. Extend your testcases from Calabash::Extras::TestCase
2. Add Calabash::Extras::PageObjectComparator page objects for Android and Ios (read more on https://github.com/calabash/x-platform-example)
3. Link pages of mobile application and use Calabash::Extras::Walker to navigate
