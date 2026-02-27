import 'dotenv/config';
import {Pool} from 'pg';
import {env} from './env';
import logger from './logger';
const pool = new Pool({
    connectionString:env.DATABASE_URL
})

console.log("DATABASE_URL=",env.DATABASE_URL)

 export async function testConnection(){
    try{
        await pool.connect();
        logger.info("Database connected sucessfully")
    }
    catch(error){
        logger.error("Error connecting database");
        throw error;

    }
}

export default pool;