# HasTranslatableAttributes

[![Gem Version](https://badge.fury.io/rb/has_translatable_attributes.png)](http://badge.fury.io/rb/has_translatable_attributes)

## Installation

Add this line to your application's Gemfile:

    gem 'has_translatable_attributes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install has_translatable_attributes

## Usage

    # Assume fields :content_en, :content_es
    class BlogPost < ActiveRecord::Base
      has_translatable_attributes
    end

    bp = BlogPost.new(...)

    I18n.locale = :en
    bp.content == bp.content_en
    bp.content = "Enlish"
    bp.content_en == "English"

    I18n.locale = :es
    bp.content == bp.content_es
    bp.content = "Spanish"
    bp.content_es == "Spanish"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
