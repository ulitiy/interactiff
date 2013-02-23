module AttrSanitizer
  extend ActiveSupport::Concern

  module ClassMethods
    def sanitize attribute
      class_eval <<-METHODS
        def #{attribute}_with_sanitize
          Sanitize.clean(#{attribute}_without_sanitize, Sanitize::Config::RELAXED)
        end
        alias_method_chain :#{attribute}, :sanitize
      METHODS
    end
  end
end