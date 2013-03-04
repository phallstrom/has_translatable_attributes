require "has_translatable_attributes/version"
require "has_translatable_attributes/action_view_helper"

module HasTranslatableAttributes

  module Extensions

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def has_translatable_attributes(options = {})

        column_names.select{|name| name =~ /_#{I18n.default_locale}$/}.each do |name_i18n|
          name = name_i18n.sub(/_#{I18n.default_locale}$/, '')
          next if columns_hash.key? name

          class_eval <<-"EOV"

            class << self
              def find_by_#{name}(*arguments)
                send("find_by_#{name}_#\{I18n.locale\}", *arguments)
              end
            end

            def #{name}
              if (val = send("#{name}_#\{I18n.locale\}")).blank? && I18n.locale != I18n.default_locale
                send("#{name}_#\{I18n.default_locale\}")
              else
                val
              end
            end

            def #{name}=(*arguments, &block)
              send("#{name}_#\{I18n.locale\}=", *arguments, &block)
            end
          EOV
        end

      end
    end 

    module InstanceMethods
    end

  end
end

ActiveRecord::Base.send :include, HasTranslatableAttributes::Extensions
