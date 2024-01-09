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

app.get('/base_location/admin/:admin', async (req, res) => {
    let admin = req.params.admin;

    let [result] = await pool.query(`
        SELECT *
        FROM \`base\` 
            JOIN \`admin\` ON \`admin\`.\`base\` = \`base\`.\`base_name\`
        WHERE \`admin_username\` = ?
    `, [admin]);

    res.json(result[0]);
})

app.get('/base_location/rescuer/:rescuer', async (req, res) => {
    let rescuer = req.params.rescuer;

    let [result] = await pool.query(`
        SELECT *
        FROM \`base\` 
            JOIN \`rescuer\` ON \`rescuer\`.\`base\` = \`base\`.\`base_name\`
        WHERE \`rescuer_username\` = ?
    `, [rescuer]);

    res.json(result[0]);
})

app.get('/rescuer_location/:rescuer', async (req, res) => {
    let rescuer = req.params.rescuer;

    let [result] = await pool.query(`
        SELECT *
        FROM \`rescuer\`
        WHERE \`rescuer_username\` = ?
    `, [rescuer]);

    res.json(result[0]);
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
    
    res.json(result[0]);
});

app.get('/citizen/announcements', async (req, res) => {
    const [result] = await pool.query(`
        SELECT *
        FROM \`announcement\`
            JOIN \`product\` ON \`announcement\`.\`product_id\` = \`product\`.\`id\`
        ORDER BY \`announcement\`.\`announcement_id\`
    `);

    res.json(result);
});

app.post('/change_base_location/:lat/:lng/:admin', async (req, res) => {
    let admin = req.params.admin;
    let lat = parseFloat(req.params.lat);
    let lng = parseFloat(req.params.lng);

    let [result] = await pool.query(`
        SELECT * 
        FROM \`admin\` 
            JOIN \`base\` ON \`admin\`.\`base\` = \`base\`.\`base_name\`
        WHERE \`admin_username\` = ?
    `, [admin]);

    let base = result[0].base;

    await pool.query(`
        UPDATE \`base\`
        SET \`base_location\` = ST_GeomFromText('POINT(${lat} ${lng})')
        WHERE \`base_name\` = ?
    `, [base]);

    res.send('success');
});

app.post('/new_announcement/:admin', async (req, res) => {
    let admin = req.params.admin;
    let receivedData = req.body;

    let [result] = await pool.query(`
        SELECT * 
        FROM \`admin\` 
            JOIN \`base\` ON \`admin\`.\`base\` = \`base\`.\`base_name\`
        WHERE \`admin_username\` = ?
    `, [admin]);

    let base = result[0].base;

    await pool.query(`
        CALL addAnnouncement(?, ?, 'NEW')
    `, [base, receivedData[0]]);

    receivedData = receivedData.slice(1);
    if(receivedData.length > 0){
        receivedData.forEach(async item => {
            await pool.query(`
                CALL addAnnouncement(?, ?, 'LAST')
            `, [base, item]);
        });
        res.send('success');
    }else{
        res.send('success');
    }
});

app.get('/coordinates_for_map_lines/:admin', async (req, res) => {
    let admin = req.params.admin;

    let [result] = await pool.query(`
        SELECT * 
        FROM \`admin\` 
            JOIN \`base\` ON \`admin\`.\`base\` = \`base\`.\`base_name\`
        WHERE \`admin_username\` = ?
    `, [admin]);

    let base = result[0].base;

    [result] = await pool.query(`
        SELECT \`rescuer\`.\`vehicle_location\` AS rescuer_location, \`citizen\`.\`citizen_location\` AS citizen_location
        FROM \`rescuer\`
            JOIN \`task\` ON \`rescuer\`.\`rescuer_username\` = \`task\`.\`rescuer_took_over\`
            JOIN \`request\` ON \`task\`.\`task_id\` = \`request\`.\`request_id\`
            JOIN \`citizen\` ON \`citizen\`.\`citizen_username\` = \`request\`.\`request_user\`
        WHERE \`rescuer\`.\`base\` = 'PATRA_BASE1'
        UNION
        SELECT \`rescuer\`.\`vehicle_location\` AS rescuer_location, \`citizen\`.\`citizen_location\` AS citizen_location
        FROM \`rescuer\`
            JOIN \`task\` ON \`rescuer\`.\`rescuer_username\` = \`task\`.\`rescuer_took_over\`
            JOIN \`offer\` ON \`task\`.\`task_id\` = \`offer\`.\`offer_id\`
            JOIN \`citizen\` ON \`citizen\`.\`citizen_username\` = \`offer\`.\`offer_user\`
        WHERE \`rescuer\`.\`base\` = 'PATRA_BASE1'
    `, [base]);

    res.json(result);
})

