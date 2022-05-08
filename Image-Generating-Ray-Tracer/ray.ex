defmodule Ray do
	
	require Record

	Record.defrecord(:ray, pos: {0, 0, 0}, dir: {1, 1, 1})
	
end