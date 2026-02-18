require 'spec_helper'
require 'fix_db_schema_conflicts/autocorrect_configuration'
require 'rails'

RSpec.describe FixDBSchemaConflicts::AutocorrectConfiguration do
  subject(:autocorrect_config) { described_class }

  it 'uses the standard schema config' do
    expect(autocorrect_config.new.bundled_file).to eq('.standard_schema.yml')
  end

  it 'with a custom config file' do
    allow(Rails).to receive(:root).and_return File.expand_path("../../test-app", __FILE__)
    expect(autocorrect_config.new.custom_file_exists?).to eq(true)
  end
end
