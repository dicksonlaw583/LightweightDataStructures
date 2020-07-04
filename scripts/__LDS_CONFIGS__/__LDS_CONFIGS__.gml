/* Configure type base constructors here */
global.__lds_registry__ = {
	Stack: function() {
		return new Stack();
	},
	Queue: function() {
		return new Queue();
	},
	List: function() {
		return new List();
	},
	Map: function() {
		return new Map();
	},
	Heap: function() {
		return new Heap();
	},
	Grid: function() {
		return new Grid();
	},
};
