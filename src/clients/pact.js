import Database from "better-sqlite3";

const SQLITE_DIR = process.env.SQLITE_DIR || "/data/chainweb-db/0/sqlite";

const PACT_SQLITE_FILENAME = (id) => `${SQLITE_DIR}/pact-v1-chain-${id}.sqlite`;

const CHAIN_IDS =
  process.env.NODE_ENV === "production" ? [...Array(20).keys()] : ["1"];

class PactDBClient {
  constructor() {
    this.dbs = CHAIN_IDS.map((id) => {
      console.log(`connecting to ${PACT_SQLITE_FILENAME(id)}`);
      return new Database(PACT_SQLITE_FILENAME(id), {
        readonly: true,
      });
    });
  }

  getReserve(balanceObject) {
    return parseFloat(
      balanceObject.decimal ? balanceObject.decimal : balanceObject
    );
  }

  queryChainToken(chain, address, table) {
    const db = this.dbs[chain];
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

  querySingleChain(chain, address, table) {
    console.log(`fetching balances for ${table} for address: ${address}`);
    const balance = this.queryChainToken(chain, address, table);
    console.log(`done fetching balances for ${table} for address: ${address}`);
    const balances = {};
    if (balance) {
      balances[chain] = balance;
    }
    return { chains: balances, balance };
  }

  queryAllChain(address, table) {
    console.log(`fetching balances for ${table} for address: ${address}`);
    const balanceResponses = this.dbs.map((db) =>
      this.queryToken(db, address, table)
    );
    console.log(`done fetching balances for ${table} for address: ${address}`);
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
