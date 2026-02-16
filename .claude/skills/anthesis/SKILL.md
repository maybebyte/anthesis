# anthesis Development Patterns

> Auto-generated skill from repository analysis

## Overview

The anthesis repository is a JavaScript-based website project focused on content management and styling. It follows a hash-based asset management system for CSS and JavaScript files, requiring coordinated updates between templates and assets. The codebase emphasizes visual design with custom fonts, responsive styling, and markdown-based content management.

## Coding Conventions

### File Naming
- Use kebab-case for all files: `load-fonts.js`, `styles.css`
- Hash-based naming for assets: `styles.{hash}.css`, `load-fonts.{hash}.js`
- Markdown files in lowercase: `bookmarks.md`, `index.md`

### Import/Export Style
- Mixed import/export patterns are acceptable
- Prioritize consistency within individual files
- Use modern ES6+ syntax where supported

### Commit Messages
- Follow conventional commit format
- Use prefixes: `style:`, `feat:`, `fix:`, `docs:`
- Keep messages concise (average 44 characters)
- Examples: `style: adjust heading font weights`, `feat: add new bookmark section`

## Workflows

### CSS Style Updates
**Trigger:** When someone wants to modify website styling or layout
**Command:** `/update-styles`

1. Modify styles in the CSS file (`styles.{hash}.css`)
2. Generate new hash for the updated CSS file
3. Update the CSS file hash reference in `_header.html` template
4. Test visual changes across different screen sizes
5. Commit with `style:` prefix

Example CSS modification:
```css
h1, h2, h3 {
  font-weight: 600; /* Adjust heading weights */
  margin-bottom: 1.5rem;
}
```

### Content Updates
**Trigger:** When someone wants to update website content or add new sections
**Command:** `/update-content`

1. Edit relevant markdown files (`bookmarks.md`, `index.md`, etc.)
2. Update last modified dates if applicable
3. Add new resources, links, or content sections
4. Verify markdown formatting and links
5. Commit with `docs:` or `feat:` prefix

Example markdown update:
```markdown
## New Section
- [Resource Name](https://example.com) - Description of resource
- [Another Link](https://example.org) - More details
```

### Font System Changes
**Trigger:** When someone wants to add new fonts or modify typography
**Command:** `/add-font`

1. Add or modify font files in appropriate `fonts/*/` directory
2. Update font loading JavaScript (`js/load-fonts.{hash}.js`)
3. Update CSS with new font declarations and font-family rules
4. Generate new hashes for both JS and CSS files
5. Update `_header.html` with new file hashes
6. Test font loading and fallbacks

Example font loading update:
```javascript
// In load-fonts.{hash}.js
const fontFaces = [
  { family: 'NewFont', url: 'fonts/newfont/newfont.woff2' }
];
```

### Heading Typography Adjustments
**Trigger:** When someone wants to adjust the visual weight or appearance of headings
**Command:** `/adjust-headings`

1. Identify specific heading levels to modify (h1, h2, h3, etc.)
2. Adjust font-weight, line-height, or margin values in CSS
3. Update CSS file hash in `_header.html` template
4. Test heading hierarchy and visual balance
5. Commit changes with descriptive message

Example heading adjustments:
```css
h1 { font-weight: 700; }
h2 { font-weight: 600; }
h3 { font-weight: 500; }
```

### Revert Changes
**Trigger:** When someone needs to undo a previous change or commit
**Command:** `/revert`

1. Identify the specific commit hash to revert
2. Use `git revert <commit-hash>` to create revert commit
3. Update any hash references that may have changed
4. Verify that reverted changes work correctly
5. Test affected functionality

## Testing Patterns

- Tests follow the `*.test.*` pattern for file naming
- Testing framework is not explicitly configured but follows standard JavaScript testing conventions
- Focus on testing visual changes through manual verification
- Validate hash-based asset loading works correctly after updates

## Commands

| Command | Purpose |
|---------|---------|
| `/update-styles` | Modify CSS styling and update hash references |
| `/update-content` | Edit markdown content and add new sections |
| `/add-font` | Add or modify web fonts with proper integration |
| `/adjust-headings` | Fine-tune heading typography and weights |
| `/revert` | Roll back previous commits safely |