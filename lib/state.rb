require_relative "chunks.rb"
require_relative "request_handler.rb"
require_relative "player.rb"

class State
    attr_reader :chunk_grid, :request_handler

    def initialize
        @chunk_grid = ChunkGrid.new
        @players = []
        @request_handler = RequestHandler.new(self)
    end
end
