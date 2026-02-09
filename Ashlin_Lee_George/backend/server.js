const express = require("express");
const flowerRouter=require('./routes/flowerRouter');
const cors = require("cors");
require("./db");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/flowers", flowerRouter);

app.listen(4000, () => {
  console.log(" Server running on port 4000");
});
