/**
 * Usage Tracker Extension
 *
 * Tracks token usage and cost per provider/model across sessions.
 * Persists to ~/.pi/agent/usage.json.
 *
 * Commands:
 *   /usage          - Show usage table (today, 7-day, all-time)
 *   /usage reset    - Clear all history
 *   /usage today    - Show today only
 *   /usage week     - Show last 7 days
 */

import * as fs from "node:fs";
import * as path from "node:path";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { getAgentDir } from "@mariozechner/pi-coding-agent";
import { matchesKey, truncateToWidth } from "@mariozechner/pi-tui";

// --- Types ---

interface DailyStats {
	requests: number;
	inputTokens: number;
	outputTokens: number;
	cacheReadTokens: number;
	cacheWriteTokens: number;
	cost: number;
}

interface ModelStats {
	[date: string]: DailyStats;
}

interface ProviderStats {
	[model: string]: ModelStats;
}

interface UsageData {
	version: 1;
	providers: { [provider: string]: ProviderStats };
	requestTimestamps: number[]; // recent timestamps for rate tracking
}

// --- Helpers ---

const USAGE_FILE = path.join(getAgentDir(), "usage.json");
const RATE_WINDOW_MS = 5 * 60 * 1000; // 5 minutes
const MAX_TIMESTAMPS = 500;

function today(): string {
	return new Date().toISOString().slice(0, 10);
}

function daysAgo(n: number): string {
	const d = new Date();
	d.setDate(d.getDate() - n);
	return d.toISOString().slice(0, 10);
}

function emptyStats(): DailyStats {
	return { requests: 0, inputTokens: 0, outputTokens: 0, cacheReadTokens: 0, cacheWriteTokens: 0, cost: 0 };
}

function emptyUsageData(): UsageData {
	return { version: 1, providers: {}, requestTimestamps: [] };
}

function loadUsageData(): UsageData {
	try {
		const raw = fs.readFileSync(USAGE_FILE, "utf-8");
		const data = JSON.parse(raw) as UsageData;
		if (data.version === 1) return data;
	} catch {
		// file missing or corrupt
	}
	return emptyUsageData();
}

function saveUsageData(data: UsageData): void {
	const dir = path.dirname(USAGE_FILE);
	if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
	fs.writeFileSync(USAGE_FILE, JSON.stringify(data, null, 2), { encoding: "utf-8", mode: 0o600 });
}

function sumStats(statsList: DailyStats[]): DailyStats {
	const total = emptyStats();
	for (const s of statsList) {
		total.requests += s.requests;
		total.inputTokens += s.inputTokens;
		total.outputTokens += s.outputTokens;
		total.cacheReadTokens += s.cacheReadTokens;
		total.cacheWriteTokens += s.cacheWriteTokens;
		total.cost += s.cost;
	}
	return total;
}

function getStatsForDateRange(modelStats: ModelStats, fromDate: string, toDate: string): DailyStats {
	const days: DailyStats[] = [];
	for (const [date, stats] of Object.entries(modelStats)) {
		if (date >= fromDate && date <= toDate) days.push(stats);
	}
	return sumStats(days);
}

function getAllStats(modelStats: ModelStats): DailyStats {
	return sumStats(Object.values(modelStats));
}

function formatTokens(n: number): string {
	if (n < 1000) return n.toString();
	if (n < 10000) return `${(n / 1000).toFixed(1)}k`;
	if (n < 1000000) return `${Math.round(n / 1000)}k`;
	return `${(n / 1000000).toFixed(1)}M`;
}

function formatCost(n: number): string {
	if (n === 0) return "-";
	if (n < 0.01) return `$${n.toFixed(4)}`;
	if (n < 1) return `$${n.toFixed(3)}`;
	return `$${n.toFixed(2)}`;
}

function pruneTimestamps(timestamps: number[]): number[] {
	const cutoff = Date.now() - RATE_WINDOW_MS;
	const recent = timestamps.filter((t) => t > cutoff);
	// keep only last MAX_TIMESTAMPS
	return recent.slice(-MAX_TIMESTAMPS);
}

// --- Extension ---

