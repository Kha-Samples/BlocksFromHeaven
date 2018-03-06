package;

import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.input.Mouse;

class Main {
	static var title: Title;
	static var game: BlocksFromHeaven;
	static var isGame: Bool;

	public static function main() {
		System.init({title: "Blocks", width: 272, height: 480}, init);
	}
	
	private static function init(): Void {
		title = new Title();
		title.showing(onStart);
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
	}

	private static function onStart() {
		Bundle.load(BlocksFromHeaven).then(function(_) {
			game = new BlocksFromHeaven();
			isGame = true;
		});
	}

	private static function render(framebuffer: Framebuffer) {
		if (!isGame) title.render(framebuffer);
		else game.render(framebuffer);
	}

	private static function update() {
		if (!isGame) title.update();
		else game.update();
	}
}

class Title {
	var callback: Void->Void;
	var initialized: Bool;
	var bg: kha.Image;

	public function new() {
		Assets.loadImage('title', function(image) {
			initialized = true;
			bg = image;
		});
	}

	public function showing(onStart: Void->Void) {
		if (Mouse.get() != null) Mouse.get().notify(mouseDown, null, null, null);
		callback = onStart;
	}

	private function mouseDown(button: Int, x: Int, y: Int): Void {
		if (callback != null) {
			Mouse.get().remove(mouseDown, null, null, null);
			callback();
		}
		callback = null;
	}

	public function render(framebuffer: Framebuffer) {
		if (initialized) {
			framebuffer.g2.begin();
			framebuffer.g2.drawScaledImage(bg, 0, 0, framebuffer.width, framebuffer.height);
			framebuffer.g2.end();
		}
	}

	public function update() {

	}
}