import express from "express";
import PactDBClient from "../clients/pact.js";
import _ from "underscore";

const priceRouter = express.Router();

const dbClient = new PactDBClient();

const getPriceForTokenQuery = (table) => `SELECT pair, rowdata 
FROM "${table}" as orig
INNER JOIN (
  SELECT rowkey as pair, MAX(txid) as txid 
  FROM "${table}" 
  GROUP BY rowkey
) as temp
ON orig.rowkey = temp.pair AND orig.txid = temp.txid
WHERE orig.rowkey= ?`;

const getAllPricesQuery = (table) => `SELECT pair, rowdata 
FROM "${table}" as orig
INNER JOIN (
  SELECT rowkey as pair, MAX(txid) as txid 
  FROM "${table}" 
  GROUP BY rowkey
) as temp
ON orig.rowkey = temp.pair AND orig.txid = temp.txid`;

priceRouter.get("/kaddex/:tokenAddress", (req, res) => {
  const { tokenAddress } = req.params;
  const formatted = `coin:${tokenAddress}`;
  try {
    const price = dbClient.queryPriceForToken(
      2,
      getPriceForTokenQuery("kaddex.exchange_pairs"),
      formatted
    );
    if (!price) {
      res.status(500).json({ error: "failed to get price from kaddex" });
    } else {
      res.status(200).json(price);
    }
  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e });
  }
});

priceRouter.get("/kaddex", (req, res) => {
  try {
    const prices = dbClient.queryPrices(
      2,
      getAllPricesQuery("kaddex.exchange_pairs")
    );
    if (!prices) {
      res.status(500).json({ error: "failed to get prices from kaddex" });
    } else {
      res.status(200).json(prices);
    }
  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e });
  }
});

priceRouter.get("/kdswap/:tokenAddress", (req, res) => {
  const { tokenAddress } = req.params;
  const formatted = `coin:${tokenAddress}`;
  try {
    const price = dbClient.queryPriceForToken(
      1,
      getPriceForTokenQuery("kdlaunch.kdswap-exchange_pairs"),
      formatted
    );
    if (!price) {
      res.status(500).json({ error: "failed to get price from kdswap" });
    } else {
      res.status(200).json(price);
    }
  } catch (e) {
    console.log(e);
    // console.log(`error fetching for address: ${walletAddress}: ${e.message}`);
    res.status(500).json({ error: e });
  }
});

priceRouter.get("/kdswap", (req, res) => {
  try {
    const prices = dbClient.queryPrices(
      1,
      getAllPricesQuery("kdlaunch.kdswap-exchange_pairs")
    );
    if (!prices) {
      res.status(500).json({ error: "failed to get prices from kdswap" });
    } else {
      res.status(200).json(prices);
    }
  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e });
  }
});

export default priceRouter;
