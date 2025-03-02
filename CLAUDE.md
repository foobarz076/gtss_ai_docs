# GTSS AI Docs - Project Guide

## Build Commands
- `mkdocs serve` - Start local dev server with auto-reload
- `mkdocs build` - Build static site to './site' directory
- `mkdocs gh-deploy` - Build and push to GitHub Pages
- `pip install -r requirements.txt` - Install dependencies

## Markdown Style Guidelines
- Use ATX headers (`#` for H1, `##` for H2, etc.)
- Code blocks: ```bash for commands, ```text for output
- Images: Store in `_assets/[category]/` directory
- Admonitions: `!!! info "Title"` or `??? note "Collapsible"`
- Links: `[link text](relative/path.md)` for internal
- Lists: Use asterisks (*) for unordered lists

## Documentation Conventions
- Main content in Chinese with English technical terms
- Include screenshots for UI-based instructions
- Use `$` prefix for terminal commands, or `#` prefix for commands which requires root access
- Keep explanations concise and step-by-step
- Group related files in same directory
- Sections follow logical progression for newcomers

## File Organization
- Group files by topic under `docs/` directory
- Follow navigation structure defined in mkdocs.yml
- Assets go in `docs/_assets/[category]/` subdirectory
- Name files with descriptive, lowercase names using underscores