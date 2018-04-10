module FixDBSchemaConflicts
  class AutocorrectConfiguration
    def bundled_file
      at_least_rubocop_49? ? '.rubocop_schema.49.yml' : '.rubocop_schema.yml'
    end

    def custom_file
      File.join(Rails.root, 'config', ".rubocop.fix-db-schema-conflicts.yml")
    end

    def custom_file_exists?
      File.exist? custom_file
    end

    private

    def at_least_rubocop_49?
      Gem::Version.new('0.49.0') <= Gem.loaded_specs['rubocop'].version
    end
  end
end
