/**
 * /btw - Side-channel queries while the agent is busy
 *
 * Ctrl+B       → Open btw input overlay (works while agent is streaming)
 * Ctrl+Shift+B → Review past btw messages
 * /btw <query> → Ask a side question (when agent is idle)
 */

import { complete, type UserMessage } from "@mariozechner/pi-ai";
import type { ExtensionAPI, Theme } from "@mariozechner/pi-coding-agent";
import { DynamicBorder } from "@mariozechner/pi-coding-agent";
import {
	Container,
	CURSOR_MARKER,
	type Focusable,
	Markdown,
	matchesKey,
	Text,
	truncateToWidth,
	visibleWidth,
} from "@mariozechner/pi-tui";

interface BtwMessage {
	question: string;
	answer: string;
	timestamp: number;
	model: string;
}

const SYSTEM_PROMPT = `You are a side-channel assistant. The user is asking you a quick question while their main coding agent is busy working on a task. You have access to the conversation context so far.

Rules:
- Be concise and direct
- Answer the specific question asked
- If the question is about a decision the agent made, explain the reasoning based on the conversation context
- Don't suggest actions — the main agent is handling that
- Keep responses short (a few sentences to a short paragraph)`;

function buildContextFromBranch(entries: any[]): string {
	const sections: string[] = [];
	for (const entry of entries) {
		if (entry.type !== "message" || !entry.message?.role) continue;
		const role = entry.message.role;
		if (role !== "user" && role !== "assistant") continue;

		const content = entry.message.content;
		const textParts: string[] = [];
		if (typeof content === "string") {
			textParts.push(content);
		} else if (Array.isArray(content)) {
			for (const part of content) {
				if (part?.type === "text" && typeof part.text === "string") {
					textParts.push(part.text);
				} else if (part?.type === "toolCall" && typeof part.name === "string") {
					textParts.push(`[Tool call: ${part.name}(${JSON.stringify(part.arguments ?? {})})]`);
				}
			}
		}

		if (textParts.length > 0) {
			const label = role === "user" ? "User" : "Assistant";
			sections.push(`${label}: ${textParts.join("\n").trim()}`);
		}
	}
	// Keep last ~50k chars to avoid blowing context
	const full = sections.join("\n\n");
	return full.length > 50000 ? full.slice(-50000) : full;
}

class BtwInputOverlay implements Focusable {
	focused = false;
	private text = "";
	private cursor = 0;
	private cachedLines?: string[];

	constructor(
		private theme: Theme,
		private done: (result: string | null) => void,
	) {}

	handleInput(data: string): void {
		if (matchesKey(data, "escape")) {
			this.done(null);
			return;
		}
		if (matchesKey(data, "return") || matchesKey(data, "enter")) {
			if (this.text.trim()) {
				this.done(this.text.trim());
			}
			return;
		}
		if (matchesKey(data, "backspace")) {
			if (this.cursor > 0) {
				this.text = this.text.slice(0, this.cursor - 1) + this.text.slice(this.cursor);
				this.cursor--;
			}
		} else if (matchesKey(data, "left")) {
			this.cursor = Math.max(0, this.cursor - 1);
		} else if (matchesKey(data, "right")) {
			this.cursor = Math.min(this.text.length, this.cursor + 1);
		} else if (matchesKey(data, "ctrl+a") || matchesKey(data, "home")) {
			this.cursor = 0;
		} else if (matchesKey(data, "ctrl+e") || matchesKey(data, "end")) {
			this.cursor = this.text.length;
		} else if (matchesKey(data, "ctrl+w") || matchesKey(data, "alt+backspace")) {
			// Delete word backward
			let i = this.cursor - 1;
			while (i >= 0 && this.text[i] === " ") i--;
			while (i >= 0 && this.text[i] !== " ") i--;
			this.text = this.text.slice(0, i + 1) + this.text.slice(this.cursor);
			this.cursor = i + 1;
		} else if (matchesKey(data, "ctrl+u")) {
			this.text = this.text.slice(this.cursor);
			this.cursor = 0;
		} else if (matchesKey(data, "ctrl+k")) {
			this.text = this.text.slice(0, this.cursor);
		} else if (data.length === 1 && data.charCodeAt(0) >= 32) {
			this.text = this.text.slice(0, this.cursor) + data + this.text.slice(this.cursor);
			this.cursor++;
		}
		this.cachedLines = undefined;
	}

