module APN
  module DeviceOwner
    extend ActiveSupport::Concern
    
    included do
      embeds_one :device, :class_name => 'APN::Device'
    end
    
    module InstanceMethods
    end
    
  end
end