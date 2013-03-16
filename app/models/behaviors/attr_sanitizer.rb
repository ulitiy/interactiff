module AttrSanitizer
  extend ActiveSupport::Concern

  module ClassMethods
    def sanitize attribute
      class_eval <<-METHODS
        def #{attribute}_with_sanitize
          Sanitize.clean(#{attribute}_without_sanitize, Sanitize::Config::RELAXED.merge(transformers: Sanitize::youtube_transformer))
        end
        alias_method_chain attribute.to_sym, :sanitize
      METHODS
    end
  end
end
