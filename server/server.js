import express from 'express';
import mysql from 'mysql2';
import cors from 'cors';
import session from 'express-session';

const app = express();
const port = 3000;

app.use(cors());

let pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: 'password',
    database: 'natural_disasters_volunteering_platform'
}).promise();

app.use(session({
    secret: 'secret-key',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false }
}));

app.post('/login/:username/:password', async (req, res) => {
    const user = req.params.username;
    const password = req.params.password;
    
    let [result] = await pool.query(`SELECT * FROM user WHERE username = ?`, [user]);
    if(result.length == 0) {
        res.send('Username not found');
    }else{
        if(result[0].password != password){
            res.send('Wrong password');
        }else{
            [result] = await pool.query(`SELECT * FROM admin WHERE admin_username = ?`, [user]);
            if(result.length == 0){
                [result] = await pool.query(`SELECT * FROM rescuer WHERE rescuer_username = ?`, [user]);
                if (result.length == 0) {
                    res.send('citizen');
                }else{
                    res.send('rescuer');
                }
            }else{
                res.send('admin');
            }
        }
    }
});

app.get('/cargo/:user', async (req, res) => {
    const user = req.params.user;
    const [result] = await pool.query(`
        SELECT * FROM cargo
            JOIN product ON cargo.product_id = product.id
            JOIN rescuer ON cargo.vehicle_name = rescuer.vehicle
        WHERE rescuer.rescuer_username = ?
    `, [user]);

    res.json(result);
});

app.delete('/unloadall/:user', async (req, res) => {
    const user = req.params.user;
    const [result] = await pool.query(`
        CALL rescuerUnloadCargoToBase(?)
    `, [user]);

    res.json(result);
});

app.post('/signup/:username/:password/:firstname/:lastname/:phone/:lat/:lng', async (req, res) => {
    const username = req.params.username;
    const password = req.params.password;
    const firstname = req.params.firstname;
    const lastname = req.params.lastname;
    const phone = req.params.phone;
    const lat = req.params.lat;
    const lng = req.params.lng;

    if(lat===undefined || lng===undefined) {
        res.send('fail');
    }else{
        await pool.query(`
            INSERT INTO \`user\` VALUES 
            (?, ?, ?, ?, ?) 
        `, [username, password, firstname, lastname, phone]);

        await pool.query(`
            INSERT INTO \`citizen\` VALUES 
            (?, ST_GeomFromText('POINT(? ?)'))
        `, [username, lng, lat]);

        res.send('success');
    }

});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
