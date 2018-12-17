# frozen_string_literal: true

require 'twilio-ruby'

class SecretSanta
  class Error < StandardError; end

  VERSION = '1.1.1'

  def initialize(options)
    @dry_run = options.dry_run
    @from_number = options.from_number
    @participants = options.participants
    @sms = Twilio::REST::Client.new(options.twilio_account_sid, options.twilio_auth_token) unless @dry_run
  end

  def notify_participants!
    pairs = generate_pairs

    return pairs if @dry_run

    pairs.each do |pair|
      @sms.messages.create(
        body: "Happy holidays! You have been assigned to give a gift to #{pair.recipient_name} this year.",
        from: @from_number,
        to: pair.sender_number
      )
    rescue Twilio::Rest::TwilioError => e
      puts e.message
    end

    "\nAll participants have been notified. Happy holidays! 🎅 🎄 🎁\n\n"
  end

  def generate_pairs
    raise Error, SecretSanta.error_message if impossible?

    [].tap do |list|
      loop do
        @participants.each do |sender|
          recipient = @participants.sample

          next if try_again?(sender, recipient)

          list << { sender_number: sender[:number], recipient_name: recipient[:name] }

          sender[:has_assignment] = true
          recipient[:is_assigned] = true
        end

        break if done?
      end
    end
  end

  def done?
    @participants.all? { |p| p[:has_assignment] && p[:is_assigned] }
  end

  def impossible?
    @participants.one? || invalid_hash?
  end

  def try_again?(sender, recipient)
    sender[:has_assignment] || recipient[:is_assigned] || sender[:number] == recipient[:number] ||
      !sender[:disallow].nil? && sender[:disallow].include?(recipient[:name])
  end

  def self.help_text
    <<~HEREDOC
      SecretSanta, version #{VERSION}

      To run, provide command-line arguments or set corresponding environment variables:

      - TWILIO_ACCOUNT_SID
      - TWILIO_AUTH_TOKEN
      - TWILIO_PHONE_NUMBER

      Command-line arguments:

    HEREDOC
  end

  def self.error_message
    <<~HEREDOC
      Looks like something is wrong with your participants file. Make sure that it:

        1. Follows the format specified in README.md
        2. Contains enough participants so that everyone can be matched
        3. Doesn't have too many blacklisted participants (see "disallow" array in README.md)
    HEREDOC
  end

  private

  def invalid_hash?
    @participants.each do |participant|
      return true unless %i[name number].all? { |k| participant.key? k }
    end

    false
  end
end
