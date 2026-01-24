
# [/src](cci:9://file:///home/locch/Works/blogs/src:0:0-0:0) Directory Structure Explained

## **[assets/](cci:9://file:///home/locch/Works/blogs/src/assets:0:0-0:0)**
- **Purpose**: Static assets that need processing (images, fonts, etc.)
- **Usage**: Place images here that need optimization/processing by Astro
- **Example**: Blog placeholder images, hero images

## **[components/](cci:9://file:///home/locch/Works/blogs/src/components:0:0-0:0)**
- **Purpose**: Reusable UI components
- **Usage**: Astro components used across multiple pages
- **Files**: [Header.astro](cci:7://file:///home/locch/Works/blogs/src/components/Header.astro:0:0-0:0), [Footer.astro](cci:7://file:///home/locch/Works/blogs/src/components/Footer.astro:0:0-0:0), [BaseHead.astro](cci:7://file:///home/locch/Works/blogs/src/components/BaseHead.astro:0:0-0:0), [FormattedDate.astro](cci:7://file:///home/locch/Works/blogs/src/components/FormattedDate.astro:0:0-0:0), [HeaderLink.astro](cci:7://file:///home/locch/Works/blogs/src/components/HeaderLink.astro:0:0-0:0)
- **Import**: `import Header from '../components/Header.astro'`

## **[consts.ts](cci:7://file:///home/locch/Works/blogs/src/consts.ts:0:0-0:0)**
- **Purpose**: Global constants and configuration
- **Usage**: Site-wide data like title, description
- **Import**: `import { SITE_TITLE, SITE_DESCRIPTION } from '../consts'`

## **[content/](cci:9://file:///home/locch/Works/blogs/src/content:0:0-0:0)**
- **Purpose**: Blog posts and content collections
- **Usage**: Markdown/MDX files with frontmatter schema validation
- **Structure**: [content/blog/](cci:9://file:///home/locch/Works/blogs/src/content/blog:0:0-0:0) contains all blog posts
- **Access**: `getCollection('blog')` to retrieve posts

## **[content.config.ts](cci:7://file:///home/locch/Works/blogs/src/content.config.ts:0:0-0:0)**
- **Purpose**: Content collection schema definitions
- **Usage**: Type-safe frontmatter validation for blog posts
- **Defines**: Required fields like `title`, `description`, `pubDate`, etc.

## **[layouts/](cci:9://file:///home/locch/Works/blogs/src/layouts:0:0-0:0)**
- **Purpose**: Page layout templates
- **Usage**: Shared HTML structure for specific page types
- **Files**: [BlogPost.astro](cci:7://file:///home/locch/Works/blogs/src/layouts/BlogPost.astro:0:0-0:0) - layout for individual blog posts

## **[pages/](cci:9://file:///home/locch/Works/blogs/src/pages:0:0-0:0)**
- **Purpose**: File-based routing (Astro's core feature)
- **Usage**: Each `.astro` or `.md` file becomes a route
- **Structure**:
  - [index.astro](cci:7://file:///home/locch/Works/blogs/src/pages/index.astro:0:0-0:0) → `/` (homepage)
  - [about.astro](cci:7://file:///home/locch/Works/blogs/src/pages/about.astro:0:0-0:0) → `/about`
  - [blog/index.astro](cci:7://file:///home/locch/Works/blogs/src/pages/blog/index.astro:0:0-0:0) → [/blog](cci:9://file:///home/locch/Works/blogs/src/pages/blog:0:0-0:0)
  - `blog/[...slug].astro` → `/blog/[post-name]`

## **[styles/](cci:9://file:///home/locch/Works/blogs/src/styles:0:0-0:0)**
- **Purpose**: Global CSS and styling
- **Usage**: Site-wide styles, CSS variables, fonts
- **Files**: [global.css](cci:7://file:///home/locch/Works/blogs/src/styles/global.css:0:0-0:0) - Bear Blog-inspired styling

## **How They Work Together**
1. **Pages** use **Components** and **Layouts**
2. **Content** is structured via **content.config.ts**
3. **Constants** provide site-wide data
4. **Styles** are imported globally via components
5. **Assets** are processed and optimized by Astro

This structure follows Astro's conventions and enables automatic routing, content management, and component reusability.