import express from "express";
import axios from "axios";

const healthRouter = express.Router();

const kadenaCheckHeight = async () => {
  const height = await kadenaGetHeight();
  console.log("current height:", height);
  const currentTime = new Date().getTime();
  const baseTime = 1625422726000;
  const baseHeight = 35347955;
  const timeDifference = currentTime - baseTime;
  const blocksPassedInDifference = (timeDifference / 30000) * 20; // 20 chains with blocktime 30 seconds
  const currentBlockEstimation = baseHeight + blocksPassedInDifference;
  const minimumAcceptedBlockHeight = currentBlockEstimation - 18000; // allow being off sync for 1200 blocks; 30 mins
  if (height > minimumAcceptedBlockHeight) {
    return true;
  }
  console.log("node is not synced yet");
  return false;
};

const kadenaGetHeight = async () => {
  try {
    const kadenaData = await axios.get(
      `http://localhost:${process.env.CHAINWEB_SERVICE_PORT}/chainweb/0.0/mainnet01/cut`,
      {
        timeout: 5000,
      }
    );
    console.log(`${ip}: HEIGHT: ${kadenaData.data.height}`);
    return kadenaData.data.height;
  } catch (e) {
    console.log(e.message);
    return -1;
  }
};

healthRouter.get("/health", async (req, res) => {
  const isSynced = await kadenaCheckHeight();
  return isSynced ? res.status(200).send() : res.status(500).send();
});

export default healthRouter;
