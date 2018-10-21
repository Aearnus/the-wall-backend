class RequestHandler
    def initialize(state)
        @state = state
    end

    # Gets a string representing a chunk object at point x, y
    # @param x [Fixnum] the x coord of the chunk
    # @param y [Fixnum] the y coord of the chunk
    # @return [String] the string representation of the chunk
    def get_chunk_request(x, y)
        (@state.chunk_grid.chunks.fetch([x,y]) {|p| Chunk.new(*p) }).serialize
    end

    # Gets a request to draw a line from p1 to p2
    # @param p1 [(Fixnum, Fixnum)] the first point of the line
    # @param p2 [(Fixnum, Fixnum)] the second point of the line
    # @param dp1 [(Fixnum, Fixnum)] the velocity at point p1
    def get_draw_request(p1, p2, dp1)
        @state.chunk_grid.draw(p1, p2, dp1)
    end
end
