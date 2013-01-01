package;

import kha.Painter;

class BigBlock {
	public static var next: BigBlock;
	public static var current: BigBlock;
	
	private var center: Vector2i;
	private var blocks: Array<Block>;

	public function new(xx: Int, yy: Int) {
		center = new Vector2i(xx, yy);
		blocks = new Array<Block>();
		for (i in 0...4) blocks.push(null);
	}
	
	public function draw(painter: Painter): Void {
		for (i in 0...4) blocks[i].draw(painter);
	}
	
	public function right(): Void {
		var i: Int = 0;
		try {
			while (i < 4) {
				blocks[i].right();
				++center.x;
				++i;
			}
		}
		catch (e: Exception) {
			--i;
			while (i >= 0) {
				blocks[i].back();
				--i;
			}
		}
	}
	
	public function left(): Void {
		var i: Int = 0;
		try {
			while (i < 4) {
				blocks[i].left();
				--center.x;
				++i;
			}
		}
		catch (e: Exception) {
			--i;
			while (i >= 0) {
				blocks[i].back();
				--i;
			}
		}
	}

	public function down(): Bool {
		var i: Int = 0;
		try {
			while (i < 4) {
				blocks[i].down();
				--center.y;
				++i;
			}
		}
		catch (e: Exception) {
			--i;
			while (i >= 0) {
				blocks[i].back();
				--i;
			}
			return false;
		}
		return true;
	}
	
	public function getBlock(b: Int): Block {
		return blocks[b];
	}
	
	public function rotate(): Void {
		var i: Int = 0;
		try {
			while (i < 4) {
				blocks[i].rotate(center);
				++i;
			}
		}
		catch (e: Exception) {
			--i;
			while (i >= 0) {
				blocks[i].back();
				--i;
			}
		}
	}
	
	public function hop(): Void {
		var i: Int = 0;
		while (i < 4) {
			blocks[i].left(10);
			++i;
		}
		center.x -= 10;
	}
}

class IBlock extends BigBlock {
	public function new() {
		super(15, 21);
		blocks[0] = new Block(15, 22, 1, 0, 0); blocks[1] = new Block(15, 21, 1, 0, 0);
		blocks[2] = new Block(15, 20, 1, 0, 0); blocks[3] = new Block(15, 19, 1, 0, 0);
	}
}

class OBlock extends BigBlock {
	public function new() {
		super(15, 21);
		blocks[0] = new Block(14, 22, 0, 0, 1); blocks[1] = new Block(14, 21, 0, 0, 1);
		blocks[2] = new Block(15, 22, 0, 0, 1); blocks[3] = new Block(15, 21, 0, 0, 1);
	}
	
	override public function rotate(): Void {
		
	}
}

class LBlock extends BigBlock {
	public function new() {
		super(14, 21);
		blocks[0] = new Block(14, 22, 1, 0, 1); blocks[1] = new Block(14, 21, 1, 0, 1);
		blocks[2] = new Block(14, 20, 1, 0, 1); blocks[3] = new Block(15, 20, 1, 0, 1);
	}
}

class JBlock extends BigBlock {
	public function new() {
		super(14, 21);
		blocks[0] = new Block(15, 22, 1, 1, 0); blocks[1] = new Block(15, 21, 1, 1, 0);
		blocks[2] = new Block(15, 20, 1, 1, 0); blocks[3] = new Block(14, 20, 1, 1, 0);
	}
}

class TBlock extends BigBlock {
	public function new() {
		super(15, 21);
		blocks[0] = new Block(14, 22, 0, 1, 0); blocks[1] = new Block(15, 22, 0, 1, 0);
		blocks[2] = new Block(16, 22, 0, 1, 0); blocks[3] = new Block(15, 21, 0, 1, 0);
	}
}

class ZBlock extends BigBlock {
	public function new() {
		super(15, 22);
		blocks[0] = new Block(14, 22, 1, 0.5, 0); blocks[1] = new Block(15, 22, 1, 0.5, 0);
		blocks[2] = new Block(15, 21, 1, 0.5, 0); blocks[3] = new Block(16, 21, 1, 0.5, 0);
	}
}

class SBlock extends BigBlock {
	public function new() {
		super(15, 21);
		blocks[0] = new Block(14, 21, 0, 1, 1); blocks[1] = new Block(15, 21, 0, 1, 1);
		blocks[2] = new Block(15, 22, 0, 1, 1); blocks[3] = new Block(16, 22, 0, 1, 1);
	}
}