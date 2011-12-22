module APN
  class User
    include Mongoid::Document
    include Mongoid::Timestamps
    
    embeds_one :device
    
  end
end