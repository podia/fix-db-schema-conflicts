require 'shellwords'
require_relative '../autocorrect_configuration'

namespace :db do
  namespace :schema do
    task :dump do
      puts "Dumping database schema with fix-db-schema-conflicts gem"

      filename = ENV['SCHEMA'] || if defined? ActiveRecord::Tasks::DatabaseTasks
        File.join(ActiveRecord::Tasks::DatabaseTasks.db_dir, 'schema.rb')
      else
        "#{Rails.root}/db/schema.rb"
      end
      autocorrect_config = FixDBSchemaConflicts::AutocorrectConfiguration.new

      rubocop_config = if autocorrect_config.custom_file_exists?
        autocorrect_config.custom_file
      else
        File.expand_path("../../../../#{autocorrect_config.bundled_file}", __FILE__)
      end

      `bundle exec rubocop --auto-correct --config #{rubocop_config} #{filename.shellescape}`
    end
  end
end
