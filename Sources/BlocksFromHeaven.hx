package;

import haxe.Timer;
import kha.Button;
import kha.Configuration;
import kha.Game;
import kha.Image;
import kha.Loader;
import kha.LoadingScreen;
import kha.Painter;
import kha.Random;

import BigBlock;

class BlocksFromHeaven extends Game {
	private var board: Image;
	private var count: Int = 0;
	private var faster: Bool = false;
	
	public function new() {
		super("BlocksFromHeaven", false);
	}
	
	override public function init(): Void {
		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom("blocks", loadingFinished);
	}
	
	private function loadingFinished(): Void {
		Random.init(Std.int(Timer.stamp() * 1000));
		
		for (x in 0...Block.xsize) for (y in 0...Block.ysize) {
			Block.blocked.push(new Array<Block>());
			Block.blocked[x].push(null);
		}
		
		for (y in 0...Block.ysize) Block.blocked[0][y] = new Block(0, y, null);
		for (y in 0...Block.ysize) Block.blocked[Block.xsize - 1][y] = new Block(Block.xsize - 1, y, null);
		for (x in 0...Block.xsize) Block.blocked[x][0] = new Block(x, 0, null);
		
		current = createRandomBlock();
		current.hop();
		next = createRandomBlock();
		
		board = Loader.the.getImage("board");
		
		Configuration.setScreen(this);
	}
	
	override public function render(painter: Painter): Void {
		painter.drawImage(board, 0, 0);
		for (x in 0...Block.xsize) {
			for (y in 0...Block.ysize) {
				if (Block.blocked[x][y] != null) {
					Block.blocked[x][y].draw(painter);
				}
			}
		}
		next.draw(painter);
		current.draw(painter);
	}
	
	private var left = false;
	private var right = false;
	private var lastleft = false;
	private var lastright = false;
	private var down_ = false;
	private var button = true;
	private var current: BigBlock;
	private var next: BigBlock;
	private var xcount: Int = 0;
	
	override public function update(): Void {		
		lastleft = left;
		lastright = right;

		++count;
		++xcount;
		if (right && !lastright) {
			current.right();
			xcount = 0;
		}
		if (left && !lastleft) {
			current.left();
			xcount = 0;
		}
		if (xcount % 4 == 0) {
			if (right && lastright) current.right();
			else if (left && lastleft) current.left();
		}
		if (button) {
			current.rotate();
			button = false;
		}
		if (down_) down();
		else if (count % 60 == 0) down();
	}
	
	override public function buttonDown(button: Button): Void {
		switch (button) {
		case Button.LEFT:
			left = true;
		case Button.RIGHT:
			right = true;
		case Button.DOWN:
			down_ = true;
		case Button.BUTTON_1, Button.BUTTON_2:
			this.button = true;
		default:
		}
	}
	
	override public function buttonUp(button: Button): Void {
		switch (button) {
		case Button.LEFT:
			left = false;
		case Button.RIGHT:
			right = false;
		case Button.DOWN:
			down_ = false;
		case Button.BUTTON_1, Button.BUTTON_2:
			this.button = false;
		default:
		}
	}
	
	private function createRandomBlock(): BigBlock {
		switch (Random.getUpTo(6)) {
		case 0: return new IBlock();
		case 1: return new LBlock();
		case 2: return new JBlock();
		case 3: return new TBlock();
		case 4: return new ZBlock();
		case 5: return new SBlock();
		case 6: return new OBlock();
		}
		return null;
	}
	
	private function down(): Void {
		if (!current.down()) {
			down_ = false;
			//FSOUND_PlaySound(2, bang);
			try {
				for (i in 0...4) {
					var block = current.getBlock(i);
					Block.blocked[block.getX()][block.getY()] = block;
				}
				current = next;
				next = createRandomBlock();
				check();
				//sound.play();
				current.hop();
			}
			catch (e: Exception) {
				Configuration.setScreen(new GameOver());
				return;
			}
		}
	}
	
	private function lineBlocked(y: Int): Bool {
		return Block.blocked[1][y] != null && Block.blocked[2][y] != null && Block.blocked[3][y] != null && Block.blocked[4][y] != null && Block.blocked[5][y] != null &&
			Block.blocked[6][y] != null && Block.blocked[7][y] != null && Block.blocked[8][y] != null && Block.blocked[9][y] != null && Block.blocked[10][y] != null ;
	}
	
	private function check(): Void {
		for (i in 0...4) {
			var y: Int = 1;
			while (y < Block.ysize) {
				if (lineBlocked(y)) {
					for (x in 1...Block.xsize - 1) {
						Block.blocked[x][y] = null;
					}
					y += 1;
					while (y < Block.ysize) {
						for (x in 1...Block.xsize - 1) if (Block.blocked[x][y] != null) {
							Block.blocked[x][y].down();
							Block.blocked[x][y - 1] = Block.blocked[x][y];
							Block.blocked[x][y] = null;
						}
						++y;
					}
				}
				++y;
			}
		}
	}
}
