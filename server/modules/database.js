db = require("mysql2")

class Database {
    constructor (config) {
        this._pool = db.createPool({
            connectionLimit: 10,
            waitForConnections: true,
            host: config.host,
            user: config.user,
            password: config.password,
            database: config.database
        })
    }

    async RunQuery(sql,options) {
        try {
            const [rows, fields] = await this._pool.promise().query(sql,options)
            return rows
        }
        catch(error) {
            console.error(error)
        }
    }
}

module.exports = Database