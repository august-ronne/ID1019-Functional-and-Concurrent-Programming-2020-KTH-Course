defmodule Order do
	
	def start(master, to) do
		{:ok, spawn(fn() -> init(master, to) end)}
	end

	def init(master, to) do
		:io.format("order to ~w: process ~w started~n", [to, self()])
		receive do
			{:connect, netw} ->
				:io.format("order to ~w: connected to ~w~n", [to, netw])
				order(master, to, 0, 0, [], netw)
		end
	end

	def order(master, to, n, i, [], netw) do
		receive do
			
			%Ord{seq: ^i, data: msg} ->
				send(netw, {:send, to, %Ack{seq: i}})
				send(master, msg)
				order(master, to, n, i + 1, [], netw)

			%Ord{seq: j} when j < i ->
				send(netw, {:send, to, %Ack{seq: j}})
				order(master, to, n, i, [], netw)

			%Ack{} ->
				order(master, to, n, i, [], netw)

			{:send, msg} ->
				send(netw, {:send, to, %Ord{seq: n, data: msg}})
				order(master, to, n + 1, i, [{n, msg}], netw)

			{:master, new} ->
				order(new, to, n, i, [], netw)
		end
	end
end