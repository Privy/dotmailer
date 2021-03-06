require 'csv'
require 'active_support/core_ext/object/blank'

module DotMailer
  # This is the maximum number of times we will poll the dotMailer
  # API to see if an import has finished.
  MAX_TRIES = 10

  class ContactImport
    def self.import(account, contacts, wait_for_finish = false)
      contact_import = new(account, contacts)

      contact_import.start(wait_for_finish)

      contact_import
    end

    attr_reader :id

    def initialize(account, contacts)
      self.account  = account
      self.contacts = contacts
    end

    def start(wait_for_finish)
      validate_headers

      response = client.post_csv '/contacts/import', contacts_csv

      self.id = response['id']

      wait_until_finished if wait_for_finish
    end

    def status
      if id.nil?
        'NotStarted'
      else
        response = client.get "/contacts/import/#{id}"

        response['status']
      end
    end

    def finished?
      status != 'NotFinished'
    end

    def errors
      raise ImportNotFinished unless finished?

      client.get_csv "/contacts/import/#{id}/report-faults"
    end

    def to_s
      "#{self.class.name} contacts: #{contacts.to_s}"
    end

    def inspect
      to_s
    end

    private
    attr_accessor :contacts, :account
    attr_writer :id

    def client
      account.client
    end

    def contact_headers
      @contact_headers ||= contacts.map(&:keys).flatten.uniq
    end

    def contacts_csv
      @contacts_csv ||= CSV.generate do |csv|
        csv << contact_headers

        contacts.each do |contact|
          csv << contact_headers.map { |header| contact[header] }
        end
      end
    end

    # Check that the contact_headers are all valid (case insensitive)
    def validate_headers
      raise UnknownDataField, unknown_headers.join(',') if unknown_headers.present?
    end

    def unknown_headers
      @unknown_headers ||= contact_headers.reject do |header|
        valid_headers.map(&:downcase).include?(header.downcase)
      end
    end

    def valid_headers
      @valid_headers ||= %w(id email optInType emailType) + account.data_fields.map(&:name)
    end

    def wait_until_finished
      # Wait for the import to finish, backing off in incremental powers
      # of 2, a maximum of MAX_TRIES times.
      #
      # (i.e. 1s, 4s, 9s, 16s, ..., MAX_TRIES ** 2)
      #
      # A MAX_TRIES of 10 means we will wait a total of 385 seconds before
      # giving up.
      finished = (1..MAX_TRIES).detect { |i| sleep(i ** 2) && finished? }
      raise ImportNotFinished unless finished
    end
  end
end