app.post('/change_rescuer_location/:lat/:lng/:rescuer', async (req, res) => {
    let rescuer = req.params.rescuer;
    let lat = parseFloat(req.params.lat);
    let lng = parseFloat(req.params.lng);

    let [result] = await pool.query(`
        SELECT *
        FROM \`base\` 
            JOIN \`rescuer\` ON \`rescuer\`.\`base\` = \`base\`.\`base_name\`
        WHERE \`rescuer_username\` = ?
    `, [rescuer]);

    let base = result[0].base;

    await pool.query(`
        UPDATE \`rescuer\`
        SET \`vehicle_location\` = ST_GeomFromText('POINT(${lat} ${lng})')
        WHERE \`rescuer_username\` = ?
    `, [rescuer]);

    res.send('success');
});

app.post('/accept_task/:task/:rescuer', async (req, res) => {
    let rescuer = req.params.rescuer;
    let task = req.params.task;

    try{
        await pool.query(`
            CALL rescuerAcceptTask(?, ?)
        `, [rescuer, task]);

        res.send('success');
    }catch(err){
        res.send('fail');
    }
});

app.get('/rescuer_active_tasks/requests/:rescuer', async (req, res) => {
    let rescuer = req.params.rescuer;

    let [result] = await pool.query(`
        SELECT *
        FROM \`rescuer\`
            JOIN \`task\` ON \`rescuer\`.\`rescuer_username\` = \`task\`.\`rescuer_took_over\`
            JOIN \`request\` ON \`task\`.\`task_id\` = \`request\`.\`request_id\`
            JOIN \`product\` ON \`request\`.\`product_id\` = \`product\`.\`id\`
            JOIN \`citizen\` ON \`request\`.\`request_user\` = \`citizen\`.\`citizen_username\`
            JOIN \`user\` ON \`citizen\`.\`citizen_username\` = \`user\`.\`username\` 
        WHERE \`rescuer\`.\`rescuer_username\` = ? AND \`task\`.\`completed\` = 'NO'
    `, [rescuer]);

    res.json(result);
});

app.get('/rescuer_active_tasks/offers/:rescuer', async (req, res) => {
    let rescuer = req.params.rescuer;

    let [result] = await pool.query(`
        SELECT *
        FROM \`rescuer\`
            JOIN \`task\` ON \`rescuer\`.\`rescuer_username\` = \`task\`.\`rescuer_took_over\`
            JOIN \`offer\` ON \`task\`.\`task_id\` = \`offer\`.\`offer_id\`
            JOIN \`product\` ON \`offer\`.\`product_id\` = \`product\`.\`id\`
            JOIN \`citizen\` ON \`offer\`.\`offer_user\` = \`citizen\`.\`citizen_username\`
            JOIN \`user\` ON \`citizen\`.\`citizen_username\` = \`user\`.\`username\` 
        WHERE \`rescuer\`.\`rescuer_username\` = ? AND \`task\`.\`completed\` = 'NO'
    `, [rescuer]);

    res.json(result);
});


app.post('/cancel_task/:task/:rescuer', async (req, res) => {
    let rescuer = req.params.rescuer;
    let task = req.params.task;

    await pool.query(`
        CALL rescuerCancelTask(?, ?)
    `, [rescuer, task]);

    res.send('success');
});

app.get('/citizen_completed_tasks/requests/:citizen', async (req, res) => {
    let citizen = req.params.citizen;

    let [result] = await pool.query(`
        SELECT *
        FROM \`citizen\`
            JOIN \`request\` ON \`citizen\`.\`citizen_username\` = \`request\`.\`request_user\`
            JOIN \`product\` ON \`request\`.\`product_id\` = \`product\`.\`id\`
            JOIN \`task\` ON \`request\`.\`request_id\` = \`task\`.\`task_id\`
            JOIN \`rescuer\` ON \`task\`.\`rescuer_took_over\` = \`rescuer\`.\`rescuer_username\`
            JOIN \`user\` ON \`rescuer\`.\`rescuer_username\` = \`user\`.\`username\`
        WHERE \`citizen\`.\`citizen_username\` = ? AND \`task\`.\`completed\` = 'YES'
    `, [citizen]);

    res.json(result);
});

app.post('/new_request/:product/:persons/:citizen', async (req, res) => {
    let citizen = req.params.citizen;
    let product = req.params.product;
    let persons = req.params.persons;

    await pool.query(`
        CALL newRequest(?, ?, ?)
    `, [citizen, product, persons]);

    res.send('success');
});

