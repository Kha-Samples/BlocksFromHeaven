package;

import haxe.Timer;
import kha.Button;
import kha.Configuration;
import kha.Game;
import kha.Image;
import kha.Loader;
import kha.LoadingScreen;
import kha.Painter;
import kha.math.Random;
import kha.Sound;

import BigBlock;

class BlocksFromHeaven extends Game {
	private var board: Image;
	private var count: Int = 0;
	private var faster: Bool = false;
	private var klackSound: Sound;
	private var lineSound: Sound;
	
	public function new() {
		super("BlocksFromHeaven", false);
	}
	
	override public function init(): Void {
		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom("blocks", loadingFinished);
	}
	
	private function loadingFinished(): Void {
		Random.init(Std.int(Timer.stamp() * 1000));
		
		for (x in 0...GameBlock.xsize) for (y in 0...GameBlock.ysize) {
			GameBlock.blocked.push(new Array<GameBlock>());
			GameBlock.blocked[x].push(null);
		}
		
		for (y in 0...GameBlock.ysize) GameBlock.blocked[0][y] = new GameBlock(0, y, null);
		for (y in 0...GameBlock.ysize) GameBlock.blocked[GameBlock.xsize - 1][y] = new GameBlock(GameBlock.xsize - 1, y, null);
		for (x in 0...GameBlock.xsize) GameBlock.blocked[x][0] = new GameBlock(x, 0, null);
		
		current = createRandomBlock();
		current.hop();
		next = createRandomBlock();
		
		board = Loader.the.getImage("board");
		klackSound = Loader.the.getSound("klack");
		lineSound = Loader.the.getSound("line");
		
		Configuration.setScreen(this);
		Loader.the.getMusic("blocks").play();
	}
	
	override public function render(painter: Painter): Void {
		painter.drawImage(board, 0, 0);
		for (x in 0...GameBlock.xsize) {
			for (y in 0...GameBlock.ysize) {
				if (GameBlock.blocked[x][y] != null) {
					GameBlock.blocked[x][y].draw(painter);
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
			try {
				for (i in 0...4) {
					var block = current.getBlock(i);
					GameBlock.blocked[block.getX()][block.getY()] = block;
				}
				current = next;
				next = createRandomBlock();
				check();
				current.hop();
			}
			catch (e: Exception) {
				Configuration.setScreen(new GameOver());
				return;
			}
		}
	}
	
	private function lineBlocked(y: Int): Bool {
		return GameBlock.blocked[1][y] != null && GameBlock.blocked[2][y] != null && GameBlock.blocked[3][y] != null && GameBlock.blocked[4][y] != null && GameBlock.blocked[5][y] != null &&
			GameBlock.blocked[6][y] != null && GameBlock.blocked[7][y] != null && GameBlock.blocked[8][y] != null && GameBlock.blocked[9][y] != null && GameBlock.blocked[10][y] != null ;
	}
	
	private function check(): Void {
		var lineDeleted = false;
		for (i in 0...4) {
			var y: Int = 1;
			while (y < GameBlock.ysize) {
				if (lineBlocked(y)) {
					lineDeleted = true;
					for (x in 1...GameBlock.xsize - 1) {
						GameBlock.blocked[x][y] = null;
					}
					y += 1;
					while (y < GameBlock.ysize) {
						for (x in 1...GameBlock.xsize - 1) if (GameBlock.blocked[x][y] != null) {
							GameBlock.blocked[x][y].down();
							GameBlock.blocked[x][y - 1] = GameBlock.blocked[x][y];
							GameBlock.blocked[x][y] = null;
						}
						++y;
					}
				}
				++y;
			}
		}
		if (lineDeleted) lineSound.play();
		else klackSound.play();
	}
}
