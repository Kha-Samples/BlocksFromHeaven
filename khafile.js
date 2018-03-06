let project = new Project('Blocks');

project.addAssets('Assets/**');

project.addSources('Sources');

require('haxe-modular/bin/kha').register(platform, project, callbacks);

resolve(project);