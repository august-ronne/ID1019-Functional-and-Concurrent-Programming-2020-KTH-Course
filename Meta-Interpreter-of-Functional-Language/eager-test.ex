defmodule EagerTest do
	
	def eval_expr({:atm, id}, _) do
		# An atom's value is its name, return id as is
		{:ok, id}
	end

	def eval_expr({:var, id}, env) do
		# We have received a varaible with the identifier id.
		# env = environment, i.e. what variables we've saved, and so on
		# thus we need to look up if the id is in our env:
		case Env.lookup(id, env) do
			nil ->
				:error

			{_, str} ->
				{:ok, str}
		end
	end

	def eval_expr({:cons, head, tail}, env) do
		# Heads and tails are both expressions, let's evaluate them:
		case eval_expr(head, env) do
			:error ->
				:error

			{:ok, head_structure} ->
				# The head was in our environment, let's evaluate the tail expression:
				case eval_expr(tail, env) do
					:error ->
						:error

					{:ok, tail_structure} ->
						{:ok, [head_structure | tail_structure]}
				end
		end
	end

	def eval_expr({:case, expr, cls}, env) do
		case eval_expr(expr, env) do
			:error ->
				:error

			{:ok, str} ->
				eval_cls(cls, str, env)
		end
	end

	def eval_match(:ignore, _, env) do
		# If we receive the atom ':ignore', some data structure, and en environment
		# we return :ok along with the environment as is
		{:ok, env}
	end

	def eval_match({:atm, id}, id, env) do
		# We receive an atom pattern, and id, and an environment
		{:ok, env}
	end

	def eval_match({:var, id}, str, env) do
		# Example: x = :a in environment: []
		# Bind {:var, x} to :a, and add to environment
		# --> return new environment
		case Env.lookup(id, env) do
			# If var not in env:
			nil ->
				{:ok, Env.add(id, str, env)}
			# If the structure returned when looking up our variable value in the env
			# matches the argument structure, we return :ok along with the env
			{_, ^str} ->
				{:ok, env}
			# All other cases:
			{_, _} ->
				:fail
		end
	end

	def eval_match({:cons, head_pattern, tail_pattern}, [head_structure | tail_structure], env) do
		case eval_match(head_pattern, head_structure, env) do
			:fail ->
				:fail
			{:ok ,env} ->
				eval_match(tail_pattern, tail_structure, env)
		end
	end

	def eval_match( _ , _ , _ ) do
		:fail
	end

	def eval(seq) do
		eval_seq(seq, Env.new())
	end

	def eval_seq([exp], env) do
		eval_expr(exp, env)
	end

	def eval_seq([{:match, ptr, exp} | seq], env) do
		# We evaluate the expression in the match in order to produce a data structure
		case eval_expr(exp, env) do
			# If evaluation returns error:
			:error ->
				:error
			# If evalutation of match expression returns a data structure:
			{:ok, str} ->
				# Call eval_scope with our pattern and environment
				env = eval_scope(ptr, env)

				case eval_match(ptr, str, env) do
					:fail ->
						:error

					{:ok, env} ->
						eval_seq(seq, env)
				end
		end
	end

	def eval_scope(ptr, env) do
		# Extract the variables from the pattern and remove them from the environment
		Env.remove(extract_vars(ptr), env)
	end

	def extract_vars(pattern) do
		extract_vars(pattern, [])
	end

	def extract_vars({:atm, _ }, vars) do
		vars
	end
	def extracts_vars(:ignore, vars) do
		vars
	end
	def extract_vars(:ignore, []) do
		[]
	end
	def extract_vars({:var, var}, vars) do
		[var | vars]
	end
	def extract_vars({:cons, head, tail}, vars) do
		extract_vars(tail, extract_vars(head, vars))
	end

	def eval_cls([], _ , _ ) do
		:error
	end

	def eval_cls([{:clause, ptr, seq} | cls], str, env) do
		
		env = eval_scope(ptr, env)

		case eval_match(ptr, str, env) do
			:fail ->
				eval_cls(cls, str, env)
			{:ok, env} ->
				eval_seq(seq, env)
		end
	end
end