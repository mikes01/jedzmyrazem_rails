Teaspoon.configure do |config|
  config.mount_at = '/teaspoon'
  config.root = nil
  config.asset_paths = ['spec/javascripts', 'spec/javascripts/stylesheets']
  config.fixture_paths = ['spec/javascripts/fixtures']
  config.suite do |suite|
    suite.use_framework :jasmine, '2.3.4'
    suite.matcher =
      '{spec/javascripts,app/assets}/**/*_spec.{js,js.coffee,coffee}'
    suite.helper = 'spec_helper'
    suite.boot_partial = 'boot'
    suite.body_partial = 'body'
  end
  config.coverage do |_coverage|
  end
end
