// Mermaid colors for the blog's three display modes: light, dark, and reading.
// Each set matches the background of its mode and keeps text contrast high.
// Posts style the six-sided "where the check happens" box with `classDef check`.
// Mermaid writes classDef styles inline, so CSS can't override them; instead,
// withThemedChecks() swaps that line for the current mode before rendering.

const font = 'ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, sans-serif';

const palettes = {
	light: {
		background: '#ffffff',
		node: '#f3f5f8',
		nodeBorder: '#9aa4b2',
		text: '#1f2328',
		line: '#5b6472',
		cluster: '#f8f9fb',
		clusterBorder: '#c9d0d9',
		note: '#fff8e1',
		noteBorder: '#e0c068',
		activation: '#e6ebf2',
		check: { fill: '#fff4d6', stroke: '#d9480f', text: '#1f2328' },
		shadow: 'drop-shadow(1px 2px 2px rgba(0, 0, 0, 0.08))',
	},
	dark: {
		background: '#191d24',
		node: '#232934',
		nodeBorder: '#5c6675',
		text: '#e8e4dc',
		line: '#a3abb7',
		cluster: '#1d222b',
		clusterBorder: '#3e444f',
		note: '#2e2a1f',
		noteBorder: '#8a7440',
		activation: '#2b3240',
		check: { fill: '#3b2a14', stroke: '#f0a33a', text: '#fbe6c4' },
		shadow: 'drop-shadow(1px 2px 2px rgba(0, 0, 0, 0.45))',
	},
	reading: {
		background: '#f8edcf',
		node: '#fdf6e3',
		nodeBorder: '#b89c74',
		text: '#392c1e',
		line: '#7a634a',
		cluster: '#f3e6c8',
		clusterBorder: '#d7c7a3',
		note: '#fdf0d0',
		noteBorder: '#c9a86a',
		activation: '#efe0bf',
		check: { fill: '#f6dcb0', stroke: '#a0522d', text: '#352515' },
		shadow: 'drop-shadow(1px 2px 2px rgba(87, 60, 25, 0.12))',
	},
};

export function mermaidConfig(mode) {
	const p = palettes[mode] ?? palettes.light;
	return {
		startOnLoad: false,
		theme: 'base',
		themeVariables: {
			fontFamily: font,
			background: p.background,
			primaryColor: p.node,
			primaryBorderColor: p.nodeBorder,
			primaryTextColor: p.text,
			secondaryColor: p.cluster,
			secondaryBorderColor: p.clusterBorder,
			secondaryTextColor: p.text,
			tertiaryColor: p.cluster,
			tertiaryBorderColor: p.clusterBorder,
			tertiaryTextColor: p.text,
			mainBkg: p.node,
			nodeBorder: p.nodeBorder,
			nodeTextColor: p.text,
			textColor: p.text,
			titleColor: p.text,
			lineColor: p.line,
			clusterBkg: p.cluster,
			clusterBorder: p.clusterBorder,
			edgeLabelBackground: p.background,
			noteBkgColor: p.note,
			noteBorderColor: p.noteBorder,
			noteTextColor: p.text,
			actorBkg: p.node,
			actorBorder: p.nodeBorder,
			actorTextColor: p.text,
			actorLineColor: p.nodeBorder,
			signalColor: p.line,
			signalTextColor: p.text,
			labelBoxBkgColor: p.node,
			labelBoxBorderColor: p.nodeBorder,
			labelTextColor: p.text,
			loopTextColor: p.text,
			activationBkgColor: p.activation,
			activationBorderColor: p.nodeBorder,
			sequenceNumberColor: p.background,
			stateLabelColor: p.text,
			transitionColor: p.line,
			transitionLabelColor: p.text,
			dropShadow: p.shadow,
		},
	};
}

export function withThemedChecks(source, mode) {
	const c = (palettes[mode] ?? palettes.light).check;
	const line = `classDef check fill:${c.fill},stroke:${c.stroke},stroke-width:2px,color:${c.text}`;
	return source.replace(/^([ \t]*)classDef check\b.*$/gm, (_, indent) => indent + line);
}
