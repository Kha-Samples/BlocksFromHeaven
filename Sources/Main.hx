package;

import kha.Assets;
import kha.Scheduler;
import kha.System;

class Main {
	public static function main() {
		System.init("Blocks", 272, 480, init);
	}
	
	private static function init(): Void {
		var game = new BlocksFromHeaven();
		System.notifyOnRender(game.render);
		Scheduler.addTimeTask(game.update, 0, 1 / 60);
	}
}
