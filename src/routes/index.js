import express from "express";
import PactDBClient from "../clients/pact.js";
import _ from "underscore";

const indexRouter = express.Router();

const dbClient = new PactDBClient();

/* GET balance per token for ALL chains. */
indexRouter.get("/:tokenAddress/:walletAddress", (req, res) => {
  const { tokenAddress, walletAddress } = req.params;
  const balances = dbClient.queryAllChain(walletAddress, tokenAddress);
  if (!_.isEmpty(balances)) {
    res.status(200).json(balances);
  } else {
    res.status(204).send();
  }
});

export default indexRouter;
