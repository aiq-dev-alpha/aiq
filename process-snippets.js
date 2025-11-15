#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Track processing stats
let stats = {
  totalFiles: 0,
  processed: 0,
  improved: 0,
  errors: 0
};

// Enhanced animation sets for different component types
const animations = {
  angular: {
    fadeIn: `
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }`,
    slideIn: `
    @keyframes slideIn {
      from { transform: translateX(-20px); opacity: 0; }
      to { transform: translateX(0); opacity: 1; }
    }`,
    scaleIn: `
    @keyframes scaleIn {
      from { transform: scale(0.95); opacity: 0; }
      to { transform: scale(1); opacity: 1; }
    }`,
    ripple: `
    @keyframes ripple {
      0% { transform: scale(0); opacity: 1; }
      100% { transform: scale(4); opacity: 0; }
    }`,
    pulse: `
    @keyframes pulse {
      0%, 100% { transform: scale(1); }
      50% { transform: scale(1.05); }
    }`,
    shimmer: `
    @keyframes shimmer {
      0% { background-position: -1000px 0; }
      100% { background-position: 1000px 0; }
    }`,
    bounce: `
    @keyframes bounce {
      0%, 100% { transform: translateY(0); }
      50% { transform: translateY(-10px); }
    }`,
    rotate: `
    @keyframes rotate {
      from { transform: rotate(0deg); }
      to { transform: rotate(360deg); }
    }`
  },
  vue: {
    enter: `
@keyframes enter {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}`,
    slideDown: `
@keyframes slideDown {
  from { transform: translateY(-10px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}`,
    glow: `
@keyframes glow {
  0%, 100% { box-shadow: 0 0 5px currentColor; }
  50% { box-shadow: 0 0 20px currentColor; }
}`
  },
  svelte: {
    fade: `
@keyframes fade {
  from { opacity: 0; }
  to { opacity: 1; }
}`,
    expand: `
@keyframes expand {
  from { transform: scale(0.9); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
}`
  }
};

// Find all snippet files
function findSnippetFiles(dir) {
  const files = [];
  const items = fs.readdirSync(dir, { withFileTypes: true });

  for (const item of items) {
    const fullPath = path.join(dir, item.name);
    if (item.isDirectory()) {
      files.push(...findSnippetFiles(fullPath));
    } else if (item.isFile() && /\.(ts|tsx|js|jsx|vue|svelte)$/.test(item.name)) {
      files.push(fullPath);
    }
  }

  return files;
}

// Enhance Angular component
function enhanceAngularComponent(content) {
  let enhanced = content;

  // Add sophisticated transitions if not present
  if (!content.includes('cubic-bezier')) {
    enhanced = enhanced.replace(
      /transition:\s*all\s+[\d.]+s[^;]*/g,
      'transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1)'
    );
  }

  // Enhance hover effects
  if (!content.includes(':hover') && content.includes('.btn') || content.includes('.card')) {
    const componentType = content.includes('.btn') ? 'button' : 'card';
    const hoverEffect = componentType === 'button'
      ? `    .btn:hover:not(:disabled) {
      transform: translateY(-2px);
      box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
      filter: brightness(1.05);
    }`
      : `    .card:hover {
      transform: translateY(-4px);
      box-shadow: 0 12px 24px rgba(0, 0, 0, 0.12);
    }`;

    enhanced = enhanced.replace(/(styles:\s*\[`[^`]*)`\]/s, (match, styles) => {
      return match.replace('`]', hoverEffect + '\n  `]');
    });
  }

  // Add animations to styles section
  if (!content.includes('@keyframes')) {
    enhanced = enhanced.replace(/(styles:\s*\[`[^`]*)`\]/s, (match, styles) => {
      const animSet = Object.values(animations.angular).slice(0, 3).join('\n    ');
      return match.replace('`]', '\n    ' + animSet + '\n  `]');
    });
  }

  // Enhance box-shadow for depth
  enhanced = enhanced.replace(
    /box-shadow:\s*0\s+\d+px\s+\d+px\s+rgba\(0,\s*0,\s*0,\s*0\.\d+\)/g,
    (match) => {
      if (!match.includes(',')) return match;
      return 'box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07), 0 10px 20px rgba(0, 0, 0, 0.05)';
    }
  );

  // Add backdrop-filter for modern glass effect
  if (content.includes('backgroundColor') && !content.includes('backdrop-filter')) {
    enhanced = enhanced.replace(
      /backgroundColor:\s*'[^']*'/g,
      (match) => match + ",\n        backdropFilter: 'blur(10px)'"
    );
  }

  return enhanced;
}

