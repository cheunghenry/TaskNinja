const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

// Create an Express app
const app = express();

app.use(cors());

// Connect to the database
const pool = new Pool({
  user: 'SQLUser',
  password: 'JV.N<}L-NQb@L=tR',
  host: '35.192.8.81',
  database: 'shuriken',
  port: 5432,
});


app.get('/userID', async (req, res) => {
    try {
      const result = await pool.query('SELECT * FROM Users');
      res.json(result.rows);
    } catch (err) {
      console.error(err);
      res.status(500).send('Error retrieving users from database');
    }
});

app.post('/users/new', async (req,res) => {
    const {username, email} = req.body;
    const checkresult = await pool.query('SELECT * FROM Users WHERE username = $1', [username])
    if(checkresult.rows.length > 0){
        res.status(400).send('Username is already taken');
        return;
    }
    try {
        const result = await pool.query('INSERT INTO Users (username, email) VALUES ($1,$2) RETURNING *', [username, email]);
        res.status(201).json(result.rows[0])
    }catch(err){
        console.error('Error inserting new user: ', err);
        res.status(500).json({'error': 'Error inserting new user'});
    }
});

app.get('/getuserid', async(req,res) => {
    const { email } = req.query;
    try {
      const result = await pool.query('SELECT userid FROM Users WHERE email = $1', [email]);
      res.json(result.rows);
    } catch (err) {
      console.error(err);
      res.status(500).send('Error retrieving userid from database');
    }
})

app.delete('/users/delete', async (req,res) => {
    const userId = req.params.id;
    pool.query('DELETE FROM Users WHERE id = $1', [userId], (error, results) => {
        if(error) {
            throw error;
        }
        res.status(200).send(`User with ID: ${userId} deleted successfully.`);
    });
});

app.post('/createshurikenlist', async(req, res) => {
    const { userID } = req.body;
    const tableName = `${userID}` + 'ShurikenList';
    
    try{
      const createTableQuery = `CREATE TABLE "${tableName}" (ShurikenID varchar(128) PRIMARY KEY, Title varchar(128), UserID varchar(128))`;
  
      const client = await pool.connect();
      await client.query(createTableQuery);
      client.release();
  
      res.status(200).send(`Table "${tableName}" created successfully!`);
    } catch(err){
      console.error(err);
      res.status(500).send(userID);
    }
});

app.post('/newshuriken', async(req,res) => {
    const { userID, shurikenName } = req.body;
    let shurikenID = `${shurikenName}${userID}`;
    const tableName = `${userID}` + 'ShurikenList';
    try {
        const result = await pool.query(`INSERT INTO "${tableName}" (ShurikenID, Title, UserID) VALUES ($1,$2,$3) RETURNING *`, [shurikenID, shurikenName, userID]);
        res.status(201).json(result.rows[0])
    }catch(err){
        console.error('Error inserting new shuriken: ', err);
        res.status(500).json({'error': 'Error inserting new shuriken'});
    }
})

app.get('/getshurikens', async(req,res) => {
    const { userID } = req.query;
    const tableName = `${userID}` + 'ShurikenList'
    try {
      const result = await pool.query(`SELECT Title FROM "${tableName}"`);
      res.json(result.rows);
    } catch (err) {
      console.error(err);
      res.status(500).send('Error retrieving users from database');
    }
})

app.post('/createtasklist', async(req, res) => {
    const { shurikenID } = req.body;
    const tableName = `${shurikenID}` + 'TaskList';
    
    try{
      const createTableQuery = `CREATE TABLE "${tableName}" (TaskID varchar(128) PRIMARY KEY, Title varchar(128), Description varchar(255), Assignees varchar(128), ShurikenID varchar(128))`;
  
      const client = await pool.connect();
      await client.query(createTableQuery);
      client.release();
  
      res.status(200).send(`Table "${tableName}" created successfully!`);
    } catch(err){
      console.error(err);
      res.status(500).send('Error creating table');
    }
});

app.get('/gettasks', async(req,res) => {
    const { shurikenID } = req.query;
    const tableName = `${shurikenID}` + 'TaskList'
    try {
      const result = await pool.query(`SELECT Title FROM "${tableName}"`);
      res.json(result.rows);
    } catch (err) {
      console.error(err);
      res.status(500).send('Error retrieving users from database');
    }
})

app.post('/newtask', async(req,res) => {
    const { shurikenID, taskName, taskDesc, taskAssignees } = req.body;
    let taskID = `${taskName}${shurikenID}`;
    const tableName = `${shurikenID}` + 'TaskList'
    try {
        const result = await pool.query(`INSERT INTO "${tableName}" (TaskID, Title, Description, Assignees, ShurikenID) VALUES ($1,$2,$3,$4,$5) RETURNING *`, [taskID, taskName, taskDesc, taskAssignees, shurikenID]);
        res.status(201).json(result.rows[0])
    }catch(err){
        console.error('Error inserting new task: ', err);
        res.status(500).json({'error': 'Error inserting new task'});
    }
})

app.put('/updatetask', async (req, res) => {
    const { oldTitle, title, description, assignees, shurikenID } = req.body;
    const oldTaskId = `${oldTitle}` + `${shurikenID}`;
    const newTaskId = `${title}` + `${shurikenID}`;
    const tableName = `${shurikenID}` + 'TaskList'
    try {
      const result = await pool.query(`UPDATE "${tableName}" SET TaskID = $1, Title = $2, Description = $3, Assignees = $4 WHERE TaskID = $5 RETURNING *`, [newTaskId,title, description, assignees, oldTaskId]);
      res.json(result.rows[0]);
    } catch (err) {
      console.error(err);
      res.status(500).send('Error updating task in database');
    }
  });

exports.taskninjafunction = app;