defmodule Cmplx do
	
	def new(x, y) do
		{:cpx, x, y}
	end

	def add({:cpx, x1, y1}, {:cpx, x2, y2}) do
		{:cpx, x1 + x2, y1 + y2}
	end

	def sqr({:cpx, x, y}) do
		{:cpx,    x * x - y * y,	2 * x * y}
	end

	def abs({:cpx, x, y}) do
		:math.sqrt(x * x + y * y)
	end

end