app.post('/complete_task/request/:task/:quantity/:rescuer', async (req, res) => {
    let rescuer = req.params.rescuer;
    let task = req.params.task;
    let quantity = req.params.quantity;

    await pool.query(`
        CALL rescuerUnloadCargoToCitizen(?, ?, ?)
    `, [rescuer, quantity, task]);

    res.send('success');
});

app.post('/complete_task/offer/:task/:rescuer', async (req, res) => {
    let rescuer = req.params.rescuer;
    let task = req.params.task;

    await pool.query(`
        CALL rescuerLoadCargoFromCitizen(?, ?)
    `, [rescuer, task]);

    res.send('success');
});

app.get('/citizen_active_tasks/requests/:citizen', async (req, res) => {
    let citizen = req.params.citizen;

    let [result] = await pool.query(`
        SELECT *
        FROM \`citizen\`
            JOIN \`request\` ON \`citizen\`.\`citizen_username\` = \`request\`.\`request_user\`
            JOIN \`product\` ON \`request\`.\`product_id\` = \`product\`.\`id\`
            JOIN \`task\` ON \`request\`.\`request_id\` = \`task\`.\`task_id\`
            JOIN \`rescuer\` ON \`task\`.\`rescuer_took_over\` = \`rescuer\`.\`rescuer_username\`
            JOIN \`user\` ON \`rescuer\`.\`rescuer_username\` = \`user\`.\`username\`
        WHERE \`citizen\`.\`citizen_username\` = ? AND \`task\`.\`completed\` = 'NO'
    `, [citizen]);

    res.json(result);
});

app.get('/citizen_location/:citizen', async (req, res) => {
    let citizen = req.params.citizen;

    let [result] = await pool.query(`
        SELECT *
        FROM \`citizen\`
        WHERE \`citizen_username\` = ?
    `, [citizen]);

    res.json(result[0]);
});

app.post('/cancel_request/:request/:citizen', async (req, res) => {
    let citizen = req.params.citizen;
    let request = req.params.request;

    await pool.query(`
        CALL citizenCancelRequest(?, ?)
    `, [citizen, request]);

    res.send('success');
});

app.post('/cancel_offer/:offer/:citizen', async (req, res) => {
    let citizen = req.params.citizen;
    let offer = req.params.offer;

    await pool.query(`
        CALL citizenCancelOffer(?, ?)
    `, [citizen, offer]);

    res.send('success');
});

app.get('/bases_info', async (req, res) => {
    let [result] = await pool.query(`
        SELECT *
        FROM \`base\`
    `);

    res.json(result);
});

app.get('/citizen_info/:citizen', async (req, res) => {
    let citizen = req.params.citizen;

    let [result] = await pool.query(`
        SELECT *
        FROM \`citizen\`
            JOIN \`user\` ON \`citizen\`.\`citizen_username\` = \`user\`.\`username\`
        WHERE \`citizen_username\` = ?
    `, [citizen]);

    res.json(result[0]);
});

app.get('/base_categories/:base', async (req, res) => {
    let base = req.params.base;

    let [result] = await pool.query(`
        SELECT *
        FROM \`has_category\`
            JOIN \`category\` ON \`has_category\`.\`category\` = \`category\`.\`category_id\`
        WHERE \`has_category\`.\`base\` = ?
        ORDER BY \`category\`.\`category_name\`
    `, [base]);

    res.json(result);
});

app.get('/base_products/:base', async (req, res) => {
    let base = req.params.base;

    let [result] = await pool.query(`
        SELECT *
        FROM \`has_category\`
            JOIN \`category\` ON \`has_category\`.\`category\` = \`category\`.\`category_id\`
            JOIN \`product\` ON \`category\`.\`category_id\` = \`product\`.\`category\`
        WHERE \`has_category\`.\`base\` = ?
        ORDER BY \`product\`.\`product_name\`
    `, [base]);

    res.json(result);
});

app.get('/base_products/:base/:category', async (req, res) => {
    let base = req.params.base;
    let category = req.params.category;

    let [result] = await pool.query(`
        SELECT *
        FROM \`has_category\`
            JOIN \`category\` ON \`has_category\`.\`category\` = \`category\`.\`category_id\`
            JOIN \`product\` ON \`category\`.\`category_id\` = \`product\`.\`category\` 
        WHERE \`has_category\`.\`base\` = ? AND \`product\`.\`category\` = ?
        ORDER BY \`product\`.\`product_name\`
    `, [base, category]);

    res.json(result);

});

app.post('/new_offer/:product/:quantity/:citizen', async (req, res) => {
    let citizen = req.params.citizen;
    let product = req.params.product;
    let quantity = req.params.quantity;

    await pool.query(`
        CALL newOffer(?, ?, ?)
    `, [citizen, product, quantity]);

    res.send('success');
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});