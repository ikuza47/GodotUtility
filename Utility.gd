extends Resource
class_name Utility

# MATH FUNC
static func to_vector2(x) -> Vector2: return Vector2(x,x) ## Function for creating a vector with 1 variable
static func to_vector2i(x:int) -> Vector2i: return Vector2i(x,x) ## Function for creating an int vector from 1 variable
static func if_do_int(x: int,boolean:bool) -> int: return x if boolean else 0 ## Function to consider int in the equation if the if statement is true
static func if_do_float(x: float, boolean:bool) -> float: return x if boolean else 0 ##Function to consider float in the equation if the if statement is true
# STRING FUNC
static func to_stirng(x) -> String: return "{x}".format({"x":x}) ## A function for returning any variable as a String


## A class for structured return of operation results
class Result:
	var success_flag: bool
	var message: String
	var code: int
	
	func _init(success_flag: bool, message: String = "", code: int = 0) -> void:
		self.success_flag = success_flag
		self.message = message
		self.code = code
	
	func is_success() -> bool:
		return success_flag
	
	func is_failure() -> bool:
		return not success_flag
	
	func _to_string() -> String:
		var status = "OK" if success_flag else "ERROR"
		return "[Result %s] Code: %d | %s" % [status, code, message]
	
	static func success(message: String = "", code: int = 1) -> Result:
		return Result.new(true, message, code)
	
	static func failure(message: String = "", code: int = 0) -> Result:
		return Result.new(false, message, code)
