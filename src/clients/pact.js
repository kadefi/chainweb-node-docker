import Database from "better-sqlite3";

const SQLITE_DIR = process.env.SQLITE_DIR || "/data/chainweb-db/0/sqlite";

const PACT_SQLITE_FILENAME = (id) => `${SQLITE_DIR}/pact-v1-chain-${id}.sqlite`;

const CHAIN_IDS =
  process.env.NODE_ENV === "production" ? [...Array(20).keys()] : ["2"];

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

  formatTokenPair(pair) {
    return pair.substring(pair.indexOf(":") + 1);
  }

  parsePriceJson(data) {
    const dataObj = data["$d"] ? data["$d"] : data;
    const { leg0, leg1 } = dataObj;
    const leg0Reserve = this.getReserve(leg0["$v"].reserve);
    const leg1Reserve = this.getReserve(leg1["$v"].reserve);
    return leg0Reserve / leg1Reserve;
  }

  queryPrices(chain, query) {
    const db = this.dbs[chain];
    const stmt = db.prepare(query);
    const rows = stmt.all();
    if (rows.length == 0) {
      return null;
    }
    const prices = rows.reduce((p, c) => {
      const { pair, rowdata } = c;
      const ratio = this.parsePriceJson(JSON.parse(rowdata.toString()));
      const tokenAddress = this.formatTokenPair(pair);
      p[tokenAddress] = ratio;
      return p;
    }, {});
    return prices;
  }

  queryPriceForToken(chain, query, tokenAddress) {
    const db = this.dbs[chain];
    const stmt = db.prepare(query);
    const row = stmt.get(tokenAddress);
    if (row) {
      const pair = row.pair;
      const json = JSON.parse(row.rowdata.toString());
      const response = {};
      response[this.formatTokenPair(pair)] = this.getReserve(json);
      return response;
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
