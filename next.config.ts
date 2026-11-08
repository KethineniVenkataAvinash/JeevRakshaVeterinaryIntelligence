import type { NextConfig } from "next";
import path from "node:path";

const nextConfig: NextConfig = {
  images: { 
    unoptimized: true 
  },
  turbopack: {
    root: path.resolve(__dirname),
  },
  // Avoid concurrent static-page workers racing to create the same cache
  // directory on Windows filesystems.
  experimental: {
    cpus: 1,
    staticGenerationMaxConcurrency: 1,
    staticGenerationMinPagesPerWorker: 13,
    webpackBuildWorker: false,
  },
};

export default nextConfig;
