module WithVars
  extend ActiveSupport::Concern

  module ClassMethods
    def with_vars attribute
      class_eval <<-METHODS
        def #{attribute}_with_vars options
          eb=EvalBlock.new
          #{attribute}.gsub /{{.*?}}/ do |part|
            part=part.scan(/{{(.*?)}}/)[0][0]
            eb.calculate_value(part,options).to_s
          end
        end
      METHODS
    end
  end
end
