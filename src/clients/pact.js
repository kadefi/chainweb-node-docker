import Database from "better-sqlite3";

const SQLITE_DIR = process.env.SQLITE_DIR || "/data/chainweb-db/0/sqlite";

const PACT_SQLITE_FILENAME = (id) => `${SQLITE_DIR}/pact-v1-chain-${id}.sqlite`;

const CHAIN_IDS = [...Array(20).keys()];

class PactDBClient {
  constructor() {
    this.dbs = CHAIN_IDS.map((id) => new Database(PACT_SQLITE_FILENAME(id)));
  }

  queryToken(db, address, tokenAddress) {
    const tokenTable = this.getTokenTableName(tokenAddress);
    const stmt = db.prepare(
      `SELECT rowdata FROM "${tokenTable}"
      WHERE rowkey = ? 
      ORDER BY txid DESC 
      LIMIT 1`
    );
    const row = stmt.get(address);
    if (row) {
      const json = JSON.parse(row.rowdata.toString());
      const balance = json["$d"].balance;
      return balance;
    }
    return null;
  }

  queryAllChain(address, tokenAddress) {
    const balanceResponses = this.dbs.map((db) =>
      this.queryToken(db, address, tokenAddress)
    );

    const balances = {};
    balanceResponses.forEach((balance, i) => {
      if (balance) {
        balances[i] = balance;
      }
    });

    return balances;
  }

  getTokenTableName(tokenAddress) {
    return tokenAddress === "coin"
      ? "coin_coin-table"
      : `${tokenAddress}_token-table`;
  }
}

export default PactDBClient;