export default function (pi: ExtensionAPI) {
	let usageData = emptyUsageData();
	let sessionCost = 0;
	let sessionRequests = 0;

	const reload = () => {
		usageData = loadUsageData();
	};

	const updateStatus = (ctx: { hasUI: boolean; ui: any }) => {
		if (!ctx.hasUI) return;
		const theme = ctx.ui.theme;
		const parts: string[] = [];

		// Session cost
		if (sessionCost > 0) {
			parts.push(theme.fg("accent", formatCost(sessionCost)));
		}

		// Rate info
		const now = Date.now();
		const cutoff = now - RATE_WINDOW_MS;
		const recentCount = usageData.requestTimestamps.filter((t) => t > cutoff).length;
		if (recentCount > 0) {
			parts.push(theme.fg("dim", `${recentCount} req/5m`));
		}

		if (parts.length > 0) {
			ctx.ui.setStatus("usage-tracker", parts.join(" "));
		} else {
			ctx.ui.setStatus("usage-tracker", "");
		}
	};

	// Load on session start/switch
	pi.on("session_start", async (_event, ctx) => {
		reload();
		sessionCost = 0;
		sessionRequests = 0;
		updateStatus(ctx);
	});

	pi.on("session_switch", async (_event, ctx) => {
		sessionCost = 0;
		sessionRequests = 0;
		updateStatus(ctx);
	});

	// Track usage on every assistant message
	pi.on("message_end", async (event, ctx) => {
		const msg = event.message;
		if (msg.role !== "assistant") return;

		const provider = msg.provider || "unknown";
		const model = msg.model || "unknown";
		const usage = msg.usage;
		if (!usage) return;

		const date = today();

		// Ensure nested structure
		if (!usageData.providers[provider]) usageData.providers[provider] = {};
		if (!usageData.providers[provider][model]) usageData.providers[provider][model] = {};
		if (!usageData.providers[provider][model][date]) usageData.providers[provider][model][date] = emptyStats();

		const stats = usageData.providers[provider][model][date];
		stats.requests += 1;
		stats.inputTokens += usage.input || 0;
		stats.outputTokens += usage.output || 0;
		stats.cacheReadTokens += usage.cacheRead || 0;
		stats.cacheWriteTokens += usage.cacheWrite || 0;
		stats.cost += usage.cost?.total || 0;

		// Track timestamp for rate monitoring
		usageData.requestTimestamps.push(Date.now());
		usageData.requestTimestamps = pruneTimestamps(usageData.requestTimestamps);

		// Session totals
		sessionCost += usage.cost?.total || 0;
		sessionRequests += 1;

		saveUsageData(usageData);
		updateStatus(ctx);
	});

	// /usage command
	pi.registerCommand("usage", {
		description: "Show usage stats per provider/model",
		handler: async (args, ctx) => {
			if (!ctx.hasUI) {
				ctx.ui.notify("/usage requires interactive mode", "error");
				return;
			}

			const trimmed = args.trim().toLowerCase();

			if (trimmed === "reset") {
				const ok = await ctx.ui.confirm("Reset usage data?", "This clears all tracked usage history.");
				if (ok) {
					usageData = emptyUsageData();
					saveUsageData(usageData);
					sessionCost = 0;
					sessionRequests = 0;
					updateStatus(ctx);
					ctx.ui.notify("Usage data cleared", "info");
				}
				return;
			}

			// Determine date range filter
			let filterLabel = "All Time";
			let filterFrom: string | null = null;
			const filterTo = today();

			if (trimmed === "today") {
				filterLabel = "Today";
				filterFrom = today();
			} else if (trimmed === "week") {
				filterLabel = "Last 7 Days";
				filterFrom = daysAgo(6);
			}

			reload(); // refresh from disk

			await ctx.ui.custom<void>((tui, theme, _kb, done) => {
				let cachedLines: string[] | undefined;

				function render(width: number): string[] {
					if (cachedLines) return cachedLines;

					const lines: string[] = [];
					const add = (s: string) => lines.push(truncateToWidth(s, width));
					const sep = theme.fg("accent", "─".repeat(width));

					add(sep);
					add("");
					add(
						`  ${theme.fg("accent", theme.bold("Usage Tracker"))}  ${theme.fg("muted", filterLabel)}`,
					);
					add("");

					const providerEntries = Object.entries(usageData.providers);
					if (providerEntries.length === 0) {
						add(`  ${theme.fg("dim", "No usage data yet.")}`);
						add("");
						add(sep);
						cachedLines = lines;
						return lines;
					}

					// Session info
					if (sessionRequests > 0) {
						add(
							`  ${theme.fg("muted", "Session:")} ${theme.fg("text", `${sessionRequests} requests`)} ${theme.fg("accent", formatCost(sessionCost))}`,
						);
						add("");
					}

					// Rate info
					const now = Date.now();
					const cutoff = now - RATE_WINDOW_MS;
					const recentCount = usageData.requestTimestamps.filter((t) => t > cutoff).length;
					if (recentCount > 0) {
						const color = recentCount > 30 ? "error" : recentCount > 15 ? "warning" : "dim";
						add(`  ${theme.fg("muted", "Rate:")} ${theme.fg(color, `${recentCount} requests in last 5 min`)}`);
						add("");
					}

					// Table header
					const hdr =
						`  ${theme.fg("accent", pad("Provider / Model", 35))}` +
						`${theme.fg("muted", pad("Reqs", 7))}` +
						`${theme.fg("muted", pad("Input", 9))}` +
						`${theme.fg("muted", pad("Output", 9))}` +
						`${theme.fg("muted", pad("Cache R", 9))}` +
						`${theme.fg("muted", pad("Cost", 10))}`;
					add(hdr);
					add(`  ${theme.fg("dim", "─".repeat(Math.min(width - 4, 79)))}`);

					let grandTotal = emptyStats();

					for (const [provider, models] of providerEntries) {
						// Provider-level totals
						let providerTotal = emptyStats();
						const modelRows: { name: string; stats: DailyStats }[] = [];

						for (const [model, modelStats] of Object.entries(models)) {
							const stats = filterFrom
								? getStatsForDateRange(modelStats, filterFrom, filterTo)
								: getAllStats(modelStats);
							if (stats.requests === 0) continue;
							modelRows.push({ name: model, stats });
							providerTotal = sumStats([providerTotal, stats]);
						}

						if (providerTotal.requests === 0) continue;
						grandTotal = sumStats([grandTotal, providerTotal]);

						// Provider header
						add(`  ${theme.fg("text", theme.bold(provider))}`);

						for (const row of modelRows) {
							const s = row.stats;
							// Shorten model name if too long
							const modelName = row.name.length > 33 ? `${row.name.slice(0, 30)}...` : row.name;
							add(
								`  ${theme.fg("dim", "  " + pad(modelName, 33))}` +
									`${theme.fg("text", pad(String(s.requests), 7))}` +
									`${theme.fg("text", pad(formatTokens(s.inputTokens), 9))}` +
									`${theme.fg("text", pad(formatTokens(s.outputTokens), 9))}` +
									`${theme.fg("text", pad(formatTokens(s.cacheReadTokens), 9))}` +
									`${theme.fg("accent", pad(formatCost(s.cost), 10))}`,
							);
						}

						// Provider subtotal if multiple models
						if (modelRows.length > 1) {
							add(
								`  ${theme.fg("muted", "  " + pad("subtotal", 33))}` +
									`${theme.fg("muted", pad(String(providerTotal.requests), 7))}` +
									`${theme.fg("muted", pad(formatTokens(providerTotal.inputTokens), 9))}` +
									`${theme.fg("muted", pad(formatTokens(providerTotal.outputTokens), 9))}` +
									`${theme.fg("muted", pad(formatTokens(providerTotal.cacheReadTokens), 9))}` +
									`${theme.fg("muted", pad(formatCost(providerTotal.cost), 10))}`,
							);
						}
						add("");
					}

					// Grand total
					add(`  ${theme.fg("dim", "─".repeat(Math.min(width - 4, 79)))}`);
					add(
						`  ${theme.fg("accent", theme.bold(pad("Total", 35)))}` +
							`${theme.fg("text", pad(String(grandTotal.requests), 7))}` +
							`${theme.fg("text", pad(formatTokens(grandTotal.inputTokens), 9))}` +
							`${theme.fg("text", pad(formatTokens(grandTotal.outputTokens), 9))}` +
							`${theme.fg("text", pad(formatTokens(grandTotal.cacheReadTokens), 9))}` +
							`${theme.fg("accent", theme.bold(pad(formatCost(grandTotal.cost), 10)))}`,
					);

					add("");
					add(`  ${theme.fg("dim", "Esc close • /usage today • /usage week • /usage reset")}`);
					add(sep);

					cachedLines = lines;
					return lines;
				}

				function handleInput(data: string) {
					if (matchesKey(data, "escape") || matchesKey(data, "ctrl+c")) {
						done();
					}
				}

				return {
					render,
					invalidate: () => {
						cachedLines = undefined;
					},
					handleInput,
				};
			});
		},
	});
}

function pad(s: string, len: number): string {
	return s.length >= len ? s : s + " ".repeat(len - s.length);
}
