import express from "express";
import PactDBClient from "../clients/pact.js";
import _ from "underscore";

const indexRouter = express.Router();

const dbClient = new PactDBClient();

/* GET balance per token for ALL chains. */
indexRouter.get("/:table/:walletAddress", (req, res) => {
  const { table, walletAddress } = req.params;
  try {
    if (table === "kaddex.skdx_token-table") {
      const balances = dbClient.querySingleChain(2, walletAddress, table);
      if (!_.isEmpty(balances.chains)) {
        res.status(200).json(balances);
      } else {
        res.status(200).json({});
      }
    } else {
      const balances = dbClient.queryAllChain(walletAddress, table);
      if (!_.isEmpty(balances.chains)) {
        res.status(200).json(balances);
      } else {
        res.status(200).json({});
      }
    }
  } catch (e) {
    console.log(`error fetching for address: ${walletAddress}: ${e.message}`);
    res.status(500).json({ error: e });
  }
});

export default indexRouter;
