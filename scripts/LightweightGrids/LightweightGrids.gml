///@class Grid(...)
///@param {Any} ... The seeded content (see description)
///@desc Lightweight Grid class equivalent to DS grids. The seeded content can be any of the following:
///
///- new Grid(): Empty 0x0 grid.
///
///- new Grid(w): Empty wx1 grid.
///
///- new Grid(w, h, ...): New wxh grid with content in row-major order.
function Grid() constructor {
	// Set up basic properties and starting entries
	_canonType = "Grid";
	_type = "Grid";
	switch (argument_count) {
		case 0:
			_width = 0;
			_height = 0;
			_data = [];
			break;
		case 1:
			_width = argument[0];
			_height = 1;
			_data = array_create(_width, undefined);
			break;
		default:
			_width = argument[0];
			_height = argument[1];
			_data = array_create(_width*_height, undefined);
			var i = 0;
			repeat (argument_count-2) {
				_data[i] = argument[i+2];
				++i;
			}
	}

	///@func clear(val)
	///@self Grid
	///@param val The value to set entries to.
	///@desc Clear this grid with the given value.
	static clear = function(val) {
		var i = -1;
		repeat (_width*_height) {
			_data[++i] = val;
		}
	};

	///@func width()
	///@self Grid
	///@return {Real}
	///@desc Return the width of this grid.
	static width = function() {
		return _width;
	};

	///@func height()
	///@self Grid
	///@return {Real}
	///@desc Return the height of this grid.
	static height = function() {
		return _height;
	};

	///@func resize(w, h)
	///@self Grid
	///@param {Real} w The new width.
	///@param {Real} h The new height.
	///@desc Resize this grid to the given dimensions.
	static resize = function(w, h) {
		var wh = w*h;
		if (w == _width) {
			if (h > _height) {
				var newDataSize = _width*h;
				for (var i = _width*_height; i < newDataSize; ++i) {
					_data[i] = undefined;
				}
			} else if (h < _height) {
				array_resize(_data, wh);
			}
		} else {
			var _newdata = array_create(wh, undefined);
			var copyWidth = min(_width, w);
			for (var yy = min(_height, h)-1; yy >= 0; --yy) {
				__lds_array_copy__(_newdata, yy*w, _data, yy*_width, copyWidth);
			}
			_data = _newdata;
		}
		_width = w;
		_height = h;
	};

	///@func set(xx, yy, val)
	///@self Grid
	///@param {Real} xx The X position to set at.
	///@param {Real} yy The Y position to set at.
	///@param {Any} val The new value.
	///@desc Set a new value at the given position.
	static set = function(xx, yy, val) {
		if (xx < 0 || yy < 0 || xx >= _width || yy >= _height) {
			throw new GridIndexOutOfBoundsException(xx, yy);
		}
		_data[xx+yy*_width] = val;
	};

	///@func setDisk(xm, ym, r, val)
	///@self Grid
	///@param {Real} xm X position of the disk's centre
	///@param {Real} ym Y position of the disk's centre
	///@param {Real} r The radius of the disk
	///@param val The value to set to
	///@desc Set a new value to all entries on the disk.
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

	///@func setRegion(x1, y1, x2, y2, val)
	///@self Grid
	///@param {Real} x1 X position of the region's top-left corner
	///@param {Real} y1 Y position of the region's top-left corner
	///@param {Real} x2 X position of the region's bottom-right corner
	///@param {Real} y2 Y position of the region's bottom-right corner
	///@param val The value to set to
	///@desc Set a new value to all entries on the region.
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
	
	///@func setGridRegion(sourceGrid, x1, y1, x2, y2, xpos, ypos)
	///@self Grid
	///@param {Struct.Grid} sourceGrid The grid to copy from
	///@param {Real} x1 X position of the source region's top-left corner
	///@param {Real} y1 Y position of the source region's top-left corner
	///@param {Real} x2 X position of the source region's bottom-right corner
	///@param {Real} y2 Y position of the source region's bottom-right corner
	///@param xpos X position of the target region's top-left corner
	///@param ypos Y position of the target region's top-left corner
	///@desc Set values from the region in the source grid into the given position in this grid.
	static setGridRegion = function(sourceGrid, x1, y1, x2, y2, xpos, ypos) {
		var sx1 = max(0, x1),
			sy1 = max(0, y1),
			sx2 = min(sourceGrid._width-1, x2),
			sy2 = min(sourceGrid._height-1, y2),
			sourceWidth = sourceGrid._width,
			sourceRegionDx = sx2-sx1,
			sourceRegionDy = sy2-sy1,
			tx1 = max(0, xpos),
			ty1 = max(0, ypos),
			tx2 = min(_width-1, xpos+sourceRegionDx),
			ty2 = min(_height-1, ypos+sourceRegionDy),
			sourceData = sourceGrid._data,
			regionWidth = min(tx2-tx1, sourceRegionDx)+1,
			regionHeight = min(ty2-ty1, sourceRegionDy)+1;
		tx1 += sx1-x1;
		ty1 += sy1-y1;
		for (var yy = 0; yy < regionHeight; ++yy) {
			__lds_array_copy__(_data, tx1+(ty1+yy)*_width, sourceData, sx1+(sy1+yy)*sourceWidth, regionWidth);
		}
	};

	///@func get(xx, yy)
	///@self Grid
	///@param {Real} xx The X position to get
	///@param {Real} yy The Y position to get
	///@return {Any}
	///@desc Return the value at the given grid position.
	static get = function(xx, yy) {
		if (xx < 0 || yy < 0 || xx >= _width || yy >= _height) {
			throw new GridIndexOutOfBoundsException(xx, yy);
		}
		return _data[xx+yy*_width];
	};

	///@func add(xx, yy, val)
	///@self Grid
	///@param {Real} xx The X position to get
	///@param {Real} yy The X position to get
	///@param {Any} val The value to add
	///@desc Add the given value to the given grid position.
	static add = function(xx, yy, val) {
		if (xx < 0 || yy < 0 || xx >= _width || yy >= _height) {
			throw new GridIndexOutOfBoundsException(xx, yy);
		}
		_data[xx+yy*_width] += val;
	}

	///@func addDisk(xm, ym, r, val)
	///@self Grid
	///@param {Real} xm X position of the disk's centre
	///@param {Real} ym Y position of the disk's centre
	///@param {Real} r The radius of the disk
	///@param {Any} val The value to add
	///@desc Add the given value to all entries on the disk.
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

	///@func addRegion(x1, y1, x2, y2, val)
	///@self Grid
	///@param {Real} x1 X position of the region's top-left corner
	///@param {Real} y1 Y position of the region's top-left corner
	///@param {Real} x2 X position of the region's bottom-right corner
	///@param {Real} y2 Y position of the region's bottom-right corner
	///@param {Any} val The value to add
	///@desc Add the given value to all entries on the region.
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
	
	///@func addGridRegion(sourceGrid, x1, y1, x2, y2, xpos, ypos)
	///@self Grid
	///@param {Struct.Grid} sourceGrid The grid to copy from
	///@param {Real} x1 X position of the region's top-left corner
	///@param {Real} y1 Y position of the region's top-left corner
	///@param {Real} x2 X position of the region's bottom-right corner
	///@param {Real} y2 Y position of the region's bottom-right corner
	///@param xpos X position of the target region's top-left corner
	///@param ypos Y position of the target region's top-left corner
	///@desc Add values from the region in the source grid into the given position in this grid.
	static addGridRegion = function(sourceGrid, x1, y1, x2, y2, xpos, ypos) {
		var sx1 = max(0, x1),
			sy1 = max(0, y1),
			sx2 = min(sourceGrid._width-1, x2),
			sy2 = min(sourceGrid._height-1, y2),
			sourceWidth = sourceGrid._width,
			sourceRegionDx = sx2-sx1,
			sourceRegionDy = sy2-sy1,
			tx1 = max(0, xpos),
			ty1 = max(0, ypos),
			tx2 = min(_width-1, xpos+sourceRegionDx),
			ty2 = min(_height-1, ypos+sourceRegionDy),
			sourceData = sourceGrid._data,
			regionWidth = min(tx2-tx1, sourceRegionDx)+1,
			regionHeight = min(ty2-ty1, sourceRegionDy)+1;
		tx1 += sx1-x1;
		ty1 += sy1-y1;
		for (var yy = regionHeight-1; yy >= 0; --yy) {
			for (var xx = regionWidth-1; xx >= 0; --xx) {
				_data[@tx1+xx+(ty1+yy)*_width] += sourceData[sx1+xx+(sy1+yy)*sourceWidth];
			}
		}
	};

	///@func multiply(xx, yy, val)
	///@self Grid
	///@param {Real} xx X position to multiply
	///@param {Real} yy Y position to multiply
	///@param {Any} val The value to multiply by
	///@desc Multiply the given grid position by the given value.
	static multiply = function(xx, yy, val) {
		if (xx < 0 || yy < 0 || xx >= _width || yy >= _height) {
			throw new GridIndexOutOfBoundsException(xx, yy);
		}
		_data[xx+yy*_width] *= val;
	}

	///@func multiplyDisk(xm, ym, r, val)
	///@self Grid
	///@param {Real} xm X position of the disk's centre
	///@param {Real} ym Y position of the disk's centre
	///@param {Real} r The radius of the disk
	///@param {Any} val The value to multiply by
	///@desc Multiply entries in the disk by the given value.
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

	///@func multiplyRegion(x1, y1, x2, y2, val)
	///@self Grid
	///@param {Real} x1 X position of the region's top-left corner
	///@param {Real} y1 Y position of the region's top-left corner
	///@param {Real} x2 X position of the region's bottom-right corner
	///@param {Real} y2 Y position of the region's bottom-right corner
	///@param {Any} val The value to multiply by
	///@desc Multiply entries in the region by the given value.
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
	
	///@func multiplyGridRegion(sourceGrid, x1, y1, x2, y2, xpos, ypos)
	///@self Grid
	///@param {Struct.Grid} sourceGrid The grid to copy from
	///@param {Real} x1 X position of the region's top-left corner
	///@param {Real} y1 Y position of the region's top-left corner
	///@param {Real} x2 X position of the region's bottom-right corner
	///@param {Real} y2 Y position of the region's bottom-right corner
	///@param xpos X position of the target region's top-left corner
	///@param ypos Y position of the target region's top-left corner
	///@desc Multiply values from the region in the source grid into the given position in this grid.
	static multiplyGridRegion = function(sourceGrid, x1, y1, x2, y2, xpos, ypos) {
		var sx1 = max(0, x1),
			sy1 = max(0, y1),
			sx2 = min(sourceGrid._width-1, x2),
			sy2 = min(sourceGrid._height-1, y2),
			sourceWidth = sourceGrid._width,
			sourceRegionDx = sx2-sx1,
			sourceRegionDy = sy2-sy1,
			tx1 = max(0, xpos),
			ty1 = max(0, ypos),
			tx2 = min(_width-1, xpos+sourceRegionDx),
			ty2 = min(_height-1, ypos+sourceRegionDy),
			sourceData = sourceGrid._data,
			regionWidth = min(tx2-tx1, sourceRegionDx)+1,
			regionHeight = min(ty2-ty1, sourceRegionDy)+1;
		tx1 += sx1-x1;
		ty1 += sy1-y1;
		for (var yy = regionHeight-1; yy >= 0; --yy) {
			for (var xx = regionWidth-1; xx >= 0; --xx) {
				_data[@tx1+xx+(ty1+yy)*_width] *= sourceData[sx1+xx+(sy1+yy)*sourceWidth];
			}
		}
	};

	///@func valueExists(x1, y1, x2, y2, val)
	///@self Grid
	///@param {Real} x1 X position of the region's top-left corner
	///@param {Real} y1 Y position of the region's top-left corner
	///@param {Real} x2 X position of the region's bottom-right corner
	///@param {Real} y2 Y position of the region's bottom-right corner
	///@param {Any} val The value to search for
	///@return {Bool}
	///@desc Return whether the given value in in the region.
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
	
	///@func valueDiskExists(xm, ym, r, val)
	///@self Grid
	///@param {Real} xm X position of the disk's centre
	///@param {Real} ym Y position of the disk's centre
	///@param {Real} r The radius of the disk
	///@param {Any} val The value to search for
	///@return {Bool}
	///@desc Return whether the given value in in the disk.
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
	
	///@func valueX(x1, y1, x2, y2, val)
	///@self Grid
	///@param {Real} x1 X position of the region's top-left corner
	///@param {Real} y1 Y position of the region's top-left corner
	///@param {Real} x2 X position of the region's bottom-right corner
	///@param {Real} y2 Y position of the region's bottom-right corner
	///@param {Any} val The value to search for
	///@return {Real}
	///@desc Return the value's X position in the region. If not found, return -1.
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
	
	///@func valueY(x1, y1, x2, y2, val)
	///@self Grid
	///@param {Real} x1 X position of the region's top-left corner
	///@param {Real} y1 Y position of the region's top-left corner
	///@param {Real} x2 X position of the region's bottom-right corner
	///@param {Real} y2 Y position of the region's bottom-right corner
	///@param {Any} val The value to search for
	///@return {Real}
	///@desc Return the value's Y position in the region. If not found, return -1.
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
	
	///@func valueDiskX(xm, ym, r, val)
	///@self Grid
	///@param {Real} xm X position of the disk's centre
	///@param {Real} ym Y position of the disk's centre
	///@param {Real} r The radius of the disk
	///@param {Any} val The value to search for
	///@return {Real}
	///@desc Return the value's X position in the disk. If not found, return -1.
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
	
	///@func valueDiskY(xm, ym, r, val)
	///@self Grid
	///@param {Real} xm X position of the disk's centre
	///@param {Real} ym Y position of the disk's centre
	///@param {Real} r The radius of the disk
	///@param {Any} val The value to search for
	///@return {Real}
	///@desc Return the value's Y position in the disk. If not found, return -1.
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
	
	///@func getMax(x1, y1, x2, y2)
	///@self Grid
	///@param {Real} x1 X position of the region's top-left corner
	///@param {Real} y1 Y position of the region's top-left corner
	///@param {Real} x2 X position of the region's bottom-right corner
	///@param {Real} y2 Y position of the region's bottom-right corner
	///@return {Any}
	///@desc Return the maximum value in the region.
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
	
	///@func getMean(x1, y1, x2, y2)
	///@self Grid
	///@param {Real} x1 X position of the region's top-left corner
	///@param {Real} y1 Y position of the region's top-left corner
	///@param {Real} x2 X position of the region's bottom-right corner
	///@param {Real} y2 Y position of the region's bottom-right corner
	///@return {Real}
	///@desc Return the mean value of the region.
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
	
	///@func getMin(x1, y1, x2, y2)
	///@self Grid
	///@param {Real} x1 X position of the region's top-left corner
	///@param {Real} y1 Y position of the region's top-left corner
	///@param {Real} x2 X position of the region's bottom-right corner
	///@param {Real} y2 Y position of the region's bottom-right corner
	///@return {Any}
	///@desc Return the minimum value in the region.
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
	
	///@func getSum(x1, y1, x2, y2)
	///@self Grid
	///@param {Real} x1 X position of the region's top-left corner
	///@param {Real} y1 Y position of the region's top-left corner
	///@param {Real} x2 X position of the region's bottom-right corner
	///@param {Real} y2 Y position of the region's bottom-right corner
	///@return {Any}
	///@desc Return the sum of values in the region.
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
	
	///@func getDiskMax(xm, ym, r)
	///@self Grid
	///@param {Real} xm X position of the disk's centre
	///@param {Real} ym Y position of the disk's centre
	///@param {Real} r The radius of the disk
	///@return {Any}
	///@desc Return the maximum value in the disk.
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
	
	///@func getDiskMean(xm, ym, r)
	///@self Grid
	///@param {Real} xm X position of the disk's centre
	///@param {Real} ym Y position of the disk's centre
	///@param {Real} r The radius of the disk
	///@return {Real}
	///@desc Return the mean value of the disk.
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
	
	///@func getDiskMin(xm, ym, r)
	///@self Grid
	///@param {Real} xm X position of the disk's centre
	///@param {Real} ym Y position of the disk's centre
	///@param {Real} r The radius of the disk
	///@return {Any}
	///@desc Return the minimum value in the disk.
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
	
	///@func getDiskSum(xm, ym, r)
	///@self Grid
	///@param {Real} xm X position of the disk's centre
	///@param {Real} ym Y position of the disk's centre
	///@param {Real} r The radius of the disk
	///@return {Any}
	///@desc Return the sum of values in the disk.
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
	
	///@func shuffle()
	///@self Grid
	///@desc Shuffle everything
	static shuffle = function() {
		__lds_array_shuffle__(_data);
	};
	
	///@func _swap(i, j)
	///@self Grid
	///@param {Real} i The first row
	///@param {Real} j The second row
	///@ignore
	///@desc (INTERNAL: Lightweight Data Structures - Grid) Swap rows
	static _swap = function(i, j) {
		var temp = array_create(_width);
		var ii = i*_width;
		var jj = j*_width;
		__lds_array_copy__(temp, 0, _data, ii, _width);
		__lds_array_copy__(_data, ii, _data, jj, _width);
		__lds_array_copy__(_data, jj, temp, 0, _width);
	};
	
	///@func shuffleRows()
	///@self Grid
	///@desc Shuffle the rows of this grid.
	static shuffleRows = function() {
		for (var i = _height-1; i > 0; --i) {
			var j = irandom(i);
			if (i != j) {
				_swap(i, j);
			}
		}
	};
	
	///@func sort(col, [ascend], [keyer], [comparer])
	///@self Grid
	///@param {Real} col The column to sort by
	///@param {Bool} ascend (optional) To sort in ascending order (true, default) or descending order (false) 
	///@param {Function} keyer (optional) Function that returns the value to sort using.
	///@param {Function,Undefined} comparer (optional) Custom comparing function that accepts a and b and returns whether a > b.
	///@desc Sort the rows of this grid by the given column.
	static sort = function(col, ascend=true, keyer=function(v) { return v; }, comparer=undefined) {
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
	};
	
	///@func to2dArray()
	///@self Grid
	///@return {Array<Array>}
	///@desc Return the 2D array equivalent of this grid.
	static to2dArray = function() {
		var to2d = array_create(_height);
		for (var i = _height-1; i >= 0; --i) {
			to2d[i] = array_create(_width);
			__lds_array_copy__(to2d[i], 0, _data, _width*i, _width);
		}
		return to2d;
	};

	///@func copy(source)
	///@self Grid
	///@param {Struct.Grid} source The source grid to copy from.
	///@desc Shallow copy from another grid.
	static copy = function(source) {
		_width = source._width;
		_height = source._height;
		var totalSize = _width*_height;
		_data = array_create(totalSize);
		__lds_array_copy__(_data, 0, source._data, 0, totalSize);
	};
	
	///@func clone()
	///@self Grid
	///@return {Struct.Grid}
	///@desc Create a shallow clone of this grid.
	static clone = function() {
		var theClone = new Grid(_width, _height);
		theClone.copy(self);
		return theClone;
	};

	///@func reduceTodata()
	///@self Grid
	///@return {Any}
	///@desc Return a reduction of this grid to a representation in basic data types.
	static reduceToData = function() {
		var siz = _width*_height;
		var dataArray = array_create(siz+2);
		dataArray[siz] = _width;
		dataArray[siz+1] = _height;
		for (var i = siz-1; i >= 0; --i) {
			dataArray[i] = lds_reduce(_data[i]);
		}
		///Feather disable GM1045
		return dataArray;
		///Feather enable GM1045
	};
	
	///@func expandFromData(data)
	///@self Grid
	///@param {Any} data The reduction data to receive
	///@return {Struct.Grid}
	///@desc Expand the reduced data to overwrite this grid.
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
	
	///@func copyDeep(source)
	///@self Grid
	///@param {Struct.Grid} source The source grid to copy from
	///@desc Deep copy from another grid
	static copyDeep = function(source) {
		_width = source._width;
		_height = source._height;
		var totalSize = _width*_height;
		_data = array_create(totalSize);
		var sourceData = source._data;
		for (var i = totalSize-1; i >= 0; --i) {
			_data[i] = lds_clone_deep(sourceData[i]);
		}
	};
	
	///@func cloneDeep()
	///@self Grid
	///@return {Struct.Grid}
	///@desc Create a deep clone of this grid.
	static cloneDeep = function() {
		var theClone = new Grid(_width, _height);
		theClone.copyDeep(self);
		return theClone;
	};
	
	///@func read(datastr)
	///@self Grid
	///@param {String} datastr The data string to load from
	///@desc Load from the given data string.
	static read = function(datastr) {
		var data = json_parse(datastr);
		if (!is_struct(data)) throw new IncompatibleDataException(instanceof(self), typeof(data));
		if (data.t != instanceof(self)) throw new IncompatibleDataException(instanceof(self), data.t);
		expandFromData(data.d);
	};
	
	///@func write()
	///@self Grid
	///@return {String}
	///@desc Save into a data string and return it.
	static write = function() {
		return lds_write(self);
	};
	
	///@func forEach(func)
	///@self Grid
	///@param {Function} func The function to execute on each entry
	///@desc Perform a function for each entry in the grid
	static forEach = function(func) {
		for (var yy = 0; yy < _height; ++yy) {
			for (var xx = 0; xx < _width; ++xx) {
				if (is_method(func)) {
					func(_data[xx+yy*_width], xx, yy);
				} else {
					script_execute(func, _data[xx+yy*_width], xx, yy);
				}
			}
		}
	};
	
	///@func forEachInDisk(func, xm, ym, r)
	///@self Grid
	///@param {Function} func The function to execute on each entry
	///@param {Real} xm X position of the disk's centre
	///@param {Real} ym Y position of the disk's centre
	///@param {Real} r The radius of the disk
	///@desc Perform a function for each entry in a disk on the grid
	static forEachInDisk = function(func, xm, ym, r) {
		var Y = min(_height-ym-1, r);
		for (var dy = max(-ym, -r); dy <= Y; ++dy) {
			var R = r-abs(dy);
			var X = min(_width-xm-1, R);
			for (var dx = max(-xm, -R); dx <= X; ++dx) {
				if (is_method(func)) {
					func(_data[xm+dx+(ym+dy)*_width], xm+dx, ym+dy);
				} else {
					script_execute(func, _data[xm+dx+(ym+dy)*_width], xm+dx, ym+dy);
				}
			}
		}
	};
	
	///@func forEachInRegion(func, x1, y1, x2, y2)
	///@self Grid
	///@param {Function} func The function to execute on each entry
	///@param {Real} x1 X position of the region's top-left corner
	///@param {Real} y1 Y position of the region's top-left corner
	///@param {Real} x2 X position of the region's bottom-right corner
	///@param {Real} y2 Y position of the region's bottom-right corner
	///@desc Perform a function for each entry in a region on the grid
	static forEachInRegion = function(func, x1, y1, x2, y2) {
		var _x1 = max(0, x1),
			_y1 = max(0, y1),
			_x2 = min(_width-1, x2),
			_y2 = min(_height-1, y2);
		for (var yy = _y1; yy <= _y2; ++yy) {
			for (var xx = _x1; xx <= _x2; ++xx) {
				if (is_method(func)) {
					func(_data[xx+yy*_width], xx, yy);
				} else {
					script_execute(func, _data[xx+yy*_width], xx, yy);
				}
			}
		}
	};
	
	///@func mapEach(func)
	///@self Grid
	///@param {Function} func The function to execute on each entry
	///@desc Set each entry in the grid to the return value of a function.
	static mapEach = function(func) {
		for (var yy = 0; yy < _height; ++yy) {
			for (var xx = 0; xx < _width; ++xx) {
				var pos = xx+yy*_width;
				if (is_method(func)) {
					_data[@pos] = func(_data[pos]);
				} else {
					_data[@pos] = script_execute(func, _data[pos]);
				}
			}
		}
	};
	
	///@func mapEachInDisk(func, xm, ym, r)
	///@self Grid
	///@param {Function} func The function to execute on each entry
	///@param {Real} xm X position of the disk's centre
	///@param {Real} ym Y position of the disk's centre
	///@param {Real} r The radius of the disk
	///@desc Set each entry in a disk on the grid to the return value of a function.
	static mapEachInDisk = function(func, xm, ym, r) {
		var Y = min(_height-ym-1, r);
		for (var dy = max(-ym, -r); dy <= Y; ++dy) {
			var R = r-abs(dy);
			var X = min(_width-xm-1, R);
			for (var dx = max(-xm, -R); dx <= X; ++dx) {
				var pos = xm+dx+(ym+dy)*_width;
				if (is_method(func)) {
					_data[@pos] = func(_data[pos]);
				} else {
					_data[@pos] = script_execute(func, _data[pos]);
				}
			}
		}
	};
	
	///@func mapEachInRegion(func, x1, y1, x2, y2)
	///@self Grid
	///@param {Function} func The function to execute on each entry
	///@param {Real} x1 X position of the region's top-left corner
	///@param {Real} y1 Y position of the region's top-left corner
	///@param {Real} x2 X position of the region's bottom-right corner
	///@param {Real} y2 Y position of the region's bottom-right corner
	///@desc Set each entry in a region on the grid to the return value of a function.
	static mapEachInRegion = function(func, x1, y1, x2, y2) {
		var _x1 = max(0, x1),
			_y1 = max(0, y1),
			_x2 = min(_width-1, x2),
			_y2 = min(_height-1, y2);
		for (var yy = _y1; yy <= _y2; ++yy) {
			for (var xx = _x1; xx <= _x2; ++xx) {
				var pos = xx+yy*_width;
				if (is_method(func)) {
					_data[@pos] = func(_data[pos]);
				} else {
					_data[@pos] = script_execute(func, _data[pos]);
				}
			}
		}
	};
	
	///@func iterator()
	///@self Grid
	///@return {Struct.GridRegionIterator}
	///@desc Return an iterator for the entire grid.
	static iterator = function() {
		return new GridRegionIterator(self, 0, 0, _width-1, _height-1);
	};
	
	///@func diskIterator(xm, ym, r)
	///@self Grid
	///@param {Real} xm X position of the disk's centre
	///@param {Real} ym Y position of the disk's centre
	///@param {Real} r The radius of the disk
	///@return {Struct.GridDiskIterator}
	///@desc Return an iterator for a disk region of the grid.
	static diskIterator = function(xm, ym, r) {
		return new GridDiskIterator(self, xm, ym, r);
	};
	
	///@func regionIterator(x1, y1, x2, y2)
	///@self Grid
	///@param {Real} x1 X position of the region's top-left corner
	///@param {Real} y1 Y position of the region's top-left corner
	///@param {Real} x2 X position of the region's bottom-right corner
	///@param {Real} y2 Y position of the region's bottom-right corner
	///@return {Struct.GridRegionIterator}
	///@desc Return an iterator for a rectangular region of this grid.
	static regionIterator = function(x1, y1, x2, y2) {
		return new GridRegionIterator(self, x1, y1, x2, y2);
	};
}

