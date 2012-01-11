module APN
  # Module for talking to the Apple Feedback Service.
  # The service is meant to let you know when a device is no longer
  # registered to receive notifications for your application.
  module Feedback
    
    class << self
      
      # Retrieves a list of users and for each user it checks its APN::Device instances from Apple using
      # the <tt>check_devices</tt> method. It then checks to see if the
      # <tt>last_registered_at</tt> date of each APN::Device is
      # before the date that Apple says the device is no longer
      # accepting notifications then the device is deleted. Otherwise
      # it is assumed that the application has been re-installed
      # and is available for notifications.
      # 
      # This can be run from the following Rake task:
      #   $ rake apn:feedback:process
      def process_devices
        owners = APN::DeviceOwner.all
        owners.each do |owner|
          owner.check_devices.each do |device|
            if device.last_registered_at < device.feedback_at
              device.destroy
            end
          end
        end
      end # process_devices
      
    end # class << self
    
  end # Feedback
end # APN