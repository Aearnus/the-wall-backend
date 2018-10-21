require "sinatra"
require_relative "../lib/state"

set :bind, '0.0.0.0'

global_state = State.new

before do
   content_type :json
   headers 'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST']
end

get "/chunk/:x/:y" do
    global_state.request_handler.get_chunk_request(params["x"].to_i, params["y"].to_i)
end

post "/draw/:x1/:y1/:x2/:y2" do
    global_state.request_handler.get_draw_request([params["x1"].to_f, params["y1"].to_f], [params["x2"].to_f, params["y2"].to_f], [0,0])
    return "1"
end
