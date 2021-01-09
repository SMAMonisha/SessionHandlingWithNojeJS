const mysql = require('mysql');
const express = require('express');
var app = express();
const bodyparser = require('body-parser');
var exeCount=0;
app.use(bodyparser.urlencoded({ extended: false }));
app.use(bodyparser.json());

var mysqlConnection =mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'CartDB',
    multipleStatements: true
});
// var request = require('request');
// const { response } = require('express');

mysqlConnection.connect((err) => {
    if(!err)
        console.log('DB connected');

    else
        console.log('DB connection failed');    
});

app.listen(3000, () => console.log('Express server is runnig at port no : 3000'));

//Get all in cart
app.get('/cart', (req, res) => {
    //console.log(exeCount);

    mysqlConnection.query('SELECT * FROM cart', (err, rows, fields) => {
        if (!err)
        {
            res.send(rows);
        }
        else
            console.log(err);
    })
});

//Insert an item
app.post('/cart', (req, res) => {
    let emp = req.body;
    var sql1 = "SELECT COUNT(ItemName) into Itemscount FROM CART WHERE 1=1;";
    mysqlConnection.query(sql1, (err, rows) => {
     //console.log(rows)
    });
    var sql = "SET @ItemName = ?;SET @NumberOFItem = ?; \
    CALL store_in_cart(@ItemName,@NumberOFItem);";
    mysqlConnection.query(sql, [ emp.ItemName, emp.NumberOFItem], (err, rows, fields) => {
        console.log("rows"+rows);
        // var Arr=rows[0]
        // console.log("rows"+Arr.ItemName);

        if (!err){
            mysqlConnection.query('SELECT session_id  FROM CART WHERE session_id=LAST_INSERT_ID() ; ', (err, rows, fields) => {
                if (!err)
                {
                    res.send('Inserted cart session_id '+rows[1].session_id);
                }
                else
                    console.log(err);
            })            // rows.forEach(element => {
            // //    if(element.constructor == Array)
            // //    res.send('Inserted rating product id : '+element[0].productId);
            // });
            //console.log("y");
            //res.send('Inserted cart product id : ');

            
        }
        else
            console.log(err);


    })

    
});
// //Insert an employees
// app.post('/cart', (req, res) => {
//     let emp = req.body;
//     var sql = "SET @ItemName = ?;SET @NumberOFItem = ?; \
//     CALL store_in_cart(@ItemName,@NumberOFItem);";
//     mysqlConnection.query(sql, [ emp.ItemName, emp.NumberOFItem], (err, rows, fields) => {
//         //console.log("rows"+rows);
//         if (!err){
//             // rows.forEach(element => {
//             // //    if(element.constructor == Array)
//             // //    res.send('Inserted rating product id : '+element[0].productId);
//             // });
//             console.log("y");
//             res.send('Inserted cart product id : ');

            
//         }
//         else
//             console.log(err);


//     })

    
// });

//Delete an item
app.delete('/cart/remove/:name', (req, res) => {

    mysqlConnection.query('DELETE FROM cart WHERE ItemName = ?', [req.params.name], (err, rows, fields) => {
        if (!err)
            res.send('Deleted successfully.');
        else
            console.log(err);
    })
});

//decrease an item
app.delete('/cart/decrease/:name', (req, res) => {

    mysqlConnection.query('Update CART  Set NumberOFItem = NumberOFItem-1\
    WHERE ItemName = ?', [req.params.name], (err, rows, fields) => {
        if (!err)
            res.send('Decreased successfully.');
        else
            console.log(err);
    })
});