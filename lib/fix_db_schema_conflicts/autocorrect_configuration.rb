module FixDBSchemaConflicts
  class AutocorrectConfiguration
    def bundled_file
      '.standard_schema.yml'
    end

    def custom_file
      File.join(Rails.root, 'config', ".standard.fix-db-schema-conflicts.yml")
    end

    def custom_file_exists?
      File.exist? custom_file
    end
  end
end
