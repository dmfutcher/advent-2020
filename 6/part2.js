const {groups, sum} = require('./part1');

const intersection = (a, b) => a.filter(c => b.includes(c));
const counts = groups.map(g => g.map(p => [...new Set(p)]).reduce(intersection).length);

console.log(`Answer: ${counts.reduce(sum)}`);