// Enhance Vue component
function enhanceVueComponent(content) {
  let enhanced = content;

  // Add modern transitions
  if (!content.includes('transition:')) {
    enhanced = enhanced.replace(
      /<style[^>]*scoped[^>]*>/,
      (match) => match + `\n* {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}\n`
    );
  }

  // Add hover effects
  if (!content.includes(':hover') && content.includes('button')) {
    enhanced = enhanced.replace(
      /<\/style>/,
      `button:hover:not(:disabled) {
  transform: translateY(-2px) scale(1.02);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
}
button:active:not(:disabled) {
  transform: translateY(0) scale(0.98);
}
</style>`
    );
  }

  // Add animations
  if (!content.includes('@keyframes')) {
    const animSet = Object.values(animations.vue).join('\n');
    enhanced = enhanced.replace('</style>', `\n${animSet}\n</style>`);
  }

  return enhanced;
}

// Enhance Svelte component
function enhanceSvelteComponent(content) {
  let enhanced = content;

  // Add transitions
  if (!content.includes('transition:') && content.includes('<style>')) {
    enhanced = enhanced.replace(
      /<style>/,
      `<style>\n  * {\n    transition: all 0.25s ease-out;\n  }\n`
    );
  }

  // Add animations
  if (!content.includes('@keyframes')) {
    const animSet = Object.values(animations.svelte).join('\n');
    enhanced = enhanced.replace('</style>', `\n${animSet}\n</style>`);
  }

  return enhanced;
}

// Process a single file
function processFile(filePath) {
  try {
    stats.totalFiles++;

    const content = fs.readFileSync(filePath, 'utf8');
    let enhanced;

    // Determine file type and enhance accordingly
    if (filePath.endsWith('.ts') || filePath.endsWith('.tsx')) {
      if (content.includes('@Component')) {
        enhanced = enhanceAngularComponent(content);
      } else {
        enhanced = content; // React/other TS files
      }
    } else if (filePath.endsWith('.vue')) {
      enhanced = enhanceVueComponent(content);
    } else if (filePath.endsWith('.svelte')) {
      enhanced = enhanceSvelteComponent(content);
    } else {
      enhanced = content;
    }

    // Only write if content changed
    if (enhanced !== content) {
      fs.writeFileSync(filePath, enhanced, 'utf8');
      stats.improved++;
    }

    stats.processed++;

    // Progress indicator
    if (stats.processed % 100 === 0) {
      console.log(`Processed: ${stats.processed}/${stats.totalFiles} files...`);
    }

  } catch (error) {
    stats.errors++;
    console.error(`Error processing ${filePath}:`, error.message);
  }
}

// Main execution
function main() {
  const snippetsDir = path.join(__dirname, 'snippets');

  if (!fs.existsSync(snippetsDir)) {
    console.error('Snippets directory not found!');
    process.exit(1);
  }

  console.log('Finding all snippet files...');
  const files = findSnippetFiles(snippetsDir);
  stats.totalFiles = files.length;

  console.log(`Found ${files.length} files to process`);
  console.log('Starting enhancement process...\n');

  // Process all files
  for (const file of files) {
    processFile(file);
  }

  // Print summary
  console.log('\n' + '='.repeat(60));
  console.log('ITERATION 1/10 - COMPLETE');
  console.log('='.repeat(60));
  console.log(`Total files found:    ${stats.totalFiles}`);
  console.log(`Files processed:      ${stats.processed}`);
  console.log(`Files improved:       ${stats.improved}`);
  console.log(`Errors encountered:   ${stats.errors}`);
  console.log('='.repeat(60));
}

main();
