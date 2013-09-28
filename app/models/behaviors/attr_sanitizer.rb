module AttrSanitizer
  extend ActiveSupport::Concern

  module ClassMethods
    def sanitize attribute
      class_eval <<-METHODS
        def #{attribute}_with_sanitize
          Sanitize.clean(#{attribute}, Sanitize::Config::RELAXED.merge(transformers: Sanitize::youtube_transformer))
        end
        #_without_sanitize
        def trusted_#{attribute}
          return #{attribute} if game.trusted
          #{attribute}_with_sanitize
        end

        #alias_method_chain attribute.to_sym, :sanitize
      METHODS
    end
  end
end