	render(width: number): string[] {
		if (this.cachedLines) return this.cachedLines;

		const th = this.theme;
		const innerW = Math.min(width - 2, 80);
		const lines: string[] = [];

		const pad = (s: string, len: number) => {
			const vis = visibleWidth(s);
			return s + " ".repeat(Math.max(0, len - vis));
		};
		const row = (content: string) => th.fg("border", "│") + pad(` ${content}`, innerW) + th.fg("border", "│");

		lines.push(th.fg("accent", `╭${"─".repeat(innerW)}╮`));
		lines.push(
			th.fg("border", "│") +
				pad(` ${th.fg("accent", th.bold("btw"))} ${th.fg("muted", "— side question")}`, innerW) +
				th.fg("border", "│"),
		);
		lines.push(th.fg("border", `├${"─".repeat(innerW)}┤`));

		// Input line with cursor
		let inputDisplay = this.text || "";
		const before = inputDisplay.slice(0, this.cursor);
		const cursorChar = this.cursor < inputDisplay.length ? inputDisplay[this.cursor]! : " ";
		const after = inputDisplay.slice(this.cursor + 1);
		const marker = this.focused ? CURSOR_MARKER : "";
		const inputLine = `${th.fg("muted", "❯")} ${before}${marker}\x1b[7m${cursorChar}\x1b[27m${after}`;
		lines.push(
			th.fg("border", "│") + pad(` ${inputLine}`, innerW) + th.fg("border", "│"),
		);

		lines.push(th.fg("border", `├${"─".repeat(innerW)}┤`));
		lines.push(row(th.fg("dim", "Enter send · Esc cancel")));
		lines.push(th.fg("accent", `╰${"─".repeat(innerW)}╯`));

		this.cachedLines = lines;
		return lines;
	}

	invalidate(): void {
		this.cachedLines = undefined;
	}
}

class BtwHistoryOverlay {
	private selected = 0;
	private scrollOffset = 0;
	private cachedLines?: string[];

	constructor(
		private messages: BtwMessage[],
		private theme: Theme,
		private done: (result: undefined) => void,
	) {
		if (messages.length > 0) {
			this.selected = messages.length - 1;
		}
	}

	handleInput(data: string): void {
		if (matchesKey(data, "escape") || matchesKey(data, "q")) {
			this.done(undefined);
			return;
		}
		if (matchesKey(data, "up") || matchesKey(data, "k")) {
			if (this.selected > 0) {
				this.selected--;
				this.cachedLines = undefined;
			}
			return;
		}
		if (matchesKey(data, "down") || matchesKey(data, "j")) {
			if (this.selected < this.messages.length - 1) {
				this.selected++;
				this.cachedLines = undefined;
			}
			return;
		}
	}

	render(width: number): string[] {
		if (this.cachedLines) return this.cachedLines;

		const th = this.theme;
		const innerW = Math.min(width - 2, 100);
		const lines: string[] = [];
		const msgs = this.messages;

		const pad = (s: string, len: number) => {
			const vis = visibleWidth(s);
			return s + " ".repeat(Math.max(0, len - vis));
		};
		const row = (content: string) =>
			th.fg("border", "│") + pad(` ${content}`, innerW) + th.fg("border", "│");

		lines.push(th.fg("accent", `╭${"─".repeat(innerW)}╮`));
		lines.push(
			th.fg("border", "│") +
				pad(
					` ${th.fg("accent", th.bold("btw history"))} ${th.fg("muted", `(${msgs.length} message${msgs.length !== 1 ? "s" : ""})`)}`,
					innerW,
				) +
				th.fg("border", "│"),
		);
		lines.push(th.fg("border", `├${"─".repeat(innerW)}┤`));

		if (msgs.length === 0) {
			lines.push(row(th.fg("dim", "No btw messages yet.")));
		} else {
			const msg = msgs[this.selected]!;
			const time = new Date(msg.timestamp).toLocaleTimeString();

			// Message list (compact)
			const maxVisible = 6;
			let start = Math.max(0, this.selected - Math.floor(maxVisible / 2));
			const end = Math.min(msgs.length, start + maxVisible);
			start = Math.max(0, end - maxVisible);

			for (let i = start; i < end; i++) {
				const m = msgs[i]!;
				const t = new Date(m.timestamp).toLocaleTimeString();
				const prefix = i === this.selected ? th.fg("accent", "▶ ") : "  ";
				const q = truncateToWidth(m.question, innerW - 15);
				const label = i === this.selected ? th.fg("accent", q) : th.fg("text", q);
				lines.push(row(`${prefix}${th.fg("dim", t)} ${label}`));
			}

			if (msgs.length > maxVisible) {
				lines.push(row(th.fg("dim", `  ${start > 0 ? "↑ " : "  "}${this.selected + 1}/${msgs.length}${end < msgs.length ? " ↓" : ""}`)));
			}

			// Selected message detail
			lines.push(th.fg("border", `├${"─".repeat(innerW)}┤`));
			lines.push(row(th.fg("accent", th.bold("Q: ")) + th.fg("text", msg.question)));
			lines.push(row(""));

			// Wrap answer text
			const answerLines = msg.answer.split("\n");
			for (const line of answerLines) {
				if (visibleWidth(line) <= innerW - 3) {
					lines.push(row(line));
				} else {
					// Simple word wrap
					let remaining = line;
					while (remaining.length > 0) {
						const chunk = truncateToWidth(remaining, innerW - 3, "");
						lines.push(row(chunk));
						remaining = remaining.slice(chunk.length);
					}
				}
			}

			lines.push(row(""));
			lines.push(row(th.fg("dim", `model: ${msg.model}`)));
		}

		lines.push(th.fg("border", `├${"─".repeat(innerW)}┤`));
		lines.push(row(th.fg("dim", "↑↓ navigate · Esc/q close")));
		lines.push(th.fg("accent", `╰${"─".repeat(innerW)}╯`));

		this.cachedLines = lines;
		return lines;
	}

