require 'singleton'

class Node 
	@@indent = 0

	def indent_str
		' ' * 2 * @@indent
	end

	def print
		puts indent_str + self.class.name
	end

end

class Expression < Node 
	def value
		nil
	end
end

class Statement < Node
	def execute
	end
end

class ValuedStatement < Statement
	def value
		nil
	end
end

class VarReference < Expression
	attr_accessor :id

	def initialize(id)
		@id = id
	end

	def print
		puts indent_str + "Reference to variable " + @id
	end
end



class IntegerLiteral < Expression
	def initialize(intValue) 
		@intValue = intValue.to_i
	end

	def value
		@intValue
	end

	def print
		puts indent_str + "int literal: " + @intValue.to_s
	end
end

class DoubleLiteral < Expression
	def initialize(fValue) 
		@fValue = fValue.to_f
	end

	def value
		@fValue
	end

	def print
		puts indent_str + "FP literal: " + @fValue.to_s
	end
end

class BinaryOperation < Expression
	attr_accessor :left_side, :operator, :right_side

	def initialize(left_side, operator, right_side)
		@left_side = left_side
		@operator = operator
		@right_side = right_side
	end

	def print
		puts indent_str + "Expression:"
		@@indent += 1
		left_side.print
		@@indent -= 1
		puts  indent_str + "Operator: " + @operator
		@@indent += 1
		right_side.print
		@@indent -= 1
	end
end

class BinaryComparison < Expression
	attr_accessor :left_side, :operator, :right_side

	def initialize(left_side, operator, right_side)
		@left_side = left_side
		@operator = operator
		@right_side = right_side
	end
end

class MethodCall < ValuedStatement
	attr_accessor :id, :args

	def initialize(id, args)
		@id = id
		if args.to_a.empty?
			@args = Array.new
		else
			@args = args
		end
	end

	def print
		puts indent_str + "Calling function " + @id + " with arguments"
		@@indent += 1
		@args.each do |i|
			i.print
		end
		@@indent -= 1	
	end
end


class Assignment < ValuedStatement
	attr_accessor :id, :expression

	def initialize(id, expression)
		@id = id
		@expression = expression
	end

	def print
		puts indent_str + sprintf("Assigning to var %s", @id)
		@@indent += 1
		puts indent_str + "Value of"
		@expression.print
		@@indent -= 1
	end
end

class Block < Statement
	attr_accessor :statements, :scope

	def initialize(*statements)
		if statements.to_a.empty?
			@statements = Array.new
		else
			@statements = statements
		end
		@scope = Hash.new 
	end

	def print
		puts indent_str +  "Block Start"
		@@indent += 1
		@statements.each do |i|
			i.print
		end
		@@indent -= 1
		puts indent_str + "Block End"
	end
end

class VariableDeclaration < Statement
	attr_accessor :type, :id, :initial_value

	def initialize(type, id, initial_value = nil)
		@type = type
		@id = id
		@initial_value = initial_value
	end

	def print
		puts indent_str + "Type: " + @type + "; Name: " + @id 
		if !@initial_value.nil? 
			puts indent_str + "Initial value"
			@@indent += 1
			initial_value.print
			@@indent -= 1
		end
	end
end

class FunctionDeclaration < Statement
	attr_accessor :type, :id, :arg_defs, :block

	def initialize(type, id, arg_defs, block)
		@type = type
		@id = id
		@block = block
		@arg_defs = arg_defs
	end

	def print
		puts indent_str + "Declaring function " + @id
		puts indent_str + "Return type: " + @type
		puts indent_str + "Argument list"
		@@indent += 1
		@arg_defs.each do | i |
			i.print
		end
		@@indent -= 1
		@block.print
	end
end

class ReturnStatement < Statement
	attr_accessor :expression

	def initialize(expression)
		@expression = expression
	end

	def print
		puts indent_str + "Returning expression"
		@@indent += 1
		@expression.print
		@@indent -= 1
	end
end

class PrintStatement < Statement 
	attr_accessor :expression

	def initialize(expression) 
		@expression = expression
	end

	def print
		puts indent_str + "Printing expression"
		@@indent += 1
		@expression.print
		@@indent -= 1
	end

end
class Variable
	attr_accessor :type, :id, :value

	def initialize (type, id, value = 0)
		@type = type
		@id = id
		@value = value
	end
end


class Memory
	include Singleton

	def initialize
		@functions = Hash.new
		@scopes = Array.new 
		@top = 0
	end

	def allocate(variable)
	end

	def store(id, value)
	end

	def load(id)
	end

	def push_scope(scope)
		@scopes.push scope
		@top += 1
	end

	def pop_scope()
		if @top > 0
			@top -= 1
			@scopes.pop
		else
			raise "Can't pop top scope"
		end
	end

	def register_function(function)
		@functions[function.id] = function
	end

	def call_function(id, args)

	end
end
