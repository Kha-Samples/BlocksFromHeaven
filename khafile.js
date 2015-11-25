var project = new Project('Blocks');

project.addLibrary('Kha2D');

project.addAssets('Assets/**');

project.addSources('Sources');

project.addShaders('Sources/Shaders');

return project;
