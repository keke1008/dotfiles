#!/usr/bin/env node
// @ts-check

import { readFileSync } from "fs";
import { execSync } from "child_process";

// Autocompaction buffer is ~33k tokens
const AUTOCOMPACTION_BUFFER_TOKENS = 33000;

// Tokyo Night color palette (24-bit ANSI)
const C = {
	blue:      "\x1b[38;2;122;162;247m", // #7aa2f7
	blue_dark: "\x1b[38;2;59;66;97m",    // #3b4261
	red:       "\x1b[38;2;247;118;142m", // #f7768e
	yellow:    "\x1b[38;2;224;175;104m", // #e0af68
	reset:     "\x1b[0m",
};

const SEP = "";

function main() {
	try {
		const input = readInput();
		const statusLine = buildStatusLine(input);
		process.stdout.write(statusLine + "\n");
	} catch (error) {
		process.stdout.write(`[StatusLine Error] ${error}\n`);
	}
}

main();

/**
 * @typedef {Object} ContextWindow
 * @property {number|null} used_percentage
 * @property {number|null} context_window_size
 *
 * @typedef {Object} Input
 * @property {Object} model
 * @property {string} model.id
 * @property {ContextWindow} context_window
 * @property {string} cwd
 */

/**
 * @returns {Input}
 */
function readInput() {
	const input = readFileSync(0, "utf-8");
	return JSON.parse(input);
}

/**
 * @param {Input} input
 * @returns {string}
 */
function buildStatusLine(input) {
	const rawPercentage = input.context_window.used_percentage ?? 0;
	const contextWindowSize = input.context_window.context_window_size ?? 200000;
	const bufferPercent = (AUTOCOMPACTION_BUFFER_TOKENS / contextWindowSize) * 100;
	const percentage = Math.min(100, Math.round(rawPercentage + bufferPercent));
	const percentText = formatTokenUsagePercentText(percentage);
	const modelName = input.model.id;
	const cwd = input.cwd ?? process.cwd();
	const homedir = process.env.HOME ?? "";
	const dirPath = homedir && cwd.startsWith(homedir)
		? "~" + cwd.slice(homedir.length)
		: cwd;
	const branchName = getGitBranch(cwd);

	const sections = [
		percentText,
		`${C.blue}${modelName}${C.reset}`,
		`${C.blue}${dirPath}${C.reset}`,
		...(branchName ? [`${C.blue}${branchName}${C.reset}`] : []),
	];

	const sep = `${C.blue} ${SEP} ${C.reset}`;
	return sections.join(sep) + sep;
}

/**
 * @param {string} cwd
 * @returns {string|null}
 */
function getGitBranch(cwd) {
	try {
		const branch = execSync("git symbolic-ref --short HEAD 2>/dev/null", {
			cwd,
			encoding: "utf-8",
			timeout: 3000,
			env: { ...process.env, GIT_OPTIONAL_LOCKS: "0" },
		}).trim();
		return branch || null;
	} catch {
		return null;
	}
}

/**
 * @param {number} percentage
 * @returns {string}
 */
function formatTokenUsagePercentText(percentage) {
	if (percentage >= 80) {
		return `${C.red}${percentage}%${C.reset}`;
	} else if (percentage >= 60) {
		return `${C.yellow}${percentage}%${C.reset}`;
	} else {
		return `${C.blue}${percentage}%${C.reset}`;
	}
}
