require 'test/unit'
require 'rubygems'
require 'active_record'
require 'action_controller'
require 'has_translatable_attributes'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  silence_stream(STDOUT) do
    ActiveRecord::Schema.define(:version => 1) do
      create_table :widgets do |t|
        t.column :title_en, :string
        t.column :title_es, :string
        t.column :keywords, :string
      end
    end
  end

  # We need the table to exist first
  Widget.class_eval do
    has_translatable_attributes
  end
end

def teardown_db
  silence_stream(STDOUT) do
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
  end
end

class Widget < ActiveRecord::Base
end

################################################################################

class TestHasTranslatableAttributes < ActiveSupport::TestCase
  def setup
    setup_db
    I18n.available_locales = [:en, :es]
    I18n.default_locale = :en
    I18n.locale = :en
    @widget = Widget.create!(:title_en => 'English', :title_es => 'Spanish', :keywords => 'one two three')
  end

  def teardown
    teardown_db
  end

  def test_responds_to_find_by_title
    assert Widget.respond_to? :find_by_title
  end

  def test_find_by_title
    assert_equal @widget, Widget.find_by_title('English')
  end

  def test_actual_attributes
    assert_equal 'English', @widget.title_en
    assert_equal 'Spanish', @widget.title_es
    assert_equal 'one two three', @widget.keywords
  end

  def test_translated_attributes
    assert_equal 'English', @widget.title
    assert_equal 'one two three', @widget.keywords
    I18n.locale = :es
    assert_equal 'Spanish', @widget.title
    assert_equal 'one two three', @widget.keywords
  end

  def test_title_assignment
    @widget.title = 'Foo'
    assert_equal 'Foo', @widget.title
    I18n.locale = :es
    @widget.title = 'Bar'
    assert_equal 'Bar', @widget.title
  end

  def test_nil_es_translation
    @widget.title_es = nil
    assert_nil @widget.title_es
    assert_equal 'English', @widget.title
    I18n.locale = :es
    assert_equal 'English', @widget.title
  end

  def test_blank_es_translation
    @widget.title_es = ''
    assert_equal '', @widget.title_es
    assert_equal 'English', @widget.title
    I18n.locale = :es
    assert_equal 'English', @widget.title
  end

  def test_nil_en_translation
    @widget.title_en = nil
    assert_nil @widget.title_en
    assert_nil @widget.title
    I18n.locale = :es
    assert_equal 'Spanish', @widget.title
  end

  def test_blank_en_translation
    @widget.title_en = ''
    assert_equal '', @widget.title_en
    assert_equal '', @widget.title
    I18n.locale = :es
    assert_equal 'Spanish', @widget.title
  end
end

