# frozen_string_literal: true

# This file is responsible for loading all configuration files.

require_relative 'application'

require 'pry'
require 'securerandom'
require 'dry-validation'

# Register automatically application classes and external dependencies
# from /system/boot folder.
Application.finalize!

# Add existing Logger instance to DB.loggers collection
# Application['database'].loggers << Application['logger']

# # Freeze internal data structures for the Database instance
# Application['database'].freeze unless Application.env == 'development'
