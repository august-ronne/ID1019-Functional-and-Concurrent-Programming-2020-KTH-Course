defmodule Rudy do
	
	def start(port) do
		Process.register(spawn(fn -> init(port) end), :rudy)
	end

	def stop() do
		case Process.whereis(:rudy) do
			nil -> :ok
			pid ->
				Process.exit(pid, "Time to die!")
		end
	end

	defp init(port) do
		opt = [:list, active: false, reuseaddr: true]

		case :gen_tcp.listen(port, opt) do
			{:ok, listen} ->
				handler(listen)
				:gen_tcp.close(listen)
				:ok

			{:error, error} ->
				error
		end
	end

	defp handler(listen) do
		case :gen_tcp.accept(listen) do
			{:ok, client} ->
				request(client)
				:gen_tcp.close(client)
				handler(listen)

			{:error, error} ->
				error
		end
	end

	defp request(client) do
		recv = :gen_tcp.recv(client, 0)

		case recv do
			{:ok, str} ->
				request = HTTP.parse_request(str)
				response = reply(request)
				:gen_tcp.send(client, response)

			{:error, error} ->
				IO.puts("RUDY ERROR: #{error}")
		end

		:gen_tcp.close(client)
	end

	defp reply({{:get, _uri, _ }, _ , _ }) do
		:timer.sleep(10)
		HTTP.ok("Hello!")
	end

	defp dummy() do
		:timer.sleep(10)
		HTTP.ok("Hello!")
	end
end