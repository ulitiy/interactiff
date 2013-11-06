module RoutingFilter
  class RefineryLikeLocales < Filter

    def around_recognize(path, env, &block)
      if path =~ %r{^/(#{[:ru,:en].join('|')})(/|$)} && path !~ /^\/locomotive/
        path.sub! %r(^/(([a-zA-Z\-_])*)(?=/|$)) do
          ::I18n.locale = $1
          ''
        end
        path.sub!(%r{^$}) { '/' }
      end

      yield.tap do |params|
        params[:locale] = ::I18n.locale if path !~ /^\/locomotive/
      end
    end

    def native_path? p
      begin
        Rails.application.routes.recognize_path p
      rescue Exception
      end
    end

    def around_generate(params, &block)
      locale = params.delete(:locale) || ::I18n.locale
      skip_locale = params.delete(:skip_locale)

      yield.tap do |result|
        result = result.is_a?(Array) ? result.first : result
        if !skip_locale and
          native_path? result
          result.sub!(%r(^(http.?://[^/]*)?(.*))) { "#{$1}/#{locale}#{$2}" }
        end
      end
    end
  end

end
