# frozen_string_literal: true

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attr, value)
    unless value.present? && self.class.valid_url?(value)
      record.errors.add(attr, "is not a valid URL")
    end
  end

  def self.valid_url?(value)
    uri = URI.parse(value)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end
end
