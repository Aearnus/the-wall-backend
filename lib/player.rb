require "base64"

class Player
    def initialize(x,y)
        @x = x
        @y = y
        @id = id
    end

    def serialize
        Base64.encode64([@x, @y].pack("DD") + @id)
    end
end
