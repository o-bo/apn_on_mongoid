module APN
  class Notification
    
    include Mongoid::Document
    include Mongoid::Timestamps
    include ::ActionView::Helpers::TextHelper

    field :sound
    field :alert, :size => 150
    field :badge, :type => Integer
    field :payload, :type => Hash
    field :sent_at, :type => Time
    field :device_language
    field :errors_nb
    
    belongs_to :device, :class_name => 'APN::Device'
    before_save :truncate_alert
    
    # Create a notification with the given parameters.
    #
    # * Args* :
    #   - device -> the device that shall be notified ; mandatory.
    #   - alert -> the alert to be displayed to the user ; mandatory.
    #   - sound -> the sound to play in the device ; optional.
    #   - badge -> the number to be display as a badge on the device ; optional. 
    # * *Returns* :
    #   - the created notification
    #
    def self.create_notification(device, alert, sound="default", badge=1)
      n = APN::Notification.new
      n.device = device
      n.alert = alert
      n.sound = sound
      n.badge = badge
      n.save
      n
    end
    
    # Stores the text alert message you want to send to the device.
    # 
    # If the message is over 150 characters long it will get truncated
    # to 150 characters with a <tt>...</tt>
    def alert=(message)
      if !message.blank? && message.size > 150
        message = truncate(message, :length => 150)
      end
      write_attribute('alert', message)
    end
    
    # Creates a Hash that will be the payload of an APN.
    # 
    # Example:
    #   apn = APN::Notification.new
    #   apn.badge = 5
    #   apn.sound = 'my_sound.aiff'
    #   apn.alert = 'Hello!'
    #   apn.apple_hash # => {"aps" => {"badge" => 5, "sound" => "my_sound.aiff", "alert" => "Hello!"}}
    def apple_hash
      result = {}
      result['aps'] = {}
      result['aps']['alert'] = self.alert if self.alert
      result['aps']['badge'] = self.badge.to_i if self.badge
      if self.sound
        result['aps']['sound'] = self.sound if self.sound.is_a? String
        result['aps']['sound'] = "1.aiff" if self.sound.is_a?(TrueClass)
      end
      result.merge! self.payload if self.payload
      result
    end

    # Creates the JSON string required for an APN message.
    # 
    # Example:
    #   apn = APN::Notification.new
    #   apn.badge = 5
    #   apn.sound = 'my_sound.aiff'
    #   apn.alert = 'Hello!'
    #   apn.to_apple_json # => '{"aps":{"badge":5,"sound":"my_sound.aiff","alert":"Hello!"}}'
    def to_apple_json
      self.apple_hash.to_json
    end

    # Creates the binary message needed to send to Apple.
    # see http://developer.apple.com/IPhone/library/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CommunicatingWIthAPS/CommunicatingWIthAPS.html#//apple_ref/doc/uid/TP40008194-CH101-SW4
    def message_for_sending
      json = self.to_apple_json
      raise APN::Errors::ExceededMessageSizeError.new(json) if json.size.to_i > APN::Errors::ExceededMessageSizeError::MAX_BYTES

      #jsonString = payload.to_json => json
      #length = json.length
      #a= [1, 66, 0, 32, self.device.get_token, length, json]
      #data = a.pack("cNNnH*na*")
      #data     
      #puts "APN MESSAGE DEVICE HEXA: #{self.device.to_hexa}"
      #puts "RESULT : \0\0 #{self.device.to_hexa}\0#{(json.length).chr}#{json}"
      #{}"\0\0 #{self.device.to_hexa}\0#{(json.length).chr}#{json}"
      token = self.device.to_hexa
      puts "HEXA TOKEN : #{token.unpack('H*')}"
      puts "PAYLOAD : #{json}"
      [0, 0, token.size, token, 0, json.size, json].pack("ccca*cca*")
    end
    
    # Deliver the current notification
    def deliver
      APN::Notifications.deliver([self])
    end

    private
    # Truncate alert message if message payload will be too long
    def truncate_alert
      return unless self.alert
      while self.alert.length > 1
        begin
          self.message_for_sending
          break
        rescue APN::Errors::ExceededMessageSizeError => e
          self.alert = truncate(self.alert, :length => self.alert.mb_chars.length - 1)
        end
      end
    end
  end
  
  class Notifications
    
    # Opens a connection to the Apple APN server and attempts to batch deliver
    # an Array of notifications.
    # 
    # This method expects an Array of APN::Notifications. If no parameter is passed
    # in then it will use the following:
    #   APN::Notification.all(:conditions => {:sent_at => nil})
    # 
    # As each APN::Notification is sent the <tt>sent_at</tt> column will be timestamped,
    # so as to not be sent again.
    #
    def self.deliver(notifications = APN::Notification.all(:conditions => {:sent_at => nil}))
      unless notifications.nil? || notifications.empty?

        APN::Connection.open_for_delivery do |conn, sock|
          notifications.each do |noty|
            m = noty.message_for_sending
            conn.write(m)
            noty.sent_at = Time.now
            noty.save
          end
        end

      end
    end
    
  end
  
end