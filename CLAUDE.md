# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Ruby gem that prevents db/schema.rb conflicts in Rails projects by ensuring consistent schema output regardless of the order in which migrations are run. It works by sorting database elements alphabetically and applying Standard auto-fix for consistent formatting.

## Common Development Commands

### Testing
- `rake spec` or `rspec` - Run all tests (default rake task)
- `rspec spec/unit` - Run unit tests only
- `rspec spec/integration` - Run integration tests only
- `rspec spec/unit/autocorrect_configuration_spec.rb` - Run a specific test file
- `rspec spec/unit/autocorrect_configuration_spec.rb:10` - Run a specific test by line number

### Gem Management
- `bundle install` - Install dependencies
- `rake build` - Build the gem
- `rake release` - Release the gem (requires proper credentials)

## Architecture

The gem integrates into Rails through three main components:

### 1. SchemaDumper Patch (`lib/fix_db_schema_conflicts/schema_dumper.rb`)
Uses `SimpleDelegator` to wrap the ActiveRecord connection and intercept calls to `extensions`, `columns`, `indexes`, and `foreign_keys`, returning sorted results. The module is prepended to `ActiveRecord::SchemaDumper` to hook into the schema dump process.

### 2. Railtie Integration (`lib/fix_db_schema_conflicts/railtie.rb`)
Registers the gem with Rails and loads the custom rake task that enhances `db:schema:dump`.

### 3. Rake Task Hook (`lib/fix_db_schema_conflicts/tasks/db.rake`)
Enhances the `db:schema:dump` task to run Standard with auto-fix on the generated schema file. Uses `AutocorrectConfiguration` to determine which Standard config to use:
- Custom config at `config/.standard.fix-db-schema-conflicts.yml` if present
- Bundled config (`.standard_schema.yml`)

### 4. Standard Configuration (`lib/fix_db_schema_conflicts/autocorrect_configuration.rb`)
Checks for custom configuration files in the host Rails application.

## Testing Strategy

- **Unit tests** (`spec/unit/`) test individual components like `AutocorrectConfiguration`
- **Integration tests** (`spec/integration/`) use a full test Rails 8 app at `spec/test-app/` to verify end-to-end functionality by running migrations and verifying that columns and indexes are sorted alphabetically
- The test-app includes migrations that create tables with columns in random orders to verify sorting works correctly

## Important Constraints

- Minimum Ruby version: 2.0+
- Minimum Standard version: 1.0+
- Rails 8.0+ is tested (works with earlier Rails versions)
