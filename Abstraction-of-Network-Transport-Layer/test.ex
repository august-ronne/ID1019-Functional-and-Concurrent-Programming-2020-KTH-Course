defmodule Test do

	def test_netw(n, loss) do
		sender = spawn(fn() ->
			connect(fn(net) ->
				sender_netw(n, 2, net) 
			end) 
		end)
		receiver = spawn(fn() ->
			connect(fn(net) ->
				receiver_netw(n, 1, net)
			end)
		end)
		{:ok, ls} = netw(sender, 1)
		{:ok, lr} = netw(receiver, 2)
		connect(ls, lr, loss)
		:ok
	end
	
	def test_link(n) do
		sender = spawn(fn() -> connect(fn(lnk) -> sender_link(n, lnk) end) end)
		receiver = spawn(fn() -> connect(fn(lnk) -> receiver_link(n, lnk) end) end)

		{:ok, ls} = Link.start(sender)
		{:ok, lr} = Link.start(receiver)

		send(ls, {:connect, lr})
		send(lr, {:connect, ls})

		send(sender, {:connect, ls})
		send(receiver, {:connect, lr})
	end

	def netw(app, i) do
		{:ok, netw} = Network.start(app, i)
		send(app, {:connect, netw})
		lnk(netw)
	end

	def lnk(app) do
		{:ok, link} = Link.start(app)
		send(app, {:connect, link})
		{:ok, link}
	end

	def connect(link1, link2, loss) do
		{:ok, hub} = Nub.start(loss)
		send(link1, {:connect, hub})
		send(link2, {:connect, hub})
		send(hub, {:connect, link1})
		send(hub, {:connect, link2})
	end

	def connect(f) do
		receive do
			{:connect, n} ->
				f.(n)
		end
	end

	def sender_netw(0, _ , _ ) do :ok end
	def sender_netw(i, t, n) do
		IO.puts("sender sending #{i}")
		send(n, {:send, t, i})
		sender_netw(i - 1, t, n)
	end

	def receiver_netw(0, _ , _ ) do :ok end
	def receiver_netw(i, t, n) do
		receive do
			msg ->
				IO.puts("receiver received #{msg}")
				receiver_netw(i - 1, t, n)
		end
	end

	def sender_link(0, _) do :ok end
	def sender_link(i, n) do
		IO.puts("sender sending #{i}")
		send(n, {:send, i})
		sender_link(i - 1, n)
	end

	def receiver_link(0, _) do :ok end
	def receiver_link(i, n) do
		receive do
			msg ->
				IO.puts("receiver received #{msg}")
				receiver_link(i - 1, n)
		end
	end

end