require 'openssl'
require 'base64'

module NotCaptcha
  module Cypher
    SECRET = '12312312312312312313123'
    def self.encrypt data, time
      cipher = OpenSSL::Cipher::Cipher.new('aes-128-cbc')
      cipher.encrypt
      cipher.padding = 1
      cipher.key = "#{SECRET}#{time}"
      iv = OpenSSL::Random.random_bytes(32)
      cipher.iv = iv

      edata = cipher.update(data)
      edata << cipher.final
      iv.unpack("H*").first.reverse.concat(Base64.encode64(edata).delete("=\n\r"))
    end
    def self.decrypt data, time
      begin
        decipher = OpenSSL::Cipher::Cipher.new('aes-128-cbc')
        decipher.decrypt
        decipher.key = "#{SECRET}#{time}"
        decipher.iv = [data[0..63].reverse].pack("H*")

        data = decipher.update(Base64.decode64(data[64..-1]))
        data << decipher.final
        data
      rescue
        ""
      end
    end
  end
end