# frozen_string_literal: true

require 'test_helper'

describe SecretSanta do
  subject do
    ::SecretSanta.new(
      OpenStruct.new(
        dry_run: true,
        from_number: '1-234-567-8910',
        participants: participants
      )
    )
  end

  let(:participants) do
    JSON.parse(File.read('test/data/participants.json'), symbolize_names: true)[:participants]
  end

  describe '::VERSION' do
    it 'must not be nil' do
      refute_nil ::SecretSanta::VERSION
    end
  end

  describe '#generate_pairs' do
    let(:pairs) { subject.generate_pairs }

    it 'generates a list of sender/recipient pairs' do
      pairs.each do |p|
        refute_nil p[:sender_number]
        refute_nil p[:recipient_name]
      end
    end

    it 'respects the blacklist provided in the "disallow" array' do

    end
  end

  describe '#done?' do
    it 'returns false when not done' do
      subject.done?.must_equal false
    end

    it 'returns true when done' do
      subject.generate_pairs

      subject.done?.must_equal true
    end
  end

  describe '#impossible?' do
    describe 'only one participant' do
      let(:participants) { [{ name: 'John Doe', number: '1-800-555-1234' }] }

      it 'returns true' do
        subject.impossible?.must_equal true
      end
    end

    describe 'enough participants' do
      describe 'hash missing keys' do
        let(:participants) do
          [
            { name: 'John Doe', number: '1-800-555-1234' },
            { name: 'Jane Doe' }
          ]
        end

        it 'returns true' do
          subject.impossible?.must_equal true
        end
      end

      describe 'well-formatted file' do
        it 'returns false' do
          subject.impossible?.must_equal false
        end
      end
    end
  end
end
