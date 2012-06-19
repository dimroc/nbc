guard 'coffeescript', 
  :input => 'spec/javascripts', 
  :output => 'spec/javascripts/compiled', 
  :all_on_start => true,
  :error_to_js => true

guard 'livereload' do
  watch(%r{app/views/.+\.(erb|haml|slim)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)/assets/\w+/(.+\.(css|js|html)).*})  { |m| "/assets/#{m[2]}" }
  watch(%r{spec/javascripts/compiled/.+\.js})
end
