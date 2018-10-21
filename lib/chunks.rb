require "json"
require "base64"

class Stroke
    attr_accessor :p1, :p2, :dp1

    # Creates an instance of the Stroke class
    #
    # @param p1 [(Fixnum, Fixnum)] the first coord
    # @param p2 [(Fixnum, Fixnum)] the second coord
    # @param dp1 [(Fixnum, Fixnum)] the velocity at point p1
    # @return [Stroke] an instance of the Stroke class
    def initialize(p1, p2, dp1)
        @p1 = p1
        @p2 = p2
        @dp1 = dp1
    end

    # Creates a new stroke from a serialized string
    #
    # @param serialized [String] the serialized Stroke
    # @return [Stroke] an instance of the Stroke class
    def self.new_from_serialized(serialized)
        args = Base64.decode64(serialized).unpack("DDDDDD")
        puts args
        self.new(args[0..1], args[2..3], args[4..5])
    end

    # Serializes the stroke in a format suitable for file IO
    #
    # @return [String] the serialized class
    def serialize
        Base64.encode64([*@p1, *@p2, *@dp1].pack("DDDDDD"))
    end
end

class Chunk
    # Creates an instance of the Chunk class
    # @note A chunk is considered to have a length of 1 on all sides.
    # @param x [Fixnum] the x coord of the chunk
    # @param y [Fixnum] the y coord of the chunk
    def initialize(x, y)
        @strokes = []
        @x = x
        @y = y
    end

    # Creates a new chunk from a serialized string
    # @param serialized [String] the serialized Chunk
    # @return [Chunk] an instance of the Chunk class
    def self.new_from_serialized(serialized)
        args = JSON.parse(serialized)
        out = self.new(args[:x], args[:y])
        args[:strokes].each do |serialized_stroke|
            stroke = Stroke.new_from_serialized(serialized_stroke)
            out.draw(stroke.p1, stroke.p2, stroke.dp1)
        end
        return out
    end

    # Draws a line from point one to point two, on the bound 0,0 <= p <= 1,1
    # @param p1 [(Fixnum, Fixnum)] the first coord
    # @param p2 [(Fixnum, Fixnum)] the second coord
    # @param dp1 [(Fixnum, Fixnum)] the velocity at point p1
    def draw(p1, p2, dp1)
        @strokes << Stroke.new(p1, p2, dp1)
    end

    # Serializes the chunk into a textual format
    # @return [String] the serialized class
    def serialize
        JSON.generate({x: @x, y: @y, strokes: @strokes.map(&:serialize)})
    end
end

class ChunkGrid
    attr_reader :chunks

    # Creates an instance of the ChunkGrid class
    # @note This uses a grid of chunks of length 1.
    def initialize
        @chunks = {}
    end

    # Draws a line from point one to point two
    # @param p1 [(Fixnum, Fixnum)] the first coord
    # @param p2 [(Fixnum, Fixnum)] the second coord
    # @param dp1 [(Fixnum, Fixnum)] the velocity at point p1
    def draw(p1, p2, dp1)
        amount_of_chunk_crossings = (p2[0] - p1[0]).abs.floor + (p2[1] - p1[1]).abs.floor
        if amount_of_chunk_crossings == 0
            key = [p1[0], p1[1]]
            if not @chunks.key? key
                @chunks[key] = Chunk.new(*key)
            end
            @chunks[key].draw([p1[0] - p1[0].floor, p2[0] - p2[0].floor, dp1])
        # TODO: amount_of_chunk_crossings == 1
        else
            puts "illegal draw detected: #{p1} to #{p2}"
            return
        end


    end

    # Serializes the chunk grid into a textual format
    # @return [String] the serialized class
    def serialize
        object = {grid: {}}
        @chunks.keys.each do |k|
            object[:grid]["#{k[0]} #{k[1]}"] = @chunks[k].serialize
        end
        JSON.generate(object)
    end
end
