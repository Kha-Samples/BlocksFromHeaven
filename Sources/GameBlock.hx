package;

import kha.graphics2.Graphics;
import kha.Image;

class GameBlock {
	public static var xsize: Int = 12;
	public static var ysize: Int = 23;
	public static var blocked: Array<Array<GameBlock>> = new Array<Array<GameBlock>>();

	var image: Image;
	var pos: Vector2i;
	var lastpos: Vector2i;

	public function new(xx: Int, yy: Int, image: Image) {
		pos = new Vector2i(xx, yy);
		lastpos = new Vector2i(xx, yy);
		this.image = image;
	}

	public function draw(g: Graphics) {
		if (image != null)
			g.drawImage(image, 16 + pos.x * 16, 400 - pos.y * 16);
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
		if (blocked[pos.x + i][pos.y] != null)
			throw new Exception();
		lastpos.assign(pos);
		pos.x += i;
	}

	public function left(i: Int = 1): Void {
		if (blocked[pos.x - i][pos.y] != null)
			throw new Exception();
		lastpos.assign(pos);
		pos.x -= i;
	}

	public function down(i: Int = 1): Void {
		if (blocked[pos.x][pos.y - i] != null)
			throw new Exception();
		lastpos.assign(pos);
		pos.y -= i;
	}

	public function up(i: Int = 1): Void {
		if (blocked[pos.x][pos.y + i] != null)
			throw new Exception();
		lastpos.assign(pos);
		pos.y += i;
	}

	public function rotate(center: Vector2i): Void {
		var newpos = new Vector2i(center.x - (pos.y - center.y), center.y + (pos.x - center.x));
		if (blocked[newpos.x][newpos.y] != null)
			throw new Exception();
		lastpos.assign(pos);
		pos.assign(newpos);
	}

	public function back(): Void {
		pos.assign(lastpos);
	}
}
