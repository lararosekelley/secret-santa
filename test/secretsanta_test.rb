# frozen_string_literal: true

require 'test_helper'

describe SecretSanta do
  before do
    participants_file = 'test/data/participants.json'
    @participants = JSON.parse(File.read(participants_file), symbolize_names: true)[:participants]
  end

  describe '::VERSION' do
    it 'must not be nil' do
      refute_nil ::SecretSanta::VERSION
    end
  end

  describe '#generate_pairs' do
    it 'successfully generates a list of sender/recipient pairs for secret santa' do
      pairs = ::SecretSanta.generate_pairs(@participants)

      pairs.each do |p|
        refute_nil p[:sender_number]
        refute_nil p[:recipient_name]
      end
    end
  end

  describe '#try_again?' do
    it 'returns nil if the recipient and sender are not assigned and not in the disallowed list' do
      ::SecretSanta.try_again?(@participants[4], @participants[5]).must_equal nil
    end

    it 'returns true when the sender and/or recipient are in the disallowed list' do
      ::SecretSanta.try_again?(@participants[0], @participants[1]).must_equal true
    end

    it 'returns true when the sender has an assignment' do
      @participants[0][:has_assignment] = true

      ::SecretSanta.try_again?(@participants[0], @participants[2]).must_equal true
    end

    it 'returns true when the recipient has already been assigned' do
      @participants[2][:is_assigned] = true

      ::SecretSanta.try_again?(@participants[0], @participants[2]).must_equal true
    end
  end

  describe '#done?' do
    it 'returns false when not done' do
      ::SecretSanta.done?(@participants).must_equal false
    end

    it 'returns true when done' do
      completed = @participants.each do |p|
        p[:is_assigned] = true
        p[:has_assignment] = true
      end

      ::SecretSanta.done?(completed).must_equal true
    end
  end
end
