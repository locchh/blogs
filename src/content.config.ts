import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const blog = defineCollection({
	// Load Markdown and MDX files in the `src/content/blog/` directory.
	loader: glob({ base: './src/content/blog', pattern: '**/*.{md,mdx}' }),
	// Type-check frontmatter using a schema
	schema: ({ image }) =>
		z.object({
			title: z.string(),
			description: z.string(),
			// Transform string to Date object
			pubDate: z.coerce.date(),
			updatedDate: z.coerce.date().optional(),
			heroImage: image().optional(),
			// Drafts are committed but never built/listed (see pages + rss).
			draft: z.boolean().default(false),
			// A post heavy with wide tables and long cells: smaller type on a wider page (see `.dense` in global.css).
			dense: z.boolean().default(false),
		}),
});

export const collections = { blog };
