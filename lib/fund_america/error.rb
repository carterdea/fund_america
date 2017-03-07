module FundAmerica
  class Error < StandardError
    attr_reader :raw_response, :code

    # Contructor method to take response code and parsed_response
    # and give object methods in rescue - e.message and e.parsed_response
    def initialize(raw_response, code)
      @raw_response = raw_response
      @code = code
      super(error_message)
    end

    def parsed_response
      return @parsed_response if @parsed_response
      begin
        @parsed_response = JSON.parse(raw_response)
      rescue
        @parsed_response = raw_response
      end
    end

    # Method to return error message based on the response code
    def error_message
      case code
      when 401 then
        'Authentication error. Your API key is incorrect'
      when 403 then
        "Not authorized. You don't have permission to take action on a particular resource. It may not be owned by your account or it may be in a state where you action cannot be taken (such as attempting to cancel an invested investment)"
      when 404 then
        'Resource was not found'
      when 422 then
        "This usually means you are missing or have supplied invalid parameters for a request: #{parsed_response}"
      when 500 then
        "Internal server error. Something went wrong. This is a bug. Please report it to support immediately"
      else
        'An error occured: #{parsed_response}'
      end
    end

  end
end