///@class GridDiskIterator(grid, _xm, _ym, _r)
///@param {Struct.Grid} grid The grid to iterate through.
///@param {Real} _xm X coordinate of the middle.
///@param {Real} _ym Y coordinate of the middle.
///@param {Real} _r The disk's radius.
///@desc Utility for iterating through a disk on the given grid.
function GridDiskIterator(grid, _xm, _ym, _r) constructor {
	_grid = grid;
	_width = grid._width;
	_height = grid._height;
	xm = _xm;
	ym = _ym;
	r = _r;
	_Y = min(grid._height-ym-1, r);
	_dy = max(-ym, -r);
	_R = r-abs(_dy);
	_X = min(grid._width-xm-1, _R);
	_dx = max(-xm, -_R);
	xx = xm+_dx;
	yy = ym+_dy;
	value = (xx > 0 && yy > 0 && xx < _width && yy < _height) ? grid._data[xx+yy*_width] : undefined;
	
	///@func hasNext()
	///@self GridDiskIterator
	///@return {Bool}
	///@desc Return whether there are more entries to iterate.
	static hasNext = function() {
		return (_dx <= _X) && (_dy <= _Y);
	};
	
	///@func next()
	///@self GridDiskIterator
	///@desc Iterate to the next entry.
	static next = function() {
		if (++_dx > _X) {
			if (++_dy > _Y) {
				value = undefined;
				return false;
			}
			_R = r-abs(_dy);
			_X = min(_width-xm-1, _R);
			_dx = max(-xm, -_R);
			yy = ym+_dy;
		}
		xx = xm+_dx;
		value = _grid._data[xx+yy*_width];
	};
	
	///@func set(val)
	///@self GridDiskIterator
	///@param {Any} val 
	///@desc Set the value that the current iteration points to.
	static set = function(val) {
		_grid._data[@xx+yy*_width] = val;
		value = val;
	};
}

