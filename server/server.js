import express from 'express';
import mysql from 'mysql2';
import cors from 'cors';
import session from 'express-session';

const app = express();
const port = 3000;

app.use(cors({
    origin: 'http://localhost:5500',
    credentials: true,
}));
app.use(express.static('public'));

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
        SELECT * FROM \`cargo\`
            JOIN \`product\` ON \`cargo\`.\`product_id\` = \`product\`.\`id\`
            JOIN \`rescuer\` ON \`cargo\`.\`vehicle_name\` = \`rescuer\`.\`vehicle\`
        WHERE \`rescuer\`.\`rescuer_username\` = ?
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

app.post('/signup/citizen/:username/:password/:firstname/:lastname/:phone/:lat/:lng', async (req, res) => {
    let username = req.params.username;
    let password = req.params.password;
    let firstname = req.params.firstname;
    let lastname = req.params.lastname;
    let phone = req.params.phone;
    let lat = req.params.lat;
    let lng = req.params.lng;

    let [result] = await pool.query(`
        SELECT * FROM \`user\` WHERE \`username\` = ? 
    `, [username])

    if(result.length == 0) {
        
        phone = parseInt(phone);
        lat = parseFloat(lat);
        lng = parseFloat(lng);

        await pool.query(`
            INSERT INTO \`user\` VALUES 
            (?, ?, ?, ?, ?) 
        `, [username, password, firstname, lastname, phone]);

        await pool.query(`
            INSERT INTO \`citizen\` VALUES 
            (?, ST_GeomFromText('POINT(${lat} ${lng})'))
        `, [username]);

        res.send('success');
        
    }else{
        res.send('username_already_exists');
    }

});

app.post('/signup/rescuer/:admin/:username/:password/:firstname/:lastname/:phone/:vehicle', async (req, res) => {
    let username = req.params.username;
    let password = req.params.password;
    let firstname = req.params.firstname;
    let lastname = req.params.lastname;
    let phone = req.params.phone;
    let vehicle = req.params.vehicle;
    let admin = req.params.admin;

    let [result] = await pool.query(`
        SELECT * FROM \`user\` WHERE \`username\` = ? 
    `, [username])

    if(result.length == 0){
        await pool.query(`
            CALL newRescuer(?, ?, ?, ?, ?, ?, ?)
        `, [username, password, firstname, lastname, phone, vehicle, admin]);

        res.send('success');
    }else {
        res.send('fail');
    }

});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
