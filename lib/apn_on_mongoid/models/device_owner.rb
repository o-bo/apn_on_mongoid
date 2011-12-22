module APN
  module DeviceOwner
    extend ActiveSupport::Concern
    
    included do
      embeds_one :device
    end
    
    module InstanceMethods
    end
    
  end
end