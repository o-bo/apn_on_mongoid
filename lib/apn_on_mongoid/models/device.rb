module APN
  class Device

    include Mongoid::Document
    include Mongoid::Timestamps

    embedded_in :device_owner, :class_name => 'APN::DeviceOwner'
    
    field :token
    field :last_registered_at, type: Date

    validates_uniqueness_of :token
    validates_format_of :token, :with => /^[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}$/

    before_save :set_last_registered_at

    # The <tt>feedback_at</tt> accessor is set when the 
    # device is marked as potentially disconnected from your
    # application by Apple.
    attr_accessor :feedback_at

    private
      def set_last_registered_at
        self.last_registered_at = Time.now if self.last_registered_at.nil?
      end

  end
end