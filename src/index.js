import express from "express";
import cookieParser from "cookie-parser";
import http from "http";
import cluster from "cluster";

import indexRouter from "./routes/index.js";
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

app.use("/balance", indexRouter);

const port = process.env.PORT || 3000;
app.set("port", port);

if (cluster.isPrimary) {
  for (var i = 0; i < 4; i++) {
    cluster.fork();
  }

  // If a worker dies, log it to the console and start another worker.
  cluster.on("exit", function (worker, code, signal) {
    console.log("Worker " + worker.process.pid + " died.");
    cluster.fork();
  });

  // Log when a worker starts listening
  cluster.on("listening", function (worker, address) {
    console.log("Worker started with PID " + worker.process.pid + ".");
  });
} else {
  const server = http.createServer(app);
  server.listen(port);
  server.on("listening", onListening);
  function onListening() {
    const addr = server.address();
    const bind =
      typeof addr === "string" ? "pipe " + addr : "port " + addr.port;
    console.log("Listening on " + bind);
  }
}

export default app;
