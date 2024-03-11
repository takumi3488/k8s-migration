import { parse } from 'pgsql-ast-parser';
import type { Statement } from 'pgsql-ast-parser';
import { Glob } from "bun"

const glob = new Glob("migrations/**/*.sql")

for await (const file of glob.scan(".")) {
  const sql = (await Bun.file(file).text())
    .split("\n")
    .filter((line) => !line.startsWith("--") && line.trim() !== "")
    .join("\n")
  if (sql.trim() === "") continue;
  try {
    const ast: Statement[] = parse(sql)
  } catch (e: any) {
    console.error(`Error in ${file}: ${e.message}`)
  }
}
