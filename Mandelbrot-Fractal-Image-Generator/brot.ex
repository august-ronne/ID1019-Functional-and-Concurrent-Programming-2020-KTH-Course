defmodule Brot do
	
	def mandelbrot(complex_number, max_iteration) do
		z_0 = Cmplx.new(0, 0)
		current_iteration = 0
		test(current_iteration, z_0, complex_number, max_iteration)
	end

	def test(max_iteration, _z_n, _complex_number, max_iteration) do
			max_iteration
	end
	
	def test(current_iteration, z_n, complex_number, max_iteration) do
		absolute_value_of_z_n = Cmplx.abs(z_n)
		cond do
			absolute_value_of_z_n <= 2 ->
				z_next = Cmplx.add(Cmplx.sqr(z_n), complex_number)
				test(current_iteration + 1, z_next, complex_number, max_iteration)
			true ->
				current_iteration
		end
	end

end