function Grid() constructor {
	// Set up basic properties and starting entries
	_canonType = "Grid";
	_type = "List";
	_width = argument[0];
	_height = argument[1];
	_data = array_create(_width*_height, undefined);
	var i = 0;
	repeat (argument_count-2) {
		_data[i] = argument[i+2];
		++i;
	}

	// Clear
	static clear = function(val) {
		var i = -1;
		repeat (_width*_height) {
			_data[++i] = val;		
		}
	};

	// Width
	static width = function() {
		return _width;
	};

	// Height
	static height = function() {
		return _height;
	};

	// Resize
	static resize = function(w, h) {
		var wh = w*h;
		if (w == _width) {
			if (h > _height) {
				var newDataSize = _width*h;
				for (var i = _width*_height; i < newDataSize; ++i) {
					_data[i] = undefined;
				}
			} else if (h < _height) {
				var _newdata = array_create(wh);
				array_copy(newDataSize, 0, _data, 0, wh);
				delete _data;
				_data = _newdata;
			}
		} else {
			var _newdata = array_create(wh, undefined);
			var copyWidth = min(_width, w);
			for (var yy = min(_height, h)-1; yy >= 0; --yy) {
				array_copy(_newdata, yy*w, _data, yy*_width, copyWidth);
			}
			delete _data;
			_data = _newdata;
		}
		_width = w;
		_height = h;
	};

	// Set
	static set = function(xx, yy, val) {
		if (xx < 0 || yy < 0 || xx >= _width || yy >= _height) {
			throw new GridIndexOutOfBoundsException(xx, yy);
		}
		_data[xx+yy*_width] = val;
	};

	// Set disk
	static setDisk = function(xm, ym, r, val) {
		var Y = min(_height-ym-1, r);
		for (var dy = max(-ym, -r); dy <= Y; ++dy) {
			var R = r-abs(dy);
			var X = min(_width-xm-1, R);
			for (var dx = max(-xm, -R); dx <= X; ++dx) {
				_data[xm+dx+(ym+dy)*_width] = val;
			}
		}
	};

	// Set region
	static setRegion = function(x1, y1, x2, y2, val) {
		var _x1 = max(0, x1),
			_y1 = max(0, y1),
			_x2 = min(_width-1, x2),
			_y2 = min(_height-1, y2);
		for (var yy = _y1; yy <= _y2; ++yy) {
			for (var xx = _x1; xx <= _x2; ++xx) {
				_data[xx+yy*_width] = val;
			}
		}
	};

	// Get
	static get = function(xx, yy) {
		if (xx < 0 || yy < 0 || xx >= _width || yy >= _height) {
			throw new GridIndexOutOfBoundsException(xx, yy);
		}
		return _data[xx+yy*_width];
	};

	// Add
	static add = function(xx, yy, val) {
		if (xx < 0 || yy < 0 || xx >= _width || yy >= _height) {
			throw new GridIndexOutOfBoundsException(xx, yy);
		}
		_data[xx+yy*_width] += val;
	}

	// Add disk
	static addDisk = function(xm, ym, r, val) {
		var Y = min(_height-ym-1, r);
		for (var dy = max(-ym, -r); dy <= Y; ++dy) {
			var R = r-abs(dy);
			var X = min(_width-xm-1, R);
			for (var dx = max(-xm, -R); dx <= X; ++dx) {
				_data[xm+dx+(ym+dy)*_width] += val;
			}
		}
	};

	// Add region
	static addRegion = function(x1, y1, x2, y2, val) {
		var _x1 = max(0, x1),
			_y1 = max(0, y1),
			_x2 = min(_width-1, x2),
			_y2 = min(_height-1, y2);
		for (var yy = _y1; yy <= _y2; ++yy) {
			for (var xx = _x1; xx <= _x2; ++xx) {
				_data[xx+yy*_width] += val;
			}
		}
	};

	// Multiply
	static multiply = function(xx, yy, val) {
		if (xx < 0 || yy < 0 || xx >= _width || yy >= _height) {
			throw new GridIndexOutOfBoundsException(xx, yy);
		}
		_data[xx+yy*_width] *= val;
	}

	// Multiply disk
	static multiplyDisk = function(xm, ym, r, val) {
		var Y = min(_height-ym-1, r);
		for (var dy = max(-ym, -r); dy <= Y; ++dy) {
			var R = r-abs(dy);
			var X = min(_width-xm-1, R);
			for (var dx = max(-xm, -R); dx <= X; ++dx) {
				_data[xm+dx+(ym+dy)*_width] *= val;
			}
		}
	};

	// Multiply region
	static multiplyRegion = function(x1, y1, x2, y2, val) {
		var _x1 = max(0, x1),
			_y1 = max(0, y1),
			_x2 = min(_width-1, x2),
			_y2 = min(_height-1, y2);
		for (var yy = _y1; yy <= _y2; ++yy) {
			for (var xx = _x1; xx <= _x2; ++xx) {
				_data[xx+yy*_width] *= val;
			}
		}
	};

	// Value in region
	static valueExists = function(x1, y1, x2, y2, val) {
		var _x1 = max(0, x1),
			_y1 = max(0, y1),
			_x2 = min(_width-1, x2),
			_y2 = min(_height-1, y2);
		for (var yy = _y1; yy <= _y2; ++yy) {
			for (var xx = _x1; xx <= _x2; ++xx) {
				if (_data[xx+yy*_width] == val) {
					return true;
				}
			}
		}
		return false;
	};
	
	// Value in disk
	static valueDiskExists = function(xm, ym, r, val) {
		var Y = min(_height-ym-1, r);
		for (var dy = max(-ym, -r); dy <= Y; ++dy) {
			var R = r-abs(dy);
			var X = min(_width-xm-1, R);
			for (var dx = max(-xm, -R); dx <= X; ++dx) {
				if (_data[xm+dx+(ym+dy)*_width] == val) {
					return true;
				}
			}
		}
		return false;
	};
	
	// Value's X in region
	static valueX = function(x1, y1, x2, y2, val) {
		var _x1 = max(0, x1),
			_y1 = max(0, y1),
			_x2 = min(_width-1, x2),
			_y2 = min(_height-1, y2);
		for (var yy = _y1; yy <= _y2; ++yy) {
			for (var xx = _x1; xx <= _x2; ++xx) {
				if (_data[xx+yy*_width] == val) {
					return xx;
				}
			}
		}
		return -1;
	};
	
	// Value's Y in region
	static valueY = function(x1, y1, x2, y2, val) {
		var _x1 = max(0, x1),
			_y1 = max(0, y1),
			_x2 = min(_width-1, x2),
			_y2 = min(_height-1, y2);
		for (var yy = _y1; yy <= _y2; ++yy) {
			for (var xx = _x1; xx <= _x2; ++xx) {
				if (_data[xx+yy*_width] == val) {
					return yy;
				}
			}
		}
		return -1;
	};
	
	// Value's X in disk
	static valueDiskX = function(xm, ym, r, val) {
		var Y = min(_height-ym-1, r);
		for (var dy = max(-ym, -r); dy <= Y; ++dy) {
			var R = r-abs(dy);
			var X = min(_width-xm-1, R);
			for (var dx = max(-xm, -R); dx <= X; ++dx) {
				if (_data[xm+dx+(ym+dy)*_width] == val) {
					return xm+dx;
				}
			}
		}
		return -1;
	};
	
	// Value's Y in disk
	static valueDiskY = function(xm, ym, r, val) {
		var Y = min(_height-ym-1, r);
		for (var dy = max(-ym, -r); dy <= Y; ++dy) {
			var R = r-abs(dy);
			var X = min(_width-xm-1, R);
			for (var dx = max(-xm, -R); dx <= X; ++dx) {
				if (_data[xm+dx+(ym+dy)*_width] == val) {
					return ym+dy;
				}
			}
		}
		return -1;
	};
	
	// Region's max
	static getMax = function(x1, y1, x2, y2) {
		var _x1 = max(0, x1),
			_y1 = max(0, y1),
			_x2 = min(_width-1, x2),
			_y2 = min(_height-1, y2),
			_max = _data[_x1+_y1*_width];
		for (var yy = _y1; yy <= _y2; ++yy) {
			for (var xx = _x1; xx <= _x2; ++xx) {
				var val = _data[xx+yy*_width];
				if (val > _max) {
					_max = val;
				}
			}
		}
		return _max;
	};
	
	// Region's mean
	static getMean = function(x1, y1, x2, y2) {
		var _x1 = max(0, x1),
			_y1 = max(0, y1),
			_x2 = min(_width-1, x2),
			_y2 = min(_height-1, y2),
			_sum = 0;
		for (var yy = _y1; yy <= _y2; ++yy) {
			for (var xx = _x1; xx <= _x2; ++xx) {
				_sum += _data[xx+yy*_width];
			}
		}
		return _sum/((_x2-_x1+1)*(_y2-_y1+1));
	};
	
	// Region's min
	static getMin = function(x1, y1, x2, y2) {
		var _x1 = max(0, x1),
			_y1 = max(0, y1),
			_x2 = min(_width-1, x2),
			_y2 = min(_height-1, y2),
			_min = _data[_x1+_y1*_width];
		for (var yy = _y1; yy <= _y2; ++yy) {
			for (var xx = _x1; xx <= _x2; ++xx) {
				var val = _data[xx+yy*_width];
				if (val < _min) {
					_min = val;
				}
			}
		}
		return _min;
	};
	
	// Region's sum
	static getSum = function(x1, y1, x2, y2) {
		var _x1 = max(0, x1),
			_y1 = max(0, y1),
			_x2 = min(_width-1, x2),
			_y2 = min(_height-1, y2),
			_sum = 0;
		for (var yy = _y1; yy <= _y2; ++yy) {
			for (var xx = _x1; xx <= _x2; ++xx) {
				_sum += _data[xx+yy*_width];
			}
		}
		return _sum;
	};
	
	// Disk's max
	static getDiskMax = function(xm, ym, r) {
		var _max = undefined;
		var Y = min(_height-ym-1, r);
		for (var dy = max(-ym, -r); dy <= Y; ++dy) {
			var R = r-abs(dy);
			var X = min(_width-xm-1, R);
			for (var dx = max(-xm, -R); dx <= X; ++dx) {
				var val = _data[xm+dx+(ym+dy)*_width];
				if (is_undefined(_max) || val > _max) {
					_max = val;
				}
			}
		}
		return _max;
	};
	
	// Disk's mean
	static getDiskMean = function(xm, ym, r) {
		var _sum = 0,
			_count = 0;
		var Y = min(_height-ym-1, r);
		for (var dy = max(-ym, -r); dy <= Y; ++dy) {
			var R = r-abs(dy);
			var X = min(_width-xm-1, R);
			for (var dx = max(-xm, -R); dx <= X; ++dx) {
				_sum += _data[xm+dx+(ym+dy)*_width];
				++_count;
			}
		}
		return _sum/_count;
	};
	
	// Disk's min
	static getDiskMin = function(xm, ym, r) {
		var _min = undefined;
		var Y = min(_height-ym-1, r);
		for (var dy = max(-ym, -r); dy <= Y; ++dy) {
			var R = r-abs(dy);
			var X = min(_width-xm-1, R);
			for (var dx = max(-xm, -R); dx <= X; ++dx) {
				var val = _data[xm+dx+(ym+dy)*_width];
				if (is_undefined(_min) || val < _min) {
					_min = val;
				}
			}
		}
		return _min;
	};
	
	// Disk's sum
	static getDiskSum = function(xm, ym, r) {
		var _sum = 0;
		var Y = min(_height-ym-1, r);
		for (var dy = max(-ym, -r); dy <= Y; ++dy) {
			var R = r-abs(dy);
			var X = min(_width-xm-1, R);
			for (var dx = max(-xm, -R); dx <= X; ++dx) {
				_sum += _data[xm+dx+(ym+dy)*_width];
			}
		}
		return _sum;
	};
	
	// Shuffle everything
	static shuffle = function() {
		__lds_array_shuffle__(_data);
	};
	
	// Swap rows
	static _swap = function(i, j) {
		var temp = array_create(_width);
		var ii = i*_width;
		var jj = j*_width;
		array_copy(temp, 0, _data, ii, _width);
		array_copy(_data, ii, _data, jj, _width);
		array_copy(_data, jj, temp, 0, _width);
		delete temp;
	};
	
	// Shuffle rows
	static shuffleRows = function() {
		for (var i = _height-1; i > 0; --i) {
			var j = irandom(i);
			if (i != j) {
				_swap(i, j);
			}
		}
	};
	
	// Sort
	static sort = function() {
		var comparer = undefined,
			keyer = function(v) { return v; },
			ascend = true;
		switch (argument_count) {
			case 4: comparer = argument[3];
			case 3: if (!is_undefined(argument[2])) keyer = argument[2];
			case 2: ascend = argument[1];
			case 1: break;
			default: show_error("Expected 1-4 arguments, got " + string(argument_count) + ".", true);
		}
		var col = argument[0];
		// Sort key-row# pairs
		var sortArray = array_create(_height);
		for (var i = _height-1; i >= 0; --i) {
			sortArray[i] = [keyer(_data[col+i*_width]), i];
		}
		__lds_array_sort__(sortArray, ascend, function(sae) { return sae[0]; }, comparer);
		// Swap rows according to result
		var moveMap = array_create(_height, undefined); // This maps old row positions to current row positions
		for (var i = _height-1; i >= 0; --i) {
			var newi = sortArray[i][1];
			// If target row has been moved, forget about previous pairing, and pair current row to the new row
			while (!is_undefined(moveMap[newi])) {
				var prevnewi = newi;
				newi = moveMap[newi];
				moveMap[prevnewi] = undefined;
			}
			if (i != newi) {
				_swap(i, newi);
				moveMap[i] = newi;
			}
		}
		delete moveMap;
	};
	
	// To 2D array
	static to2dArray = function() {
		var to2d = array_create(_height);
		for (var i = _height-1; i >= 0; --i) {
			to2d[i] = array_create(_width);
			array_copy(to2d[i], 0, _data, _width*i, _width);
		}
		return to2d;
	};

	// Shallow copy from another grid
	static copy = function(source) {
		delete _data;
		_width = source._width;
		_height = source._height;
		var totalSize = _width*_height;
		_data = array_create(totalSize);
		array_copy(_data, 0, source._data, 0, totalSize);
	};
	
	// Create a shallow clone of this grid
	static clone = function() {
		var theClone = new Grid(_width, _height);
		theClone.copy(self);
		return theClone;
	};

	// Reduce this grid to a representation in basic data types
	static reduceToData = function() {
		var siz = _width*_height;
		var dataArray = array_create(siz+2);
		dataArray[siz] = _width;
		dataArray[siz+1] = _height;
		for (var i = siz-1; i >= 0; --i) {
			dataArray[i] = lds_reduce(_data[i]);
		}
		return dataArray;
	};
	
	// Expand the data to overwrite this grid
	static expandFromData = function(data) {
		var dataEndIndex = array_length(data)-1;
		_width = data[dataEndIndex-1];
		_height = data[dataEndIndex];
		_data = array_create(_width*_height);
		for (var i = dataEndIndex-2; i >= 0; --i) {
			_data[i] = lds_expand(data[i]);
		}
		return self;
	};
}

function GridIndexOutOfBoundsException(xx, yy) constructor {
	x = xx;
	y = yy;
	static toString = function() {
		return "Grid index (" + string(x) + "," + string(y) + ") is out of bounds.";
	}
}