	invalidate(): void {
		this.cachedLines = undefined;
	}
}

export default function (pi: ExtensionAPI) {
	const history: BtwMessage[] = [];

	async function askBtw(question: string, ctx: any): Promise<void> {
		if (!ctx.model) {
			ctx.ui.notify("No model selected", "error");
			return;
		}

		const branch = ctx.sessionManager.getBranch();
		const conversationContext = buildContextFromBranch(branch);

		const userPrompt = conversationContext
			? `<conversation_context>\n${conversationContext}\n</conversation_context>\n\nMy question: ${question}`
			: question;

		const userMessage: UserMessage = {
			role: "user",
			content: [{ type: "text", text: userPrompt }],
			timestamp: Date.now(),
		};

		ctx.ui.notify(`btw: asking "${truncateToWidth(question, 40)}"...`, "info");

		try {
			const apiKey = await ctx.modelRegistry.getApiKey(ctx.model);
			const response = await complete(
				ctx.model,
				{ systemPrompt: SYSTEM_PROMPT, messages: [userMessage] },
				{ apiKey },
			);

			const answer = response.content
				.filter((c: any): c is { type: "text"; text: string } => c.type === "text")
				.map((c: any) => c.text)
				.join("\n");

			const msg: BtwMessage = {
				question,
				answer,
				timestamp: Date.now(),
				model: ctx.model.id,
			};
			history.push(msg);

			// Show answer as overlay
			if (ctx.hasUI) {
				await ctx.ui.custom<undefined>(
					(_tui: any, theme: Theme, _kb: any, done: (r: undefined) => void) => {
						const container = new Container();
						container.addChild(new DynamicBorder((s: string) => theme.fg("accent", s)));
						container.addChild(
							new Text(
								` ${theme.fg("accent", theme.bold("btw"))} ${theme.fg("dim", `(${msg.model})`)}`,
								1,
								0,
							),
						);
						container.addChild(new Text(` ${theme.fg("muted", "Q: " + question)}`, 1, 0));
						container.addChild(new Text("", 0, 0));
						container.addChild(new Text(` ${answer}`, 1, 0));
						container.addChild(new Text("", 0, 0));
						container.addChild(
							new Text(` ${theme.fg("dim", "Enter/Esc to close")}`, 1, 0),
						);
						container.addChild(new DynamicBorder((s: string) => theme.fg("accent", s)));

						return {
							render: (w: number) => container.render(w),
							invalidate: () => container.invalidate(),
							handleInput: (data: string) => {
								if (
									matchesKey(data, "enter") ||
									matchesKey(data, "escape")
								) {
									done(undefined);
								}
							},
						};
					},
					{ overlay: true },
				);
			}
		} catch (err: any) {
			ctx.ui.notify(`btw error: ${err.message}`, "error");
		}
	}

	// Shortcut: Ctrl+B → open btw input (works while agent is streaming)
	pi.registerShortcut("ctrl+b", {
		description: "Ask a side question (btw)",
		handler: async (ctx) => {
			if (!ctx.hasUI) return;

			const question = await ctx.ui.custom<string | null>(
				(_tui, theme, _kb, done) => {
					const input = new BtwInputOverlay(theme, done);
					return {
						render: (w: number) => input.render(w),
						invalidate: () => input.invalidate(),
						handleInput: (data: string) => {
							input.handleInput(data);
							_tui.requestRender();
						},
						get focused() {
							return input.focused;
						},
						set focused(v: boolean) {
							input.focused = v;
						},
					};
				},
				{ overlay: true },
			);

			if (question) {
				askBtw(question, ctx);
			}
		},
	});

	// Shortcut: Ctrl+Shift+B → review btw history
	pi.registerShortcut("ctrl+shift+b", {
		description: "Review btw message history",
		handler: async (ctx) => {
			if (!ctx.hasUI) return;

			await ctx.ui.custom<undefined>(
				(_tui, theme, _kb, done) => {
					const viewer = new BtwHistoryOverlay(history, theme, done);
					return {
						render: (w: number) => viewer.render(w),
						invalidate: () => viewer.invalidate(),
						handleInput: (data: string) => {
							viewer.handleInput(data);
							_tui.requestRender();
						},
					};
				},
				{ overlay: true },
			);
		},
	});

	// Command: /btw <question> (for when agent is idle)
	pi.registerCommand("btw", {
		description: "Ask a side question without interrupting the agent",
		handler: async (args, ctx) => {
			if (!args?.trim()) {
				ctx.ui.notify("Usage: /btw <your question>", "warning");
				return;
			}
			await askBtw(args.trim(), ctx);
		},
	});
}
