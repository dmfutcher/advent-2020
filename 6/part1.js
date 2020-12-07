const fs = require('fs');

const groups = fs.readFileSync("input")
                    .toString('utf-8')
                    .split("\n\n")
                    .map(l => l.split("\n"));

const sum = (a,b) => a + b
const counts = groups.map(g => new Set(g.reduce(sum)).size)

console.log(`Answer: ${counts.reduce(sum)}`);

module.exports = {groups, sum}
