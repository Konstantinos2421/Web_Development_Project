import express from 'express';
import mysql from 'mysql2';
import cors from 'cors';
import session from 'express-session';
import bodyParser from 'body-parser';

const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(express.static('server'));
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
    saveUninitialized: false,
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

app.post('/unloadall/:user', async (req, res) => {
    const user = req.params.user;
    await pool.query(`
        CALL rescuerUnloadCargoToBase(?)
    `, [user]);

    res.send('success');
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

app.get('/base_inventory/rescuer/:user', async (req, res) => {
    let user = req.params.user;

    let [result] = await pool.query(`
        SELECT * FROM \`rescuer\` 
        WHERE \`rescuer_username\` = ?
    `, [user]);

    let base = result[0].base;

    [result] = await pool.query(`
        SELECT \`product\`.\`product_name\` AS product_name, \`base_inventory\`.\`quantity\` AS quantity, \`product\`.\`id\` AS product_id
        FROM \`base_inventory\`
            JOIN \`product\` ON \`base_inventory\`.\`product_id\` = \`product\`.\`id\`
        WHERE \`base_inventory\`.\`base\` = ?  
        ORDER BY \`product\`.\`product_name\`
    `, [base]);

    res.json(result);
});

app.get('/base_inventory/admin/:admin', async (req, res) => {
    let admin = req.params.admin;

    let [result] = await pool.query(`
        SELECT * FROM \`admin\` 
        WHERE \`admin_username\` = ?
    `, [admin]);

    let base = result[0].base;

    [result] = await pool.query(`
        SELECT \`product\`.\`product_name\` AS product_name, \`base_inventory\`.\`quantity\` AS quantity, \`product\`.\`id\` AS product_id
        FROM \`base_inventory\`
            JOIN \`product\` ON \`base_inventory\`.\`product_id\` = \`product\`.\`id\`
        WHERE \`base_inventory\`.\`base\` = ?  
        ORDER BY \`product\`.\`product_name\`
    `, [base]);

    res.json(result);
});

app.post('/loadFromBase/:user', (req, res) => {
    let user = req.params.user;
    const receivedData = req.body;

    receivedData.forEach(async item => {
        await pool.query(`
            CALL rescuerLoadCargoFromBase(?, ?, ?)
        `, [user, item.product_id, item.quantity]);
    });

    res.send('success');
});

app.get('/base_location/:admin', async (req, res) => {
    let admin = req.params.admin;

    let [result] = await pool.query(`
        SELECT * 
        FROM \`admin\` 
            JOIN \`base\` ON \`admin\`.\`base\` = \`base\`.\`base_name\`
        WHERE \`admin_username\` = ?
    `, [admin]);

    let base = result[0].base_location;
    res.json(base);
})

app.get('/accepted/requests', async (req, res) => {
    
    let [result] = await pool.query(`
        SELECT *
        FROM \`task\`
            JOIN \`request\` ON \`task\`.\`task_id\` = \`request\`.\`request_id\`
            JOIN \`citizen\` ON \`request\`.\`request_user\` = \`citizen\`.\`citizen_username\`
            JOIN \`user\` ON \`citizen\`.\`citizen_username\` = \`user\`.\`username\`
            JOIN \`product\` ON \`request\`.\`product_id\` = \`product\`.\`id\`
            JOIN \`rescuer\` ON \`task\`.\`rescuer_took_over\` = \`rescuer\`.\`rescuer_username\`
        WHERE \`task\`.\`accepted\` = 'YES' AND \`task\`.\`completed\` = 'NO'
    `);

    res.json(result);
});

app.get('/unaccepted/requests', async (req, res) => {

    let [result] = await pool.query(`
        SELECT *
        FROM \`task\`
            JOIN \`request\` ON \`task\`.\`task_id\` = \`request\`.\`request_id\`
            JOIN \`citizen\` ON \`request\`.\`request_user\` = \`citizen\`.\`citizen_username\`
            JOIN \`user\` ON \`citizen\`.\`citizen_username\` = \`user\`.\`username\`
            JOIN \`product\` ON \`request\`.\`product_id\` = \`product\`.\`id\`
        WHERE \`task\`.\`accepted\` = 'NO' AND \`task\`.\`completed\` = 'NO'
    `);

    res.json(result);
});

app.get('/accepted/offers', async (req, res) => {

    let [result] = await pool.query(`
        SELECT *
        FROM \`task\`
            JOIN \`offer\` ON \`task\`.\`task_id\` = \`offer\`.\`offer_id\`
            JOIN \`citizen\` ON \`offer\`.\`offer_user\` = \`citizen\`.\`citizen_username\`
            JOIN \`user\` ON \`citizen\`.\`citizen_username\` = \`user\`.\`username\`
            JOIN \`product\` ON \`offer\`.\`product_id\` = \`product\`.\`id\`
            JOIN \`rescuer\` ON \`task\`.\`rescuer_took_over\` = \`rescuer\`.\`rescuer_username\`
        WHERE \`task\`.\`accepted\` = 'YES' AND \`task\`.\`completed\` = 'NO'
    `);

    res.json(result);
});

app.get('/unaccepted/offers', async (req, res) => {

    let [result] = await pool.query(`
        SELECT *
        FROM \`task\`
            JOIN \`offer\` ON \`task\`.\`task_id\` = \`offer\`.\`offer_id\`
            JOIN \`citizen\` ON \`offer\`.\`offer_user\` = \`citizen\`.\`citizen_username\`
            JOIN \`user\` ON \`citizen\`.\`citizen_username\` = \`user\`.\`username\`
            JOIN \`product\` ON \`offer\`.\`product_id\` = \`product\`.\`id\`
        WHERE \`task\`.\`accepted\` = 'NO' AND \`task\`.\`completed\` = 'NO'
    `);

    res.json(result);
});

app.get('/vehicles/active_tasks/:admin', async (req, res) => {
    let admin = req.params.admin;

    let [result] = await pool.query(`
        SELECT * 
        FROM \`admin\` 
            JOIN \`base\` ON \`admin\`.\`base\` = \`base\`.\`base_name\`
        WHERE \`admin_username\` = ?
    `, [admin]);

    let base = result[0].base;

    [result] = await pool.query(`
        SELECT *
        FROM \`rescuer\`
            JOIN \`task\` ON \`rescuer\`.\`rescuer_username\` = \`task\`.\`rescuer_took_over\` 
            JOIN \`user\` ON \`rescuer\`.\`rescuer_username\` = \`user\`.\`username\`
        WHERE \`rescuer\`.\`base\` = ? AND \`task\`.\`completed\`= 'NO'
    `, [base]);

    res.json(result);
});

app.get('/vehicles/no_active_tasks/:admin', async (req, res) => {
    let admin = req.params.admin;

    let [result] = await pool.query(`
        SELECT * 
        FROM \`admin\` 
            JOIN \`base\` ON \`admin\`.\`base\` = \`base\`.\`base_name\`
        WHERE \`admin_username\` = ?
    `, [admin]);

    let base = result[0].base;

    [result] = await pool.query(`
        SELECT \`rescuer_username\`, \`vehicle\`, \`vehicle_location\`, \`base\`, \`user\`.\`first_name\`, \`user\`.\`last_name\`, \`user\`.\`phone_num\`
        FROM \`rescuer\`
            JOIN \`user\` ON \`rescuer\`.\`rescuer_username\` = \`user\`.\`username\`
            LEFT JOIN \`task\` ON \`rescuer\`.\`rescuer_username\` = \`task\`.\`rescuer_took_over\` 
        WHERE \`rescuer\`.\`base\` = ? AND \`task\`.\`task_id\` IS NULL
    `, [base]);

    res.json(result);
});

app.post('/new_category/:admin/:category', async (req, res) => {
    try{
        let admin = req.params.admin;
        let category = req.params.category;

        let [result] = await pool.query(`
            SELECT * 
            FROM \`admin\` 
                JOIN \`base\` ON \`admin\`.\`base\` = \`base\`.\`base_name\`
            WHERE \`admin_username\` = ?
        `, [admin]);

        let base = result[0].base;

        await pool.query(`CALL newCategory(?, ?)`, [category, base])
        res.send('success');
    }catch(err){
        res.send('fail');
    }
});

app.get('/base/categories/:admin', async (req, res) => {
    let admin = req.params.admin;

    let [result] = await pool.query(`
        SELECT * 
        FROM \`admin\` 
            JOIN \`base\` ON \`admin\`.\`base\` = \`base\`.\`base_name\`
        WHERE \`admin_username\` = ?
    `, [admin]);

    let base = result[0].base;

    [result] = await pool.query(`
        SELECT *
        FROM \`has_category\` 
            JOIN \`category\` ON \`has_category\`.\`category\` = \`category\`.\`category_id\`
        WHERE \`base\` = ?
        ORDER BY \`category\`.\`category_name\`
    `, [base]);

    res.json(result);
});

app.post('/new_product', async (req, res) => {
    const receivedData = req.body;

    let [result] = await pool.query(`
        SELECT *
        FROM \`product\`
        WHERE \`product_name\` = ?
    `, [receivedData.product_name]);

    if(result.length == 0){
        await pool.query(`
            INSERT INTO \`product\` VALUES 
            (NULL, ?, ?, ?)
        `, [receivedData.product_name, receivedData.product_description, receivedData.product_category]);

        res.send('success');
    }else{
        res.send('product_already_exists');
    }
});

app.post('/update_inventory/:admin', async (req, res) => {
    let receivedData = req.body;
    let admin = req.params.admin;

    let [result] = await pool.query(`
        SELECT * 
        FROM \`admin\` 
            JOIN \`base\` ON \`admin\`.\`base\` = \`base\`.\`base_name\`
        WHERE \`admin_username\` = ?
    `, [admin]);

    let base = result[0].base;

    receivedData.forEach(async item => {
        await pool.query(`
            UPDATE \`base_inventory\`
            SET \`quantity\` = ?
            WHERE \`base\` = ? AND \`product_id\` = ?
        `, [ item.quantity, base, item.product_id]);
    });

    res.send('success');
});

app.get('/displayBaseInventory/admin/:admin/:category_id', async (req, res) => {
    
    let admin = req.params.admin;
    let category = req.params.category_id;

    let [result] = await pool.query(`
    SELECT * 
    FROM \`admin\` 
        JOIN \`base\` ON \`admin\`.\`base\` = \`base\`.\`base_name\`
    WHERE \`admin_username\` = ?
    `, [admin]);

    let base = result[0].base;

    [result] = await pool.query(`CALL displayBaseInventory(?, ?)`, [base, category]);

    res.json(result);
    
});

app.get('/citizen/announcements', async (req, res) => {
    const [result] = await pool.query(`
        SELECT \`product\`.\`product_name\` 
        FROM \`product\`
        JOIN \`announcment\` ON \`announcment\`.\`product_id\` = \`product\`.\`id\`
    `);

    res.json(result);
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});