const express = require("express")
const app = express()

// app.set('view engine', 'ejs')

app.get("/", (req, res) => {
    console.log("INDEX is being rendered")
    // res.render("index")
    res.send("Hello PsychoPunkSage")
})

app.listen(3001);