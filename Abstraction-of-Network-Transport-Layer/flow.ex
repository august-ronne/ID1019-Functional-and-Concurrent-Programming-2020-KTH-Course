defmodule Flow do
	
	def start(size) do
		{:ok, spawn(fn) -> init(size) end}
	end

	def init(size) do
		:io.format("flow ~w started ~n", [self()])
		receive do
			{:connect, netw} ->
				:io.format("flow ~w connecting to ~w~n", [self(), netw()])
				send(netw, {:send, %Syn{add: size}})
				flow(size, 0, [], netw)
		end
	end
end