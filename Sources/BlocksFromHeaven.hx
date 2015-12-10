package;

import haxe.Timer;
import kha.Assets;
import kha.audio1.Audio;
import kha.Color;
import kha.Framebuffer;
import kha.Image;
import kha.input.Gamepad;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.Key;
import kha.math.Random;
import kha.Scaler;
import kha.Scheduler;
import kha.ScreenCanvas;
import kha.Sound;
import kha.System;

import BigBlock;

class BlocksFromHeaven {
	private var initialized: Bool = false;
	private var count: Int = 0;
	private var faster: Bool = false;
	private var backbuffer: Image;
	private var gameover: Bool = false;
	
	public function new() {
		Assets.loadEverything(loadingFinished);
	}

	private function loadingFinished(): Void {
		initialized = true;
		
		Random.init(Std.int(System.time * 1000));
		
		backbuffer = Image.createRenderTarget(272, 480);
		
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
		
		if (Gamepad.get() != null) Gamepad.get().notify(gamepadAxis, gamepadButton);
		if (Keyboard.get() != null) Keyboard.get().notify(keyDown, keyUp);
		if (Mouse.get() != null) Mouse.get().notify(mouseDown, mouseUp, mouseMove, null);
		
		Audio.play(Assets.sounds.blocks, true); // TODO: Stream
	}
	
	public function render(framebuffer: Framebuffer): Void {
		if (!initialized) return;
		
		if (gameover) {
			framebuffer.g2.begin();
			framebuffer.g2.drawScaledImage(Assets.images.score, 0, 0, framebuffer.width, framebuffer.height);
			framebuffer.g2.end();
			return;
		}
		
		var g = backbuffer.g2;
		g.begin();
		g.color = Color.White;
		g.drawImage(Assets.images.board, 0, 0);
		for (x in 0...GameBlock.xsize) {
			for (y in 0...GameBlock.ysize) {
				if (GameBlock.blocked[x][y] != null) {
					GameBlock.blocked[x][y].draw(g);
				}
			}
		}
		next.draw(g);
		current.draw(g);
		g.end();
		framebuffer.g2.begin();
		Scaler.scale(backbuffer, framebuffer, System.screenRotation);
		framebuffer.g2.end();
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
	
	private var mousedowncount: Int = 0;
	private var fingerdown: Bool = false;
	private var fingerposx: Int = 0;
	private var fingerposy: Int = 0;
	private var fingerstartx: Int = 0;
	private var fingerstarty: Int = 0;
	private var blocksize: Int = 16;
	private var lastclicktime: Float = 0;
	
	public function update(): Void {
		if (!initialized || gameover) return;
		
		lastleft = left;
		lastright = right;

		++mousedowncount;
		if (mousedowncount == 0) mousedowncount = 100;
		
		if (fingerdown) {
			var leftright = false;
			if (fingerposx - fingerstartx > 15 || fingerposx - fingerstartx < -15) leftright = true;
			while (fingerposx - fingerstartx > blocksize) {
				fingerstartx += blocksize;
				current.right();
				leftright = true;
			}
			while (fingerposx - fingerstartx < -blocksize) {
				fingerstartx -= blocksize;
				current.left();
				leftright = true;
			}
			if (leftright) {
				fingerstarty = fingerposy;
			}
			else {
				while (fingerposy - fingerstarty > blocksize) {
					fingerstarty += blocksize;
					current.down();
				}
			}
		}
		else {
			if (mousedowncount < 10) {
				var currenttime = Scheduler.time();
				if (currenttime > lastclicktime + 0.6) {
					current.rotate();
					mousedowncount = 100;
					lastclicktime = currenttime;
				}
			}
		}
		
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
	
	private function gamepadAxis(axis: Int, value: Float): Void {
		if (axis == 0) {
			if (value < -0.1) {
				left = true;
				right = false;
			}
			else if (value > 0.1) {
				right = true;
				left = false;
			}
			else {
				left = false;
				right = false;
			}
		}
		if (axis == 1) {
			if (value < -0.1) {
				down_ = true;
			}
			else {
				down_ = false;
			}
		}
	}
	
	private function gamepadButton(button: Int, value: Float): Void {
		if (value > 0.1) {
			this.button = true;
		}
		else {
			this.button = false;
		}
	}
	
	private function keyDown(key: Key, char: String): Void {
		switch (key) {
		case LEFT:
			left = true;
		case RIGHT:
			right = true;
		case DOWN:
			down_ = true;
		default:
			button = true;
		}
	}
	
	private function keyUp(key: Key, char: String): Void {
		switch (key) {
		case LEFT:
			left = false;
		case RIGHT:
			right = false;
		case DOWN:
			down_ = false;
		default:
			button = false;
		}
	}
	
	private function mouseDown(button: Int, x: Int, y: Int): Void {
		mousedowncount = 0;
		fingerstartx = Scaler.transformX(x, y, backbuffer, ScreenCanvas.the, System.screenRotation);
		fingerstarty = Scaler.transformY(x, y, backbuffer, ScreenCanvas.the, System.screenRotation);
		fingerposx = fingerstartx;
		fingerposy = fingerstarty;
		fingerdown = true;
	}
	
	private function mouseUp(button: Int, x: Int, y: Int): Void {
		fingerdown = false;
	}
	
	private function mouseMove(x: Int, y: Int, movementX: Int, movementY: Int): Void {
		fingerposx = Scaler.transformX(x, y, backbuffer, ScreenCanvas.the, System.screenRotation);
		fingerposy = Scaler.transformY(x, y, backbuffer, ScreenCanvas.the, System.screenRotation);
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
				gameover = true;
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
		if (lineDeleted) Audio.play(Assets.sounds.line);
		else Audio.play(Assets.sounds.klack);
	}
}
