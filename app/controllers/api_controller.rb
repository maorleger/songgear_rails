# frozen_string_literal: true

class ApiController < ActionController::API
  include Response
  include ExceptionHandler
  before_action :set_default_response_format

  private

    def set_default_response_format
      request.format = :json
    end
end
