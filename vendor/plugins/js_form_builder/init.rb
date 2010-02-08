# Include hook code here
require 'js_form_builder'
require 'js_action_view'

require File.dirname(__FILE__) + "/lib/fields/required_files"

ActionView::Base.send(:include, JsActionView)

# To remove <div class="fieldWithErrors"> around errors.
ActionView::Base.field_error_proc = proc { |input, instance| input } 


# validation_reflection plugin
require 'boiler_plate/validation_reflection'

ActiveRecord::Base.class_eval do
  include BoilerPlate::ActiveRecordExtensions::ValidationReflection
  BoilerPlate::ActiveRecordExtensions::ValidationReflection.load_config
  BoilerPlate::ActiveRecordExtensions::ValidationReflection.install(self)
end
