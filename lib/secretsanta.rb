# frozen_string_literal: true

require 'twilio-ruby'

require_relative 'secretsanta/version'

module SecretSanta
  class Error < StandardError; end

  module_function

  def notify_participants!(options)
    client = Twilio::REST::Client.new(options.twilio_account_sid, options.twilio_auth_token)
    pairs = generate_pairs(options.participants)

    return pairs if options.dry_run

    pairs.each do |pair|
      client.messages.create(
        body: "Happy holidays! You have been assigned to give a gift to #{pair.recipient_name} this year.",
        from: options.from_number,
        to: pair.sender_number
      )
    rescue Twilio::Rest::TwilioError => e
      puts e.message
    end

    "\nAll participants have been notified - happy holidays! 🎅 🎄 🎁\n\n"
  end

  def generate_pairs(participants)
    [].tap do |list|
      loop do
        participants.each do |participant|
          index = rand 0..participants.length - 1
          recipient = participants[index]

          next if try_again?(participant, recipient)

          list << { sender_number: participant[:number], recipient_name: recipient[:name] }

          participant[:has_assignment] = true
          participants[index][:is_assigned] = true
        end

        break if done?(participants)
      end
    end
  end

  def try_again?(sender, recipient)
    disallowed = !sender[:disallow].nil? && sender[:disallow].include?(recipient[:name])

    return true if disallowed || sender[:has_assignment] || recipient[:is_assigned]
  end

  def done?(participants)
    participants.all? { |p| p[:has_assignment] && p[:is_assigned] }
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
