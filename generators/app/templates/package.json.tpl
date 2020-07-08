{
  "name": "<%= filename %>",
  "files": [
    "src/"
  ],
  "types": "src/octant.d.ts",
  "version": "0.1.0",
  "description": "<%= description %>",
  "scripts": {
    "plugin:watch": "webpack --watch --output <%= pluginPath %>/<%= filename %>.js",
    "plugin:dev": "webpack --output dist/<%= filename %>.js",
    "plugin:prod": "webpack --env=production --output dist/<%= filename %>.js",
    "plugin:install": "webpack --env=production --output <%= pluginPath %>/<%= filename %>.js"
  },
  "keywords": ["octant", "octant-plugin"],
  "author": "",
  "license": "Apache-2.0",
  "devDependencies": {
    "@babel/cli": "^7.8.3",
    "@babel/core": "^7.8.3",
    "@babel/plugin-proposal-class-properties": "^7.8.3",
    "@babel/plugin-transform-modules-commonjs": "^7.10.1",
    "@babel/plugin-transform-object-set-prototype-of-to-assign": "^7.10.4",
    "@babel/plugin-transform-runtime": "^7.10.3",
    "@babel/preset-env": "^7.8.3",
    "@babel/preset-typescript": "^7.8.3",
    "@babel/types": "^7.10.3",
    "@types/core-js": "^2.5.3",
    "@types/node": "^14.0.14",
    "babel-loader": "^8.1.0",
    "core-js": "^3.6.5",
    "es-check": "^5.1.0",
    "ts-loader": "^7.0.5",
    "typescript": "^3.9.5",
    "webpack": "^4.43.0",
    "webpack-cli": "^3.3.12"
  },
  "dependencies": {}
}
