const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello from Service 2!');
});

app.listen(port, () => {
  console.log(`Service 2 listening at http://localhost:${port}`);
});
