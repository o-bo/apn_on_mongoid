module APN
  module DeviceOwner
    extend ActiveSupport::Concern
    
    included do
      has_many :devices, :class_name => 'APN::Device', :inverse_of => :device_owner
    end
    
    module InstanceMethods
      # Returns an Array of APN::Device objects that
      # has received feedback from Apple. Each APN::Device will
      # have it's <tt>feedback_at</tt> accessor marked with the time
      # that Apple believes the device de-registered itself.
      def check_devices(&block)
        devices = []
        APN::Connection.open_for_feedback do |conn, sock|
          while line = sock.gets   # Read lines from the socket
            line.strip!
            feedback = line.unpack('N1n1H140')
            token = feedback[2].scan(/.{0,8}/).join(' ').strip
            device = self.devices.find(:first, :conditions => {:token => token})
            if device
              device.feedback_at = Time.at(feedback[0])
              devices << device
            end
          end
        end
        devices.each(&block) if block_given?
        return devices
      end # devices
    end
    
  end
end