function UnrecognizedLdsTypeException(_type) constructor {
	type = _type;
	static toString = function() {
		return "Unrecognized LDS type \"" + type + "\".";
	};
}

function IncompatibleCopyException(_target, _source) constructor {
	target = _target;
	source = _source;
	static toString = function() {
		var typeOfTarget = typeof(target);
		if (typeOfTarget == "struct") typeOfTarget = instanceof(target);
		var typeOfSource = typeof(source);
		if (typeOfSource == "struct") typeOfSource = instanceof(source);
		return "Cannot copy to " + typeOfTarget + " from " + typeOfSource + ".";
	};
}

function IncompatibleDataException(_targetType, _sourceType) constructor {
	targetType = _targetType;
	sourceType = _sourceType;
	static toString = function() {
		return "Cannot read data intended for " + string(sourceType) + " into " + string(targetType) + ".";
	};
}
