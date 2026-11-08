const fs = require('node:fs');
const path = require('node:path');

const nextDirectory = path.resolve(__dirname, '..', '.next');

try {
  fs.rmSync(nextDirectory, {
    recursive: true,
    force: true,
    maxRetries: 5,
    retryDelay: 100,
  });
} catch (error) {
  console.error(`Unable to clear the generated Next.js cache at ${nextDirectory}.`);
  console.error(error instanceof Error ? error.message : error);
  process.exitCode = 1;
}
