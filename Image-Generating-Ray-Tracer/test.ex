defmodule Test do
	
	def snap do
		camera = Camera.normal({800, 600})

		obj1 = %Sphere{radius: 140, pos: {0, 0, 700}, color: {0.5, 0.5, 0.5}}
		obj2 = %Sphere{radius: 50, pos: {200, 0, 600}, color: {0, 0, 0.8}}
		obj3 = %Sphere{radius: 50, pos: {-80, 0, 400}, color: {0.2, 0.6, 0.3}}

		image = Tracer.tracer(camera, [obj1, obj2, obj3])
		PPM.write("test.ppm", image)
	end

end