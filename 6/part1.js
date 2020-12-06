const fs = require('fs');

const groups = fs.readFileSync("input")
                    .toString('utf-8')
                    .split("\n\n")
                    .map((l) => l.split("\n"));

const flatten = xs => [].concat(...xs);
const counts = groups.map((g) => new Set(flatten(g.map(flatten))).size);

console.log(`Answer: ${counts.reduce((a,b) => a + b)}`);

module.exports = {groups}
