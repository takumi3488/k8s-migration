import semver from "semver";

const version = (await Bun.stdin.text()).trim();
const newVersion = semver.inc(version, "patch") || "0.0.1";
console.log(newVersion);
