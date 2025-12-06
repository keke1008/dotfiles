#!/usr/bin/env node
// @ts-check

import fs from "fs";

function main() {
	try {
		const input = readInput();
		const usage = parseLastUsage(input.transcript_path);
		const totalTokens = calculateTotalTokens(usage);
		const statusLine = buildStatusLine(input, totalTokens);
		console.log(statusLine);
	} catch (error) {
		console.log(`[StatusLine Error] ${error}`);
	}
}

main();

/**
 * @typedef {Object} Input
 * @property {string} transcript_path
 * @property {Object} model
 * @property {string} model.id
 */

/**
 * @returns {Input}
 */
function readInput() {
	const input = fs.readFileSync(0, "utf-8");
	return JSON.parse(input);
}

/**
 * @typedef {Object} Usage
 * @property {number} [input_tokens]
 * @property {number} [output_tokens]
 * @property {number} [cache_read_input_tokens]
 * @property {number} [cache_creation_input_tokens]
 *
 * @typedef {Object} TranscriptEntry
 * @property {string} type
 * @property {Object} message
 * @property {Usage?} [message.usage]
 */

/**
 * @param {string} transcriptPath
 * @returns {Usage}
 */
function parseLastUsage(transcriptPath) {
	/** @type {Usage} */
	const EMPTY_USAGE = {
		input_tokens: 0,
		output_tokens: 0,
		cache_read_input_tokens: 0,
		cache_creation_input_tokens: 0,
	};

	/** @type {string} */
	let content;
	try {
		content = fs.readFileSync(transcriptPath, "utf-8");
	} catch (error) {
		if (error.code === "ENOENT") {
			// When starting a new conversation, the transcript file may not exist yet.
			return EMPTY_USAGE;
		} else {
			throw error;
		}
	}

	const lines = content.split("\n");
	lines.reverse();
	for (const line of lines) {
		/** @type {TranscriptEntry} */
		let entry;
		try {
			entry = JSON.parse(line);
		} catch {
			continue;
		}

		if (entry.type === "assistant" && entry.message?.usage) {
			return entry.message.usage;
		}
	}

	return EMPTY_USAGE;
}

/**
 * @param {Input} input
 * @param {number} totalTokens
 * @returns {string}
 */
function buildStatusLine(input, totalTokens) {
	const tokenUsageText = formatTokenUsage(totalTokens);
	const modelName = input.model.id;
	return `${tokenUsageText} [${modelName}]`;
}

/**
 * @param {number} totalTokens
 * @returns {string}
 */
function formatTokenUsage(totalTokens) {
	const CONTEXT_WINDOW = 200_000;
	const AUTOCOMPACTION_BUFFER = 45_000;

	const percentage = Math.min(
		100,
		Math.round(((totalTokens + AUTOCOMPACTION_BUFFER) / CONTEXT_WINDOW) * 100),
	);

	const percentText = formatTokenUsagePercentText(percentage);
	const unUsableText = `${totalTokens.toLocaleString()} + ${AUTOCOMPACTION_BUFFER.toLocaleString()}`;
	const tokenText = `(${unUsableText}) / ${CONTEXT_WINDOW.toLocaleString()}`;
	return `${percentText} (${tokenText})`;
}

/**
 * @param {number} percentage
 * @returns {string}
 */
function formatTokenUsagePercentText(percentage) {
	if (percentage >= 80) {
		return colored("red", `${percentage}%`);
	} else if (percentage >= 60) {
		return colored("yellow", `${percentage}%`);
	} else {
		return `${percentage}%`;
	}
}

/**
 * @param {Usage} usage
 * @returns {number}
 */
function calculateTotalTokens(usage) {
	return (
		(usage.input_tokens || 0) +
		(usage.output_tokens || 0) +
		(usage.cache_read_input_tokens || 0) +
		(usage.cache_creation_input_tokens || 0)
	);
}

/**
 * @param {'yellow' | 'red'} color
 * @param {string} text
 * @returns {string}
 */
function colored(color, text) {
	const colors = {
		red: "\x1b[31m",
		yellow: "\x1b[33m",
		reset: "\x1b[0m",
	};
	return `${colors[color]}${text}${colors.reset}`;
}
