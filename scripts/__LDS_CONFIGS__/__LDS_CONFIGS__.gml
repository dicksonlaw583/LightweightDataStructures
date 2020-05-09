/* Configure reducers here */
global.__lds_reducers__ = {
	Stack: function(s) { return s.reduceToData(); },
	Queue: function(s) { return s.reduceToData(); },
	List: function(s) { return s.reduceToData(); },
	Map: function(s) { return s.reduceToData(); },
	Heap: function(s) { return s.reduceToData(); },
	Grid: function(s) { return s.reduceToData(); },
};

/* Configure expanders here */
global.__lds_expanders__ = {
	Stack: function(d) { var s = new Stack(); s.expandFromData(d); return s; },
	Queue: function(d) { var s = new Queue(); s.expandFromData(d); return s; },
	List: function(d) { var s = new List(); s.expandFromData(d); return s; },
	Map: function(d) { var s = new Map(); s.expandFromData(d); return s; },
	Heap: function(d) { var s = new Heap(); s.expandFromData(d); return s; },
	Grid: function(d) { var s = new Grid(d.w, d.h); s.expandFromData(d); return s; },
};
