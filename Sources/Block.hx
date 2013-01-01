package;

import kha.Image;
import kha.Loader;
import kha.Painter;

class Block {
	public static var xsize: Int = 12;
	public static var ysize: Int = 23;
	public static var blocked: Array<Array<Block>> = new Array<Array<Block>>(); // [xsize][ysize];

	private var image: Image;
	private var r: Float;
	private var g: Float;
	private var b: Float;
	private var pos: Vector2i;
	private var lastpos: Vector2i;
	
	public function new(xx: Int, yy: Int, rr: Float = 0, gg: Float = 0, bb: Float = 0) {
		pos = new Vector2i(xx, yy);
		r = rr;
		g = gg;
		b = bb;
		image = Loader.the.getImage("block_red");
	}

	public function draw(painter: Painter) {
		painter.drawImage(image, pos.x, pos.y);
	}

	public function getX(): Int {
		return pos.x;
	}
	
	public function getY(): Int {
		return pos.y;
	}
	
	public function getPos(): Vector2i {
		return pos;
	}
	
	public function right(i: Int = 1): Void {
		if (blocked[pos.x + i][pos.y] != null) throw new Exception();
		lastpos = pos;
		pos.x += i;
	}
	
	public function left(i: Int = 1): Void {
		if (blocked[pos.x - i][pos.y] != null) throw new Exception();
		lastpos = pos;
		pos.x -= i;
	}
	
	public function down(i: Int = 1): Void {
		if (blocked[pos.x][pos.y - i] != null) throw new Exception();
		lastpos = pos;
		pos.y -= i;
	}
	
	public function up(i: Int = 1): Void {
		if (blocked[pos.x][pos.y + i] != null) throw new Exception();
		lastpos = pos;
		pos.y += i;
	}
	
	public function rotate(center: Vector2i): Void {
		var newpos = new Vector2i(center.x - (pos.y - center.y), center.y + (pos.x - center.x));
		if (blocked[newpos.x][newpos.y] != null) throw new Exception();
		lastpos = pos;
		pos = newpos;
		//FSOUND_PlaySound(1, boing);
	}
	
	public function back(): Void {
		pos = lastpos;
	}
}