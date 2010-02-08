root = File.dirname(__FILE__)
actions_path = root + "/actions"
helpers_path = root + "/helpers"

actions = [:flash, :request, :translate]
helpers = [:flash, :link, :navigation]

actions.each do |action|
  require actions_path + "/js_" + action.to_s + "_actions"
end

helpers.each do |helper|
  require helpers_path + "/js_" + helper.to_s + "_helpers"
end

require 'block_helpers'