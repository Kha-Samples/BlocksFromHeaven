let project = new Project('Blocks');

project.addAssets('Assets/*');
project.addAssets('Assets/Music/*', { quality: 0.5 });
project.addSources('Sources');

resolve(project);
