module APN
  module DeviceOwner
    extend ActiveSupport::Concern
    
    included do
      embeds_many :devices, :class_name => 'APN::Device'
    end
    
    module InstanceMethods
    end
    
  end
end