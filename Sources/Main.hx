package;

import kha.Assets;
import kha.Scheduler;
import kha.System;

class Main {
	public static function main() {
		System.start({title: "Blocks", width: 272, height: 480}, init);
	}
	
	private static function init(_): Void {
		var game = new BlocksFromHeaven();
		System.notifyOnFrames(game.render);
		Scheduler.addTimeTask(game.update, 0, 1 / 60);
	}
}
