import Database from "better-sqlite3";

const SQLITE_DIR = process.env.SQLITE_DIR || "/data/chainweb-db/0/sqlite";

const PACT_SQLITE_FILENAME = (id) => `${SQLITE_DIR}/pact-v1-chain-${id}.sqlite`;

const CHAIN_IDS =
  process.env.NODE_ENV === "production" ? [...Array(20).keys()] : ["1"];

class PactDBClient {
  constructor() {
    this.dbs = CHAIN_IDS.map((id) => new Database(PACT_SQLITE_FILENAME(id)));
  }

  getReserve(balanceObject) {
    return parseFloat(
      balanceObject.decimal ? balanceObject.decimal : balanceObject
    );
  }

  queryToken(db, address, table) {
    const stmt = db.prepare(
      `SELECT rowdata FROM "${table}"
      WHERE rowkey = ? 
      ORDER BY txid DESC 
      LIMIT 1`
    );
    const row = stmt.get(address);
    if (row) {
      const json = JSON.parse(row.rowdata.toString());
      const balanceObject = json["$d"] ? json["$d"].balance : json.balance;
      const balance = this.getReserve(balanceObject);
      return balance;
    }
    return null;
  }

  queryAllChain(address, table) {
    const balanceResponses = this.dbs.map((db) =>
      this.queryToken(db, address, table)
    );

    const balances = {};
    let total = 0;
    balanceResponses.forEach((balance, i) => {
      if (balance) {
        balances[i] = balance;
        total += balance;
      }
    });

    return { chains: balances, balance: total };
  }
}

export default PactDBClient;