///@class GridRegionIterator(grid, _x1, _y1, _x2, _y2)
///@param {Struct.Grid} grid The grid to iterate through.
///@param {Real} _x1 The X coordinate of the top-left corner.
///@param {Real} _y1 The Y coordinate of the top-left corner.
///@param {Real} _x2 The X coordinate of the bottom-right corner.
///@param {Real} _y2 The Y coordinate of the bottom-right corner.
///@desc Utility for iterating through a rectangular region on the given grid.
function GridRegionIterator(grid, _x1, _y1, _x2, _y2) constructor {
	_grid = grid;
	_width = grid._width;
	_height = grid._height;
	x1 = max(0, _x1);
	y1 = max(0, _y1);
	x2 = min(_width-1, _x2);
	y2 = min(_height-1, _y2);
	xx = x1;
	yy = y1;
	value = (xx <= x2 && yy <= y2) ? _grid._data[xx+yy*_width] : undefined;
	
	///@func hasNext()
	///@self GridRegionIterator
	///@return {Bool}
	///@desc Return whether there are more entries to iterate.
	static hasNext = function() {
		return (xx <= x2 && yy <= y2);
	};
	
	///@func next()
	///@self GridRegionIterator
	///@desc Iterate to the next entry.
	static next = function() {
		if (++xx > x2) {
			if (++yy > y2) {
				value = undefined;
				return false;
			}
			xx = x1;
		}
		value = _grid._data[xx+yy*_width];
	};
	
	///@func set(val)
	///@self GridRegionIterator
	///@param {Any} val 
	///@desc Set the value that the current iteration points to.
	static set = function(val) {
		_grid._data[@xx+yy*_width] = val;
		value = val;
	};
}

///@class GridIndexOutOfBoundsException(xx, yy)
///@param {Real} xx The X position.
///@param {Real} yy The Y position.
///@desc Exception when accessing a Grid beyond its size boundaries.
function GridIndexOutOfBoundsException(xx, yy) constructor {
	self.xx = xx;
	self.yy = yy;
	
	///@func toString()
	///@self GridIndexOutOfBoundsException
	///@return {String}
	///@desc Return a string message describing the exception.
	static toString = function() {
		return "Grid index (" + string(xx) + "," + string(yy) + ") is out of bounds.";
	}
}
