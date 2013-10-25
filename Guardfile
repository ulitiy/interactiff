guard 'rspec', cmd: "zeus rspec --drb -t ~js" do # -t ~js
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec/" }

  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec/" }
  watch('spec/spec_helper.rb')                        { "spec/" }
  watch('spec/factories.rb')                        { "spec/" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| ["spec/requests/#{m[1]}_spec.rb"] }
  #TODO: attach admin to specs
end

# guard 'brakeman', :run_on_start => true do
#   watch(%r{^app/.+\.(erb|haml|rhtml|rb)$})
#   watch(%r{^config/.+\.rb$})
#   watch(%r{^lib/.+\.rb$})
#   watch('Gemfile')
# end
