var version = Number(process.version.match(/^v(\d+\.\d+)/)[1]);

if (version < 0.12) {
	console.log('Sorry, this requires at least node version 0.12.')
	process.exit(1);
}

require('child_process').execFileSync('git', ['clone', '--recursive', 'https://github.com/ktxsoftware/Kha.git']);
