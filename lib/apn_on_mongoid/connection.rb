module APN
  module Connection
    
    class << self
      
      # Yields up an SSL socket to write notifications to.
      # The connections are close automatically.
      # 
      def open_for_delivery(options = {}, &block)
        open(options, &block)
      end
      
      # Yields up an SSL socket to receive feedback from.
      # The connections are close automatically.
      def open_for_feedback(options = {}, &block)
        options = {:cert => ::APN.cert,
                   :passphrase => ::APN.passphrase,
                   :host => ::APN.feedback,
                   :port => ::APN.feedback_port}.merge(options)
        open(options, &block)
      end
      
      private
      def open(options = {}, &block) # :nodoc:
        options = {:cert => ::APN.cert,
                   :passphrase => ::APN.passphrase,
                   :host => ::APN.host,
                   :port => ::APN.port}.merge(options)
        cert = File.read(options[:cert])
        if cert
          ctx = OpenSSL::SSL::SSLContext.new
          ctx.key = OpenSSL::PKey::RSA.new(cert, options[:passphrase])
          ctx.cert = OpenSSL::X509::Certificate.new(cert)
  
          # sock = TCPSocket.new(options[:host], options[:port])
          sock = TCPSocket.new('gateway.sandbox.push.apple.com', 2195)
          ssl = OpenSSL::SSL::SSLSocket.new(sock, ctx)
          ssl.connect
  
          yield ssl, sock if block_given?
  
          ssl.close
          sock.close
        end
      end
      
    end
    
  end # Connection
end # APN