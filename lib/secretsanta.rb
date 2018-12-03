# frozen_string_literal: true

require 'twilio-ruby'

require_relative 'secretsanta/version'

module SecretSanta
  class Error < StandardError; end

  module_function

  def notify_participants!(options)
    client = Twilio::REST::Client.new(options.twilio_account_sid, options.twilio_auth_token)

    generate_mappings(options.participants).each do |mapping|
      client.messages.create(
        body: "Happy holidays! You have been assigned to give a gift to #{mapping.recipient_name} this year.",
        from: options.from_number,
        to: mapping.sender_number
      )
    end
  end

  def generate_mappings(participants_list)
    list = []
    participants = participants_list.each do |p|
      p[:has_assignment] = false
      p[:is_assigned] = false
    end

    loop do
      participants.each do |participant|
        recipient = participants[rand 0..participants.length - 1]

        next if participant[:disallow].includes?(recipient[:name]) ||
                participant[:has_assignment] ||
                recipient[:is_assigned]

        list << { sender_number: participant[:number], recipient_name: recipient[:name] }

        participant[:has_assignment] = true
        recipient[:is_assigned] = true
      end

      break if participants.all? { |p| p[:has_assignment] && p[:is_assigned] }
    end

    list
  end

  def help_text
    <<~HEREDOC
      SecretSanta, version #{VERSION}

      To run, provide command-line arguments or set corresponding environment variables:

      - TWILIO_ACCOUNT_SID
      - TWILIO_AUTH_TOKEN
      - TWILIO_PHONE_NUMBER

      Command-line arguments:

    HEREDOC
  end
end
