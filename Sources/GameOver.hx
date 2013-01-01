package;

import kha.Game;
import kha.Image;
import kha.Loader;
import kha.Painter;

class GameOver extends Game {
	private var image: Image;
	
	public function new() {
		super("Game Over", false);
		image = Loader.the.getImage("score");
	}
	
	override public function update(): Void {
		
	}
	
	override public function render(painter: Painter): Void {
		painter.drawImage(image, 0, 0);
	}
}