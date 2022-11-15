# frozen_string_literal: true

Application.boot(:logger) do
  init do
    require 'logger'
  end

  start do
    # Define logger instance
    logger = Logger.new($stdout)

    # Because the Logger's level is set to WARN, only warning, error and fatal messages are recorded
    logger.level = Logger::WARN if Application.env == 'test'

    # Register logger component
    register(:logger, logger)
  end
end
