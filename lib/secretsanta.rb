# frozen_string_literal: true

require 'twilio-ruby'

require_relative 'secretsanta/version'

module SecretSanta
  class Error < StandardError; end

  module_function

  def notify_participants!(options)
    generate_mappings(options.participants)
  end

  private

  def generate_mappings(participants_json)
    participants_json
  end
end
