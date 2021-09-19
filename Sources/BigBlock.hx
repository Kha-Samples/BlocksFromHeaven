package;

import kha.Assets;
import kha.audio1.Audio;
import kha.graphics2.Graphics;

class BigBlock {
	public static var next: BigBlock;
	public static var current: BigBlock;

	var center: Vector2i;
	var blocks: Array<GameBlock>;

	public function new(xx: Int, yy: Int) {
		center = new Vector2i(xx, yy);
		blocks = new Array<GameBlock>();
		for (i in 0...4)
			blocks.push(null);
	}

	public function draw(g: Graphics): Void {
		for (i in 0...4)
			blocks[i].draw(g);
	}

	public function right(): Void {
		var i: Int = 0;
		try {
			while (i < 4) {
				blocks[i].right();
				++i;
			}
			++center.x;
		}
		catch (e:Exception) {
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
				++i;
			}
			--center.x;
		}
		catch (e:Exception) {
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
				++i;
			}
			--center.y;
		}
		catch (e:Exception) {
			--i;
			while (i >= 0) {
				blocks[i].back();
				--i;
			}
			return false;
		}
		return true;
	}

	public function getBlock(b: Int): GameBlock {
		return blocks[b];
	}

	public function rotate(): Void {
		Audio.play(Assets.sounds.rotate);
		var i: Int = 0;
		try {
			while (i < 4) {
				blocks[i].rotate(center);
				++i;
			}
		}
		catch (e:Exception) {
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
			blocks[i].up(8);
			blocks[i].left(8);
			blocks[i].down(4);
			++i;
		}
		center.x -= 8;
		center.y += 4;
	}
}

class IBlock extends BigBlock {
	public function new() {
		super(13, 17);
		var image = Assets.images.block_red;
		blocks[0] = new GameBlock(13, 18, image);
		blocks[1] = new GameBlock(13, 17, image);
		blocks[2] = new GameBlock(13, 16, image);
		blocks[3] = new GameBlock(13, 15, image);
	}
}

class OBlock extends BigBlock {
	public function new() {
		super(13, 17);
		var image = Assets.images.block_orange;
		blocks[0] = new GameBlock(12, 18, image);
		blocks[1] = new GameBlock(12, 17, image);
		blocks[2] = new GameBlock(13, 18, image);
		blocks[3] = new GameBlock(13, 17, image);
	}

	override public function rotate(): Void {}
}

class LBlock extends BigBlock {
	public function new() {
		super(12, 17);
		var image = Assets.images.block_blue;
		blocks[0] = new GameBlock(12, 18, image);
		blocks[1] = new GameBlock(12, 17, image);
		blocks[2] = new GameBlock(12, 16, image);
		blocks[3] = new GameBlock(13, 16, image);
	}
}

class JBlock extends BigBlock {
	public function new() {
		super(12, 17);
		var image = Assets.images.block_yellow;
		blocks[0] = new GameBlock(13, 18, image);
		blocks[1] = new GameBlock(13, 17, image);
		blocks[2] = new GameBlock(13, 16, image);
		blocks[3] = new GameBlock(12, 16, image);
	}
}

class TBlock extends BigBlock {
	public function new() {
		super(13, 17);
		var image = Assets.images.block_green;
		blocks[0] = new GameBlock(12, 18, image);
		blocks[1] = new GameBlock(13, 18, image);
		blocks[2] = new GameBlock(14, 18, image);
		blocks[3] = new GameBlock(13, 17, image);
	}
}

class ZBlock extends BigBlock {
	public function new() {
		super(13, 18);
		var image = Assets.images.block_purple;
		blocks[0] = new GameBlock(12, 18, image);
		blocks[1] = new GameBlock(13, 18, image);
		blocks[2] = new GameBlock(13, 17, image);
		blocks[3] = new GameBlock(14, 17, image);
	}
}

class SBlock extends BigBlock {
	public function new() {
		super(13, 17);
		var image = Assets.images.block_violet;
		blocks[0] = new GameBlock(12, 17, image);
		blocks[1] = new GameBlock(13, 17, image);
		blocks[2] = new GameBlock(13, 18, image);
		blocks[3] = new GameBlock(14, 18, image);
	}
}
