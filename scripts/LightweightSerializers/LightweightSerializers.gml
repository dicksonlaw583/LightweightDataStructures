///@class UnrecognizedLdsTypeException(type)
///@param type The encountered type.
///@desc Exception for when an LDS type spec is not recognized during loading.
function UnrecognizedLdsTypeException(type) constructor {
	self.type = type;
	
	///@func toString()
	///@return {String}
	///@desc Return a message describing this exception.
	static toString = function() {
		return "Unrecognized LDS type \"" + type + "\".";
	};
}

///@class IncompatibleCopyException(target, source)
///@param {Any} target The target being copied to.
///@param {Any} source The source being copied from.
///@desc Exception for when a copy operation is attempted between incompatible types (e.g. a map to a list).
function IncompatibleCopyException(target, source) constructor {
	self.target = target;
	self.source = source;
	
	///@func toString()
	///@return {String}
	///@desc Return a message describing this exception.
	static toString = function() {
		var typeOfTarget = typeof(target);
		if (typeOfTarget == "struct") typeOfTarget = instanceof(target);
		var typeOfSource = typeof(source);
		if (typeOfSource == "struct") typeOfSource = instanceof(source);
		return "Cannot copy to " + typeOfTarget + " from " + typeOfSource + ".";
	};
}

///@class IncompatibleDataException(targetType, sourceType)
///@param {String} targetType The name of the target's type.
///@param {String} sourceType The name of the type stated by the source string.
///@desc Exception for when a read operation tries to load into an incompatible target (e.g. map data string into a list).
function IncompatibleDataException(targetType, sourceType) constructor {
	self.targetType = targetType;
	self.sourceType = sourceType;
	
	///@func toString()
	///@return {String}
	///@desc Return a message describing this exception.
	static toString = function() {
		return "Cannot read data intended for " + string(sourceType) + " into " + string(targetType) + ".";
	};
}
