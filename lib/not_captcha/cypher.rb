module NotCaptcha
  module Cypher
    SECRET = '12312312312312312313123'
    def self.encrypt data, time
      cipher = OpenSSL::Cipher::AES.new(128, :CBC)
      cipher.encrypt
      cipher.key = "#{SECRET}#{time}"
      iv = cipher.random_iv
      iv = OpenSSL::Random.random_bytes(32)
      cipher.iv = iv
      encrypted = cipher.update(data) + cipher.final
      Base64.urlsafe_encode64(iv+encrypted).delete("=\n\r")
    end
    def self.decrypt data, time
      data = Base64.urlsafe_decode64(data)
      begin
        decipher = OpenSSL::Cipher::AES.new(128, :CBC)
        decipher.decrypt
        decipher.key = "#{SECRET}#{time}"
        decipher.iv = data[0..31]

        result = decipher.update(data[32..-1]) + decipher.final
        result
      rescue => e
        ""
      end
    end
  end
end

##NotCaptcha::Cypher.decrypt "MzkxNzQxNDE0ZmFhNTNjYWJmNDU5MGI2ZDU2ZjJkNzI2MTMyZDFkMGFjMTUyNmYxZWM0MGY3NzExNjZkZmU5Y2RuREJaRms3L2lUV2MzbDIwaDU3d3c",1347971806