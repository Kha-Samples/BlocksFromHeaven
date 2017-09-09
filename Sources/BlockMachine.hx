package;

import kha.math.Random;
import kha.Worker;

class BlockMachine {
	public static function main(): Void {
		Random.init(0);
		Worker.notifyWorker(function (message) {
			Worker.postFromWorker({block: Random.getUpTo(6)});
		});
	}
}
