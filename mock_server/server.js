
const express = require('express');
const https = require('https');
const fs = require('fs');
const app = express();
let users = [
    { id: 1, name: 'Truong Ba Cuong', age: 24, role: 'Intern', imageURL: 'https://images.media.io/pixpic-styles/male_id_photo.png?task_id=1225012', email: 'bacuong312@gmail.com', phone: '0827043260' },
    { id: 2, name: 'Pham Minh Quang', age: 22 , role: 'Contractual employee', imageURL: 'https://images.media.io/pixpic-web/styles/20231107/male_LinkedIn.png', email: 'minhquang123@gmail.com', phone: '0988598264'},
    { id: 3, name: 'Pham Quynh Trang', age: 23 , role: 'HR Manager', imageURL: 'https://images.media.io/pixpic-web/styles/20231107/female_Badge_Photo.png', email: 'trangpham23@gmail.com', phone: '0914657233'},
    { id: 4, name: 'Hoang Duc Long', age: 28 , role: 'Executive', imageURL: 'https://images.media.io/pixpic-styles/TagFileID2950870_designer_web.png?task_id=1263503', email: 'longhoang231@gmail.com', phone: '0945951333'},
];
// Define a route
app.get('/api/staffs', (req, res) => {
    res.json(users);
});
app.get('/api/staffs/:id', (req, res) => {
    const id = parseInt(req.params.id, 10);
    const user = users.find(u => u.id === id);
    if (user) {
        res.json(user);
    } else {
        res.status(404).send('User not found');
    }
});
const options = {
    key: fs.readFileSync('./key.pem'),
    cert: fs.readFileSync('./cert.pem')
};
// Start the server
const port = 8443;
https.createServer(options, app)
    .listen(port, () => console.log(`Mock server is running on https://localhost:${port}`));