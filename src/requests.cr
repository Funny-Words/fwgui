require "http/client"
require "json"

module FW::Requests
  # Constants
  CWORD_URI = "https://funnywordsweb.herokuapp.com/api/v1/cword/"
  WORDS_URI = "https://funnywordsweb.herokuapp.com/api/v1/word?w="

  # Get cword from API
  def self.get_cword()
    Hash(String, String).from_json(HTTP::Client.get(CWORD_URI).body)["cword"]
  end

  # Get words from API
  def self.get_words(num)
    Hash(String, Array(String)).from_json(HTTP::Client.get(WORDS_URI+num.to_s).body)["word"].join(" ") if num > 0 && num <= 40
  end

end
