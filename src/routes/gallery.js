import express from "express";
import PactDBClient from "../clients/pact.js";
import _ from "underscore";

const galleryRouter = express.Router();

const dbClient = new PactDBClient();

/* GET balance per token for ALL chains. */
galleryRouter.get("/mintit/collections", (req, res) => {
  try {
    const results = dbClient.queryChain(8, `SELECT DISTINCT rowkey FROM "free.mintit-policy-v3_nft-collection-table"`);
    const collections = results.map(r => r.rowkey);
    res.status(200).json(collections);
  } catch (e) {
    console.log(`error fetching for address: ${walletAddress}: ${e.message}`);
    res.status(500).json({ error: e });
  }
});

export default galleryRouter;

