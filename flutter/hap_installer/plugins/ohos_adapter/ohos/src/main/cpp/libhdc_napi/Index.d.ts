
export function executeCommand(command: string): string;

/**
 * Start the built-in hdc server (daemon) in a background thread.
 * Safe to call multiple times; subsequent calls return immediately if already running.
 *
 * @returns `true` if the server is running.
 */
export function startDaemon(): boolean;

/**
 * Start an interactive hdc shell session in a background thread.
 * Use `onData()` to receive output and `sendInput()` to write to the shell.
 * Safe to call multiple times; subsequent calls return immediately if already running.
 *
 * @returns `true` if the shell session started successfully.
 */
export function startShell(): boolean;

/**
 * Stop the currently running interactive shell session.
 * Releases all associated resources and the onData callback.
 *
 * @returns `true` if the shell session was stopped (or was not running).
 */
export function stopShell(): boolean;

/**
 * Register a callback to receive data from the interactive shell session.
 * The callback is invoked on the JS main thread whenever the shell produces output.
 * Any data received before this callback is registered will be buffered and
 * flushed to the callback immediately upon registration.
 *
 * @param callback - A function that receives shell output as a UTF-8 string.
 */
export function onData(callback: (data: string) => void): void;

/**
 * Send UTF-8 input data to the interactive shell session.
 * Designed for use with xterm.js — each keystroke or paste event can be
 * sent directly as a string.
 *
 * @param data - The UTF-8 string data to send to the shell.
 * @throws Error if the shell session is not running.
 */
export function sendInput(data: string): void;
