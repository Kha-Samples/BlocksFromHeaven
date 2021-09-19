package;

class Vector2i {
	public var x: Int;
	public var y: Int;

	public function new(x: Int, y: Int) {
		this.x = x;
		this.y = y;
	}

	public function assign(value: Vector2i) {
		x = value.x;
		y = value.y;
	}
}
