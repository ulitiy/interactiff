module AttrSanitizer
  extend ActiveSupport::Concern

  module ClassMethods
    def sanitize attribute, options={chain: true}
      class_eval <<-METHODS
        def #{attribute}_with_sanitize
          Sanitize.clean(#{attribute}_without_sanitize, Sanitize::Config::RELAXED)
        end
      METHODS
      alias_method_chain attribute.to_sym, :sanitize unless options[:chain]
    end
  end
end