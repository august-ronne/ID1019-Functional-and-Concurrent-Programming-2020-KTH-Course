defmodule Color do
	
	def convert(d, max) do
		red(d, max)
	end

	def red(d, max) do
		f = d / max
		a = f * 4
		x = trunc(a)
		y = trunc(255 * (a - x))

		case x do ->
			0 ->
				# black -> red OR from in set to quickly  out of set
				{:rgb, y, 0, 0}
			1 ->
				{:rgb, 255, y, 0}
			2 ->
				{:rgb, 255 - y, 255, 0}
			3 ->
				{:rgb, 0, 255, y}
			4 ->
				{:rgb, 0, 255 - y, 255}
	end
end