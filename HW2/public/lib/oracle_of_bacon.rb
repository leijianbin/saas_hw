require 'debugger'              # optional, may be helpful
require 'open-uri'              # allows open('http://...') to return body
require 'cgi'                   # for escaping URIs
require 'nokogiri'              # XML parser
require 'active_model'          # for validations

class OracleOfBacon

  class InvalidError < RuntimeError ; end
  class NetworkError < RuntimeError ; end
  class InvalidKeyError < RuntimeError ; end

  attr_accessor :from, :to
  attr_reader :api_key, :response, :uri
  
  include ActiveModel::Validations
  validates_presence_of :from
  validates_presence_of :to
  validates_presence_of :api_key
  validate :from_does_not_equal_to

  def from_does_not_equal_to
    # YOUR CODE HERE
    # "From cannot be the same as To"
    errors.add(:to, 'From cannot be the same as To') unless @from != @to
  end

  def initialize(api_key='')
    # your code here
    @api_key = api_key
    @from = "Kevin Bacon"
    @to = "Kevin Bacon"
  end

  def find_connections
    make_uri_from_arguments
    begin
      xml = URI.parse(uri).read
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
      Net::ProtocolError => e
      # convert all of these into a generic OracleOfBacon::NetworkError,
      # but keep the original error message
      # your code here
      raise NetworkError, e.message
    end
    # your code here: create the OracleOfBacon::Response object
    @response = Response.new(xml)
  end

  def make_uri_from_arguments
    # your code here: set the @uri attribute to properly-escaped URI
    #   constructed from the @from, @to, @api_key arguments
    # http://oracleofbacon.org/cgi-bin/xml?enc=utf-8&p=@api_key&a=@from&b=@to
    @from  = CGI.escape(@from)
    @to = CGI.escape(@to)
    @api_key = CGI.escape(@api_key)
    @uri = "http://oracleofbacon.org/cgi-bin/xml?enc=utf-8&p=#{@api_key}&a=#{@from}&b=#{@to}"
    #p @uri
  end
      
  class Response
    attr_reader :type, :data
    # create a Response object from a string of XML markup.
    def initialize(xml)
      @doc = Nokogiri::XML(xml)
      parse_response
    end

    private

    def parse_response
      if ! @doc.xpath('/error').empty?
        parse_error_response
      # your code here: 'elsif' clauses to handle other responses
      # for responses not matching the 3 basic types, the Response
      # object should have type 'unknown' and data 'unknown response'
      elsif ! @doc.xpath('/link').empty?
        @type = :graph
        @data = []
        @doc.xpath('/link//*').map do |nodedata|
          @data += [nodedata.text]
        end
        # Regular graph - Correct response
      elsif ! @doc.xpath('/spellcheck').empty?
        @type = :spellcheck
        @data = []
        @doc.xpath('/spellcheck//*').map do |nodedata|
          @data += [nodedata.text]
        end
        # Spellcheck - Select a new name based on the suggestions being returned
      else
        @type =:unknown
        @data = 'Unknown response'
        # Any other response         
      end
    end
    def parse_error_response
      @type = :error
      @data = 'Unauthorized access'
    end
  end
end


#test 
oob = OracleOfBacon.new('38b99ce9ec87')

# connect Laurence Olivier to Kevin Bacon
oob.from = 'Laurence Olivier'
oob.find_connections
p oob.response.type      # => :graph
p oob.response.data      # => ['Kevin Bacon', 'The Big Picture (1989)', 'Eddie Albert (I)', 'Carrie (1952)', 'Laurence Olivier']


# connect Carrie Fisher to Ian McKellen
oob.from = 'Carrie Fisher'
oob.to = 'Ian McKellen'
oob.find_connections
p oob.response.type      # => :graph
p oob.response.data      # => ['Ian McKellen', 'Doogal (2006)', ...etc]

# with multiple matches
oob.to = 'Anthony Perkins'
oob.find_connections
p oob.response.type      # => :spellcheck
p oob.response.data      # => ['Anthony Perkins (I)', ...33 more variations of the name]

# cause other error
oob.from = '-09896*'
oob.to = '-09896*sa'
oob.find_connections
p oob.response.type      # => :spellcheck
p oob.response.data      # => ['Anthony Perkins (I)', ...33 more variations of the name]


# with bad key
oob = OracleOfBacon.new('24546dfsg')
oob.find_connections
p oob.response.type      # => :error
p oob.response.data      # => 'Unauthorized access'

