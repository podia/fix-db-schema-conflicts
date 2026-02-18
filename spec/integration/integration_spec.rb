require 'spec_helper'

RSpec.describe 'Fix DB Schema Conflicts' do
  it 'generates a sorted schema' do
    `cd spec/test-app && rm -f db/schema.rb db/test.sqlite3 && bundle exec rake db:migrate RAILS_ENV=test 2>&1`

    schema_content = File.read('spec/test-app/db/schema.rb')

    # Verify columns are sorted alphabetically within each table
    companies_table = schema_content.match(/create_table "companies".*?end/m)[0]
    company_columns = companies_table.scan(/t\.\w+ "(\w+)"/).flatten
    expect(company_columns).to eq(company_columns.sort)

    people_table = schema_content.match(/create_table "people".*?end/m)[0]
    people_columns = people_table.scan(/t\.\w+ "(\w+)"/).flatten
    expect(people_columns).to eq(people_columns.sort)

    # Verify indexes are sorted
    company_indexes = schema_content.scan(/t\.index \["(\w+)"\], name: "index_companies_on_\w+"/).flatten
    expect(company_indexes).to eq(company_indexes.sort)
  end
end
