import { weixinPlugin } from "./channel.js";
import type { PluginRuntime } from "openclaw/plugin-sdk/core";

export function register(runtime: PluginRuntime) {
  (runtime as any).registerChannel?.(weixinPlugin) ?? (runtime as any).register?.(weixinPlugin);
}

export function activate() {
  // No‑op – plugin is ready after registration.
}

export { weixinPlugin };
