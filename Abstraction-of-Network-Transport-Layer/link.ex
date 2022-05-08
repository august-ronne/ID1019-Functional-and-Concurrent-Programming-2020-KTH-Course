defmodule Link do
	
	def start(master_process_of_this_link) do
		{:ok, spawn(fn() -> init(master_process_of_this_link) end)}
	end

	defp init(master_process) do
		receive do
			{:connect, target_link} ->
				:io.format("link ~w: connected to ~w~n", [self(), target_link])
				link(master_process, target_link)
			:quit ->
				:ok
		end
	end

	def link(master_process, target_link) do
		receive do
			{:send, msg} ->
				send(target_link, %Frame{data: msg})
				link(master_process, target_link)

			%Frame{data: msg} = frame_from_other_link ->
				send(master_process, msg)
				link(master_process, target_link)

			{:master, new_master_process} ->
				link(new_master_process, target_link)

			:status ->
				:io.format("link ~w: master: ~w, link~w~n", [self(), master_process, target_link])
				link(master_process, target_link)

			:quit ->
				:ok
		end
	end

end