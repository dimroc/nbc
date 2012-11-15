require 'spec_helper'

feature "JasmineSpecs" do
  scenario "should all pass", js: true do
    visit "/jasmine"
    wait_until do
      page.evaluate_script("jsApiReporter.finished")
    end

    jasmine_results =
      page.evaluate_script(<<-TRUTH_JS)
      _.all(jsApiReporter.results(), function(r) { return r.result == "passed"} )
      TRUTH_JS
    jasmine_results.should be_true
  end
end
